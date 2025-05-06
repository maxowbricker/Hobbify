import SwiftUI

struct AchievementsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject private var hobbyState = HobbyState.shared
    
    @FetchRequest private var achievements: FetchedResults<Achievement>
    
    init() {
        // Initialize with empty predicate, will be updated when hobby is selected
        _achievements = FetchRequest<Achievement>(
            sortDescriptors: [NSSortDescriptor(keyPath: \Achievement.dateEarned, ascending: false)],
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
                        updateAchievementsPredicate(for: newHobby)
                    }
                
                if let hobby = hobbyState.selectedHobby {
                    if achievements.isEmpty {
                        VStack(spacing: 20) {
                            Image(systemName: "trophy")
                                .font(.system(size: 60))
                                .foregroundColor(.secondary)
                            Text("No achievements yet")
                                .font(.title2)
                                .foregroundColor(.secondary)
                            Text("Complete activities and reach milestones to earn achievements")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                ForEach(achievements) { achievement in
                                    AchievementCard(achievement: achievement)
                                }
                            }
                            .padding()
                        }
                    }
                } else {
            VStack {
                        Text("Select a hobby to view its achievements")
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private func updateAchievementsPredicate(for hobby: Hobby?) {
        if let hobby = hobby {
            achievements.nsPredicate = NSPredicate(format: "hobby == %@", hobby)
        } else {
            achievements.nsPredicate = nil
        }
    }
}

struct AchievementCard: View {
    let achievement: Achievement
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "trophy.fill")
                    .font(.title2)
                    .foregroundColor(.yellow)
                Text(achievement.title ?? "")
                    .font(.headline)
                Spacer()
                Text(achievement.dateEarned ?? Date(), formatter: dateFormatter)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Text(achievement.desc ?? "")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            if let type = achievement.type {
                Text(type)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.1))
                    .foregroundColor(.blue)
                    .cornerRadius(8)
        }
    }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter
}()

#Preview {
    AchievementsView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
} 