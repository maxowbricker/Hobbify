import SwiftUI

struct PlanningView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var selectedHobby: Hobby?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HobbySelector(selectedHobby: $selectedHobby)
                    .zIndex(1)
                
                if let hobby = selectedHobby {
                    VStack {
                        Text("Planning Coming Soon")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    VStack {
                        Text("Select a hobby to view its planning")
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    PlanningView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
} 