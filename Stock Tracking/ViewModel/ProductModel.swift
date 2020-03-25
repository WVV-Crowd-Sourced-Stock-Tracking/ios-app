import SwiftUI

class ProductModel: ObservableObject, Identifiable {
    let id: Int
    @Published var name: String
    @Published var emoji: String
    @Published var quantity: Int
    @Published var availability: Availability
    @Published var selectedAvailability: Availability?
    
    let product: Product
    
    init(id: Int = 0, name: String, emoji: String, availability: Availability) {
        self.id = id
        self.name = name
        self.emoji = emoji
        self.availability = availability
        self.quantity = availability.quantity
        self.product = Product(id: id, name: name, availability: availability.quantity)
    }
    
    init(product: Product) {
        self.id = product.id
        self.name = product.name
        self.quantity = product.availability
        self.availability = .from(quantity: Int(product.availability))
        self.product = product
        self.emoji = ""
    }
    
}


extension Array where Element == ProductModel {
    static func models(from products: [Product], with models: [ProductModel] = .sorted) -> [ProductModel] {
        for model in models {
            if let product = products.first(where: { $0.id == model.id }) {
                model.quantity = product.availability
                model.availability = .from(quantity: product.availability)
            }
        }
        return models
    }
    
    static func shopScore(for products: [Product]) -> Double {
        let filtered = [ProductModel].models(from: products, with: .filterd)
            .filter { $0.availability != .unknown }
            .map { $0.product.availability }
        if filtered.isEmpty {
            return -1
        } else {
            let value = Double(filtered.reduce(0, +)) / Double(filtered.count)
            return Swift.min(100, Swift.max(0, value))
        }
    }
    
    static var filterd: [ProductModel] {
        let filtered = [ProductModel].all
            .map { FilterProduct(product: $0) }
            .filter { $0.isSelected }
            .map { $0.product }
        if filtered.isEmpty {
            return .all
        } else {
            return filtered
        }
    }
    
    static var sorted: [ProductModel] {
        [ProductModel].all
            .map { FilterProduct(product: $0) }
            .sorted { !$0.isSelected || $0.isSelected == $1.isSelected }
            .reversed()
            .map { $0.product }
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
