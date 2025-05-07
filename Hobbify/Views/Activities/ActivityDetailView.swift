import SwiftUI

struct ActivityDetailView: View {
    let activity: Activity
    @Environment(\.dismiss) private var dismiss
    @State private var showingImageFullScreen = false
    @State private var selectedImage: UIImage?
    
    private let ratingEmojis = ["😞", "😕", "😐", "🙂", "😊"]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header Section
                VStack(alignment: .leading, spacing: 8) {
                    Text(activity.title ?? "")
                        .font(.title)
                        .bold()
                    
                    Text(activity.date ?? Date(), style: .date)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                
                // Description Section
                if let desc = activity.desc, !desc.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description")
                            .font(.headline)
                        Text(desc)
                            .font(.body)
                    }
                    .padding(.horizontal)
                }
                
                // Stats Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Activity Details")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    VStack(spacing: 0) {
                        DetailRow(icon: "clock", title: "Duration", value: formatDuration(activity.duration))
                        
                        if let location = activity.location, !location.isEmpty {
                            DetailRow(icon: "location", title: "Location", value: location)
                        }
                        
                        if activity.rating > 0 {
                            DetailRow(icon: "star", title: "Rating", value: ratingEmojis[Int(activity.rating) - 1])
                        }
                        
                        if let cost = activity.cost as? Double, cost > 0 {
                            DetailRow(icon: "dollarsign.circle", title: "Cost", value: cost)
                        }
                    }
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(radius: 2)
                    .padding(.horizontal)
                }
                
                // Tags Section
                if let tags = activity.tags, !tags.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Tags")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(tags, id: \.self) { tag in
                                    Text(tag)
                                        .font(.subheadline)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(Color.accentColor.opacity(0.2))
                                        .cornerRadius(15)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                
                // Notes Section
                if let notes = activity.notes, !notes.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Notes")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        Text(notes)
                            .font(.body)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.systemBackground))
                            .cornerRadius(12)
                            .shadow(radius: 2)
                            .padding(.horizontal)
                    }
                }
                
                // Media Section
                if let urls = activity.mediaURLs, !urls.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Photos")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(urls, id: \.self) { url in
                                    if let image = UIImage(contentsOfFile: url.path) {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 200, height: 200)
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                            .onTapGesture {
                                                selectedImage = image
                                                showingImageFullScreen = true
                                            }
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .padding(.vertical)
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingImageFullScreen) {
            if let image = selectedImage {
                ImageFullScreenView(image: image)
            }
        }
    }
    
    private func formatDuration(_ duration: Double) -> String {
        let hours = Int(duration)
        let minutes = Int((duration.truncatingRemainder(dividingBy: 1)) * 60)
        return "\(hours)h \(minutes)m"
    }
}

struct DetailRow: View {
    let icon: String
    let title: String
    let value: Any
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .frame(width: 24)
                .foregroundColor(.accentColor)
            
            Text(title)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text("\(value)")
        }
        .padding()
        .background(Color(.systemBackground))
    }
}

struct ImageFullScreenView: View {
    let image: UIImage
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
} 
 