import SwiftUI

struct DashboardView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Dashboard Coming Soon")
                    .font(.headline)
            }
            .navigationTitle("Dashboard")
        }
    }
}

#Preview {
    DashboardView()
} 