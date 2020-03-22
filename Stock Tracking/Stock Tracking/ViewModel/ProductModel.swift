import SwiftUI

class ProductModel: ObservableObject, Identifiable {
    let id: Int
    @Published var name: String
    @Published var emoji: String
    @Published var availability: Availability
    @Published var selectedAvailability: Availability?
    
    let product: Product
    
    init(id: Int = 0, name: String, emoji: String, availability: Availability) {
        self.id = id
        self.name = name
        self.emoji = emoji
        self.availability = availability
        self.product = Product(id: id, name: name, availability: availability.quantity)
    }
    
    init(product: Product) {
        self.id = product.id
        self.name = product.name
        self.availability = .from(quantity: Int(product.availability))
        self.product = product
        self.emoji = "🧻"
    }
    
}


extension Array where Element == ProductModel {
    static func models(from products: [Product]) -> [ProductModel] {
        let models = [ProductModel].all
        for model in models {
            if let product = products.first(where: { $0.id == model.id }) {
                model.availability = .from(quantity: product.availability)
            }
        }
        return models
    }
    
    static var all: [ProductModel] {
        [
            ProductModel(id: 47, name: "Klopapier", emoji: "🧻", availability: .unknown),
            ProductModel(id: 49, name: "Seife", emoji: "🧼", availability: .unknown),
            ProductModel(id: 48, name: "Desinfektionsm.", emoji: "🦠", availability: .unknown),
            ProductModel(id: 162, name: "Nudeln", emoji: "🍝", availability: .unknown),
            ProductModel(id: 53, name: "Mehl", emoji: "🌾", availability: .unknown),
            ProductModel(id: 201, name: "Reis", emoji: "🍚", availability: .unknown),
            ProductModel(id: 96, name: "Fleisch", emoji: "🥩", availability: .unknown),
            ProductModel(id: 26, name: "Fish", emoji: "🐟", availability: .unknown),
            ProductModel(id: 267, name: "Tofu", emoji: "🌱", availability: .unknown),
            ProductModel(id: 290, name: "Gemüse", emoji: "🍅", availability: .unknown),
            ProductModel(id: 314, name: "Obst", emoji: "🍎", availability: .unknown),
            ProductModel(id: 111, name: "Eier", emoji: "🥚", availability: .unknown),
            ProductModel(id: 1, name: "Milch", emoji: "🥛", availability: .unknown),
            ProductModel(id: 127, name: "Nüsse", emoji: "🥜", availability: .unknown),
            ProductModel(id: 144, name: "Kartoffeln", emoji: "🥔", availability: .unknown),
            ProductModel(id: 32, name: "Brot", emoji: "🍞", availability: .unknown),
            ProductModel(id: 181, name: "Müsli", emoji: "🥣", availability: .unknown),
            ProductModel(id: 55, name: "Öl", emoji: "🛢️", availability: .unknown),
            ProductModel(id: 13, name: "Wasser", emoji: "💧", availability: .unknown),
            ProductModel(id: 54, name: "Zucker", emoji: "🍬", availability: .unknown),
            ProductModel(id: 50, name: "Waschmittel", emoji: "🧺", availability: .unknown),
            ProductModel(id: 51, name: "Müllbeutel", emoji: "🗑️", availability: .unknown),
            ProductModel(id: 52, name: "Handschuhe", emoji: "🧤", availability: .unknown),
        ]
    }
}
