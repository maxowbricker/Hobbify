import SwiftUI

struct NewHobbyView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var desc = ""
    @State private var icon = "star.fill"
    @State private var color = "blue"
    
    let icons = ["star.fill", "heart.fill", "book.fill", "gamecontroller.fill", "music.note", "camera.fill", "paintbrush.fill", "dumbbell.fill", "bicycle", "airplane"]
    let colors = ["blue", "red", "green", "purple", "orange", "pink", "yellow"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Basic Information")) {
                    TextField("Hobby Name", text: $name)
                    TextField("Description", text: $desc)
                }
                
                Section(header: Text("Icon")) {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], spacing: 20) {
                        ForEach(icons, id: \.self) { iconName in
                            Image(systemName: iconName)
                                .font(.title)
                                .foregroundColor(icon == iconName ? Color(color) : .primary)
                                .frame(width: 60, height: 60)
                                .background(icon == iconName ? Color(color).opacity(0.2) : Color.clear)
                                .cornerRadius(10)
                                .onTapGesture {
                                    icon = iconName
                                }
                        }
                    }
                    .padding(.vertical)
                }
                
                Section(header: Text("Color")) {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))], spacing: 20) {
                        ForEach(colors, id: \.self) { colorName in
                            Circle()
                                .fill(Color(colorName))
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Circle()
                                        .stroke(Color.primary, lineWidth: color == colorName ? 2 : 0)
                                )
                                .onTapGesture {
                                    color = colorName
                                }
                        }
                    }
                    .padding(.vertical)
                }
            }
            .navigationTitle("New Hobby")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveHobby()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
    
    private func saveHobby() {
        let hobby = Hobby(context: viewContext)
        hobby.id = UUID()
        hobby.name = name
        hobby.desc = desc
        hobby.icon = icon
        hobby.color = color
        hobby.createdAt = Date()
        
        do {
            try viewContext.save()
            dismiss()
        } catch {
            print("Error saving hobby: \(error)")
        }
    }
}

#Preview {
    NewHobbyView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
} 