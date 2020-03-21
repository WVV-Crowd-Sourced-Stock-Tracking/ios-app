import SwiftUI

class ProductModel: ObservableObject, Identifiable {
    @Published var id: UUID = .init()
    @Published var name: String
    @Published var emoji: String
    @Published var availability: Availability
    @Published var selectedAvailability: Availability?
    
    init(name: String, emoji: String, availability: Availability) {
        self.name = name
        self.emoji = emoji
        self.availability = availability
    }
}
