import SwiftUI

struct DashboardView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var selectedHobby: Hobby?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HobbySelector(selectedHobby: $selectedHobby)
                    .zIndex(1) // Ensure selector stays on top
                
                if let hobby = selectedHobby {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            // Hobby Overview Section
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Overview")
                                    .font(.title2)
                                    .bold()
                                
                                HStack(spacing: 20) {
                                    StatCard(title: "Activities", value: "0")
                                    StatCard(title: "Hours", value: "0")
                                    StatCard(title: "Streak", value: "0")
                                }
                            }
                            .padding()
                            
                            // Recent Activity Section
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Recent Activity")
                                    .font(.title2)
                                    .bold()
                                
                                Text("No recent activity")
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                        }
                    }
                } else {
                    VStack {
                        Text("Select a hobby to view its dashboard")
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Dashboard")
                        .font(.headline)
                }
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack {
            Text(value)
                .font(.title)
                .bold()
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

#Preview {
    DashboardView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}