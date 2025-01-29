import SwiftUI

struct ActivityCard: View {
    let activity: Activity
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(activity.title ?? "")
                    .font(.headline)
                Spacer()
                Text(activity.date ?? Date(), style: .date)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            if let notes = activity.notes, !notes.isEmpty {
                Text(notes)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            HStack {
                Label(formatDuration(activity.duration), systemImage: "clock")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                if let urls = activity.mediaURLs as? [URL], !urls.isEmpty {
                    Label("\(urls.count) media", systemImage: "photo")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
    
    private func formatDuration(_ duration: Double) -> String {
        let hours = Int(duration)
        let minutes = Int((duration.truncatingRemainder(dividingBy: 1)) * 60)
        return "\(hours)h \(minutes)m"
    }
} 