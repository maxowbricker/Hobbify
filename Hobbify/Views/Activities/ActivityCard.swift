import SwiftUI

struct ActivityCard: View {
    let activity: Activity
    
    private let ratingEmojis = ["😞", "😕", "😐", "🙂", "😊"]
    
    var body: some View {
        NavigationLink(destination: ActivityDetailView(activity: activity)) {
            VStack(alignment: .leading, spacing: 0) {
                // Title and Date
                Text(activity.title ?? "")
                    .font(.headline)
                Spacer().frame(height: 8)
                Text(activity.date ?? Date(), style: .date)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer().frame(height: 4)
                HStack {
                    Label(formatDuration(activity.duration), systemImage: "clock")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                    if activity.rating > 0 && activity.rating <= ratingEmojis.count {
                        Text(ratingEmojis[Int(activity.rating) - 1])
                            .font(.title2)
                            .padding(.trailing, 2)
                    }
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(radius: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func formatDuration(_ duration: Double) -> String {
        let hours = Int(duration)
        let minutes = Int((duration.truncatingRemainder(dividingBy: 1)) * 60)
        return "\(hours)h \(minutes)m"
    }
} 