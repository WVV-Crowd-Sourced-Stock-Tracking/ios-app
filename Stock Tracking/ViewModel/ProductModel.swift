import SwiftUI

let formatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
}()

class ProductModel: ObservableObject, Identifiable {
    let id: Int
    
    @Published var name: String
    @Published var emoji: String
    @Published var quantity: Int?
    @Published var availability: Availability
    @Published var selectedAvailability: Availability?
    
    var wasSent: Bool = false
    
    let product: Product
    let key: String
    
    init(id: Int = 0, name: String, emoji: String, availability: Availability) {
        self.id = id
        self.name = name
        self.emoji = emoji
        self.availability = availability
        self.quantity = availability.quantity
        self.product = Product(productId: id, productName: name, availability: availability.quantity, emoji: emoji)
        self.key = ""
    }
    

    init(product: Product, shopId: Int) {
        self.id = product.productId
        self.name = product.productName
        self.quantity = product.availability
        self.availability = .from(quantity: product.availability)
        self.product = product
        self.emoji = product.emoji
        self.key = "product_\(shopId)_\(product.productId)_\(formatter.string(from: Date()))"
        if let selected = UserDefaults.standard.object(forKey: self.key) as? Int {
            self.selectedAvailability = .from(quantity: selected)
            self.availability = .from(quantity: selected)
            self.wasSent = true
        }
    }
    
    func saveSelected() {
        guard let selected = self.selectedAvailability?.quantity else {
            return
        }
        self.availability = .from(quantity: selected)
        UserDefaults.standard.set(selected, forKey: self.key)
        self.wasSent = true
    }
    
}


extension Array where Element == ProductModel {
    static func models(from products: [Product], with models: [ProductModel]) -> [ProductModel] {
        for model in models {
            if let product = products.first(where: { $0.productId == model.id }) {
                model.quantity = product.availability
                model.availability = .from(quantity: product.availability)
            }
        }
        return models
    }
    
    static func shopScore(for products: [Product], with all: [ProductModel]) -> Double {
        let filtered = [ProductModel].models(from: products, with: .filterd(with: all))
            .compactMap { $0.quantity }
        if filtered.isEmpty {
            return -1
        } else {
            let value = Double(filtered.reduce(0, +)) / Double(filtered.count)
            return Swift.min(100, Swift.max(0, value))
        }
    }
    
    static func filterd(with all: [ProductModel]) -> [ProductModel] {
        let filtered = all
            .map { FilterProduct(product: $0) }
            .filter { $0.isSelected }
            .map { $0.product }
        if filtered.isEmpty {
            return all
        } else {
            return filtered
        }
    }
    
    static func sorted(with all: [ProductModel]) -> [ProductModel] {
            return all
            .map { FilterProduct(product: $0) }
            .sorted { !$0.isSelected || $0.isSelected == $1.isSelected }
            .reversed()
            .map { $0.product }
    }
    
    static var preview: [ProductModel] {
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
