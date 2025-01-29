import SwiftUI

struct TagManagementView: View {
    @Binding var selectedTags: [String]
    @State private var newTag: String = ""
    @State private var savedTags: [String] = UserDefaults.standard.stringArray(forKey: "savedTags") ?? []
    
    var body: some View {
        List {
            Section(header: Text("Add New Tag")) {
                HStack {
                    TextField("New tag", text: $newTag)
                    Button(action: addTag) {
                        Image(systemName: "plus.circle.fill")
                    }
                    .disabled(newTag.isEmpty)
                }
            }
            
            Section(header: Text("Available Tags")) {
                ForEach(savedTags, id: \.self) { tag in
                    HStack {
                        Text(tag)
                        Spacer()
                        if selectedTags.contains(tag) {
                            Image(systemName: "checkmark")
                                .foregroundColor(.accentColor)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        toggleTag(tag)
                    }
                }
                .onDelete(perform: deleteTags)
            }
        }
        .navigationTitle("Manage Tags")
    }
    
    private func addTag() {
        let tag = newTag.trimmingCharacters(in: .whitespacesAndNewlines)
        if !tag.isEmpty && !savedTags.contains(tag) {
            savedTags.append(tag)
            selectedTags.append(tag)
            newTag = ""
            saveTags()
        }
    }
    
    private func toggleTag(_ tag: String) {
        if selectedTags.contains(tag) {
            selectedTags.removeAll { $0 == tag }
        } else {
            selectedTags.append(tag)
        }
    }
    
    private func deleteTags(at offsets: IndexSet) {
        let tagsToDelete = offsets.map { savedTags[$0] }
        savedTags.remove(atOffsets: offsets)
        selectedTags.removeAll { tagsToDelete.contains($0) }
        saveTags()
    }
    
    private func saveTags() {
        UserDefaults.standard.set(savedTags, forKey: "savedTags")
    }
}

#Preview {
    NavigationView {
        TagManagementView(selectedTags: .constant([]))
    }
} 