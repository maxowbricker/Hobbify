import SwiftUI
import CoreData

struct DashboardView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject private var hobbyState = HobbyState.shared
    
    private let ratingEmojis = ["😞", "😕", "😐", "🙂", "😊"]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HobbySelector()
                    .zIndex(1)
                
                if hobbyState.selectedHobby != nil {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            // Overview / On a Roll
                            CardView {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("On a Roll!")
                                        .font(.headline)
                                    HStack(alignment: .top, spacing: 16) {
                                        Image(systemName: "flame.fill")
                                            .resizable()
                                            .frame(width: 48, height: 48)
                                            .foregroundColor(.orange)
                                        VStack(alignment: .leading, spacing: 4) {
                                            HStack {
                                                VStack(alignment: .leading, spacing: 2) {
                                                    Text("Sessions\nper week")
                                                        .font(.caption2)
                                                        .foregroundColor(.secondary)
                                                    // Placeholder for bar chart
                                                    RoundedRectangle(cornerRadius: 2)
                                                        .fill(Color.gray.opacity(0.3))
                                                        .frame(width: 80, height: 24)
                                                }
                                                Spacer()
                                                VStack(alignment: .leading, spacing: 2) {
                                                    Text("Goal: 5")
                                                        .font(.caption2)
                                                        .foregroundColor(.secondary)
                                                    Text("4/5")
                                                        .font(.headline)
                                                        .foregroundColor(.primary)
                                                }
                                            }
                                        }
                                    }
                                    Text("10 Weeks in a Row!")
                                        .font(.caption)
                                    Text("Sessions this week: 4/5\nKeep up the good work!")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                            }
                            // Quick Actions
                            CardView {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Quick Actions")
                                        .font(.headline)
                                    HStack(spacing: 16) {
                                        QuickActionButton(icon: "square.and.pencil", label: "Log Activity")
                                        QuickActionButton(icon: "calendar.badge.plus", label: "Schedule\nsession")
                                        QuickActionButton(icon: "target", label: "Edit Goal")
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            // Last Activity
                            CardView {
                                LastActivityView(activity: fetchLastActivity())
                            }
                            // Upcoming Sessions
                            CardView {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Upcoming Sessions")
                                        .font(.headline)
                                    HStack(spacing: 16) {
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text("15/12/2025")
                                                .font(.caption)
                                            Text("Location: xxx")
                                                .font(.caption2)
                                                .foregroundColor(.secondary)
                                            Text("Session Duration: 1 hour")
                                                .font(.caption2)
                                                .foregroundColor(.secondary)
                                        }
                                        VStack(alignment: .leading, spacing: 2) {
                                            Text("18/12/2025")
                                                .font(.caption)
                                            Text("Location: xxx")
                                                .font(.caption2)
                                                .foregroundColor(.secondary)
                                            Text("Session Duration: 2 hour")
                                                .font(.caption2)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                            // Milestones and Skills
                            CardView {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Milestones and Skills")
                                        .font(.headline)
                                    Text("Delay look of this one because we need to design milestones and skills page first")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                    }
                } else {
                    VStack {
                        Text("Select a hobby to view its dashboard")
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private func fetchLastActivity() -> Activity? {
        guard let hobby = hobbyState.selectedHobby else { return nil }
        
        let request = NSFetchRequest<Activity>(entityName: "Activity")
        request.predicate = NSPredicate(format: "hobby == %@", hobby)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Activity.date, ascending: false)]
        request.fetchLimit = 1
        
        do {
            let activities = try viewContext.fetch(request)
            return activities.first
        } catch {
            print("Error fetching last activity: \(error)")
            return nil
        }
    }
    
    private func formatDuration(_ duration: Double) -> String {
        let hours = Int(duration)
        let minutes = Int((duration.truncatingRemainder(dividingBy: 1)) * 60)
        return "\(hours)h \(minutes)m"
    }
}

struct CardView<Content: View>: View {
    let content: () -> Content
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            content()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct QuickActionButton: View {
    let icon: String
    let label: String
    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.systemGray5))
                    .frame(width: 48, height: 48)
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.accentColor)
            }
            Text(label)
                .font(.caption2)
                .multilineTextAlignment(.center)
        }
        .frame(width: 64)
    }
}

struct LastActivityView: View {
    let activity: Activity?
    private let ratingEmojis = ["😞", "😕", "😐", "🙂", "😊"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Last Activity")
                .font(.headline)
            
            if let activity = activity {
                NavigationLink {
                    ActivityDetailView(activity: activity)
                } label: {
                    HStack(alignment: .center, spacing: 12) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(activity.title ?? "Untitled Activity")
                                .font(.subheadline)
                                .bold()
                            Text(activity.date ?? Date(), style: .date)
                                .font(.caption)
                                .foregroundColor(.secondary)
                            if let location = activity.location, !location.isEmpty {
                                Label(location, systemImage: "location")
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                            }
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 4) {
                            Label(formatDuration(activity.duration), systemImage: "clock")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                            if activity.rating > 0 {
                                Text(ratingEmojis[Int(activity.rating) - 1])
                                    .font(.title3)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(PlainButtonStyle())
            } else {
                Text("No activities recorded yet")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 12)
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    private func formatDuration(_ duration: Double) -> String {
        let hours = Int(duration)
        let minutes = Int((duration.truncatingRemainder(dividingBy: 1)) * 60)
        return "\(hours)h \(minutes)m"
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}