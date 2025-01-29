import SwiftUI

struct ActivitiesView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Activity.date, ascending: false)],
        animation: .default)
    private var activities: FetchedResults<Activity>
    
    @State private var showingNewActivity = false
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(activities) { activity in
                        ActivityCard(activity: activity)
                    }
                    .onDelete(perform: deleteActivities)
                }
                
                // Floating Action Button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: { showingNewActivity = true }) {
                            Image(systemName: "plus")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(width: 56, height: 56)
                                .background(Color.accentColor)
                                .clipShape(Circle())
                                .shadow(radius: 4)
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Activities")
            .sheet(isPresented: $showingNewActivity) { 
                NewActivitySheet()
            }
        }
    }
    
    private func deleteActivities(offsets: IndexSet) {
        withAnimation {
            offsets.map { activities[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

#Preview {
    ActivitiesView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
} 