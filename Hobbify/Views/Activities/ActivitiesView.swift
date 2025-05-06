import SwiftUI

struct ActivitiesView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject private var hobbyState = HobbyState.shared
    @State private var showingNewActivity = false
    
    @FetchRequest private var activities: FetchedResults<Activity>
    
    init() {
        // Initialize with empty predicate, will be updated when hobby is selected
        _activities = FetchRequest<Activity>(
            sortDescriptors: [NSSortDescriptor(keyPath: \Activity.date, ascending: false)],
            predicate: nil,
            animation: .default
        )
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HobbySelector()
                    .zIndex(1)
                    .onChange(of: hobbyState.selectedHobby) { newHobby in
                        updateActivitiesPredicate(for: newHobby)
                    }
                
                if let hobby = hobbyState.selectedHobby {
            ZStack {
                        if activities.isEmpty {
                            VStack {
                                Text("No activities yet")
                                    .foregroundColor(.secondary)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else {
                List {
                    ForEach(activities) { activity in
                        ActivityCard(activity: activity)
                    }
                    .onDelete(perform: deleteActivities)
                            }
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
                } else {
                    VStack {
                        Text("Select a hobby to view its activities")
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingNewActivity) { 
                NewActivitySheet()
            }
        }
    }
    
    private func updateActivitiesPredicate(for hobby: Hobby?) {
        if let hobby = hobby {
            activities.nsPredicate = NSPredicate(format: "hobby == %@", hobby)
        } else {
            activities.nsPredicate = nil
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