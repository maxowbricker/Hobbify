import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "house.fill")
                }
                .tag(0)
            
            AchievementsView()
                .tabItem {
                    Label("Achievements", systemImage: "medal.fill")
                }
                .tag(1)
            
            ActivitiesView()
                .tabItem {
                    Label("Activities", systemImage: "figure.run.circle.fill")
                }
                .tag(2)
            
            PlanningView()
                .tabItem {
                    Label("Planning", systemImage: "calendar")
                }
                .tag(3)
        }
    }
}

#Preview {
    MainTabView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
} 