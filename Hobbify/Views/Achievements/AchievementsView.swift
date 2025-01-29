import SwiftUI

struct AchievementsView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Achievements Coming Soon")
                    .font(.headline)
            }
            .navigationTitle("Achievements")
        }
    }
}

#Preview {
    AchievementsView()
} 