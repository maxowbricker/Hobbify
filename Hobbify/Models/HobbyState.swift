import SwiftUI

class HobbyState: ObservableObject {
    @Published var selectedHobby: Hobby?
    
    static let shared = HobbyState()
    
    private init() {}
} 