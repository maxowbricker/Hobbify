import SwiftUI

struct PlanningView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject private var hobbyState = HobbyState.shared
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HobbySelector()
                    .zIndex(1)
                
                if hobbyState.selectedHobby != nil {
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