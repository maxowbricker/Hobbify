import SwiftUI

struct HobbySelector: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Hobby.name, ascending: true)],
        animation: .default)
    private var hobbies: FetchedResults<Hobby>
    
    @ObservedObject private var hobbyState = HobbyState.shared
    @State private var isShowingHobbyPicker = false
    @State private var isShowingNewHobby = false
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: {
                isShowingHobbyPicker.toggle()
            }) {
                HStack {
                    if let hobby = hobbyState.selectedHobby {
                        HStack(spacing: 8) {
                            Image(systemName: hobby.icon ?? "star.fill")
                                .font(.title3)
                                .foregroundColor(hobby.color.flatMap { Color($0) } ?? .blue)
                            Text(hobby.name ?? "")
                                .font(.title3)
                                .bold()
                        }
                    } else {
                        Text("Select a Hobby")
                            .font(.title3)
                            .bold()
                    }
                    Spacer()
                    Image(systemName: "chevron.down")
                        .font(.title3)
                        .rotationEffect(.degrees(isShowingHobbyPicker ? 180 : 0))
                }
                .padding(.horizontal)
                .padding(.vertical, 12)
                .background(Color(.systemBackground))
            }
            
            if isShowingHobbyPicker {
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(hobbies) { hobby in
                            Button(action: {
                                hobbyState.selectedHobby = hobby
                                isShowingHobbyPicker = false
                            }) {
                                HStack {
                                    Image(systemName: hobby.icon ?? "star.fill")
                                        .font(.title3)
                                        .foregroundColor(hobby.color.flatMap { Color($0) } ?? .blue)
                                    Text(hobby.name ?? "")
                                        .foregroundColor(.primary)
                                    Spacer()
                                    if hobby == hobbyState.selectedHobby {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.blue)
                                    }
                                }
                                .padding()
                                .background(Color(.systemBackground))
                            }
                        }
                        
                        Button(action: {
                            isShowingNewHobby = true
                            isShowingHobbyPicker = false
                        }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("Add New Hobby")
                            }
                            .padding()
                            .foregroundColor(.blue)
                        }
                    }
                }
                .frame(maxHeight: 300)
                .background(Color(.systemBackground))
                .shadow(radius: 2)
            }
        }
        .background(Color(.systemBackground))
        .shadow(radius: 2)
        .sheet(isPresented: $isShowingNewHobby) {
            NewHobbyView()
        }
    }
}

#Preview {
    HobbySelector()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
} 