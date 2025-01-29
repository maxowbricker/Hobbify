import SwiftUI
import PhotosUI

struct NewActivitySheet: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var description = ""
    @State private var startTime = Date()
    @State private var endTime = Date().addingTimeInterval(3600) // Default 1 hour later
    @State private var location = ""
    @State private var selectedTags: [String] = []
    @State private var rating: Int = 3
    @State private var notes = ""
    @State private var cost: Double = 0.0
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var selectedImages: [UIImage] = []
    
    @State private var showingTagManagement = false
    
    private let ratingEmojis = ["😞", "😕", "😐", "🙂", "😊"]
    
    private var duration: Double {
        endTime.timeIntervalSince(startTime) / 3600 // Convert seconds to hours
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Basic Information")) {
                    TextField("Title*", text: $title)
                    TextField("Brief Description", text: $description)
                    
                    DatePicker("Start Time*", selection: $startTime)
                        .onChange(of: startTime) { newValue in
                            if newValue > endTime {
                                endTime = newValue.addingTimeInterval(3600)
                            }
                        }
                    
                    DatePicker("End Time*", selection: $endTime)
                        .onChange(of: endTime) { newValue in
                            if newValue < startTime {
                                startTime = newValue.addingTimeInterval(-3600)
                            }
                        }
                    
                    TextField("Location", text: $location)
                }
                
                Section(header: Text("Tags")) {
                    if !selectedTags.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(selectedTags, id: \.self) { tag in
                                    Text(tag)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 5)
                                        .background(Color.accentColor.opacity(0.2))
                                        .cornerRadius(15)
                                }
                            }
                        }
                    }
                    
                    Button("Manage Tags") {
                        showingTagManagement = true
                    }
                }
                
                Section(header: Text("Rating & Cost")) {
                    HStack {
                        Text("Rating")
                        Spacer()
                        ForEach(0..<5) { index in
                            Button(action: { rating = index }) {
                                Text(ratingEmojis[index])
                                    .opacity(rating == index ? 1.0 : 0.3)
                            }
                        }
                    }
                    
                    HStack {
                        Text("Cost")
                        TextField("$0.00", value: $cost, format: .currency(code: "").presentation(.narrow))
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                }
                
                Section(header: Text("Notes & Review")) {
                    TextField("Post-activity notes", text: $notes, axis: .vertical)
                        .lineLimit(4...8)
                }
                
                Section(header: Text("Media")) {
                    PhotosPicker(selection: $selectedItems, matching: .images) {
                        Label("Select Photos", systemImage: "photo.on.rectangle.angled")
                    }
                    
                    if !selectedImages.isEmpty {
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(0..<selectedImages.count, id: \.self) { index in
                                    Image(uiImage: selectedImages[index])
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("New Activity")
            .navigationBarItems(
                leading: Button("Cancel") { dismiss() },
                trailing: Button("Save") { saveActivity() }
                    .disabled(title.isEmpty || endTime <= startTime)
            )
            .sheet(isPresented: $showingTagManagement) {
                NavigationView {
                    TagManagementView(selectedTags: $selectedTags)
                }
            }
            .onChange(of: selectedItems) { _ in
                Task {
                    selectedImages = []
                    for item in selectedItems {
                        if let data = try? await item.loadTransferable(type: Data.self),
                           let image = UIImage(data: data) {
                            selectedImages.append(image)
                        }
                    }
                }
            }
        }
    }
    
    private func formatDuration(_ hours: Double) -> String {
        let totalMinutes = Int(hours * 60)
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60
        return "\(hours)h \(minutes)m"
    }
    
    private func saveActivity() {
        let newActivity = Activity(context: viewContext)
        newActivity.id = UUID()
        newActivity.title = title
        newActivity.desc = description
        newActivity.date = startTime // Use start time as the activity date
        newActivity.duration = duration
        newActivity.location = location
        newActivity.tags = selectedTags
        newActivity.rating = Int16(rating)
        newActivity.notes = notes
        newActivity.cost = NSDecimalNumber(value: cost)
        
        // Save images to documents directory and store URLs
        var mediaURLs: [URL] = []
        for (index, image) in selectedImages.enumerated() {
            if let imageURL = saveImage(image, index: index) {
                mediaURLs.append(imageURL)
            }
        }
        newActivity.mediaURLs = mediaURLs
        
        do {
            try viewContext.save()
            dismiss()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    private func saveImage(_ image: UIImage, index: Int) -> URL? {
        guard let data = image.jpegData(compressionQuality: 0.7) else { return nil }
        let filename = UUID().uuidString + "_\(index).jpg"
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        
        do {
            try data.write(to: fileURL)
            return fileURL
        } catch {
            print("Error saving image: \(error)")
            return nil
        }
    }
}

#Preview {
    NewActivitySheet()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
} 