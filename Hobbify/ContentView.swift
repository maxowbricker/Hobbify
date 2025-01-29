//
//  ContentView.swift
//  Hobbify
//
//  Created by Max Bricker on 27/1/2025.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Activity.date, ascending: false)],
        animation: .default)
    private var activities: FetchedResults<Activity>

    var body: some View {
        NavigationView {
            List {
                ForEach(activities) { activity in
                    NavigationLink {
                        Text("Activity: \(activity.title ?? "")")
                    } label: {
                        VStack(alignment: .leading) {
                            Text(activity.title ?? "")
                                .font(.headline)
                            Text(activity.date ?? Date(), formatter: dateFormatter)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .onDelete(perform: deleteActivities)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: { showNewActivity() }) {
                        Label("Add Activity", systemImage: "plus")
                    }
                }
            }
            Text("Select an activity")
        }
    }

    private func showNewActivity() {
        // This will be implemented when we add the NewActivitySheet
    }

    private func deleteActivities(offsets: IndexSet) {
        withAnimation {
            offsets.map { activities[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
}()

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
