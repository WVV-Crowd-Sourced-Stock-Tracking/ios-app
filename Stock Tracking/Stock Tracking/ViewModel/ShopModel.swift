import SwiftUI

class ShopModel: ObservableObject, Identifiable, LandmarkConvertible {
    
    @Published var id: String = UUID().uuidString
    @Published var name: String
    @Published var products: [ProductModel]
    @Published var isClose: Bool
    @Published var location: Location
    @Published var shopAvailability: Availability
    
    init(name: String,
         isClose: Bool = false,
         location: Location,
         shopAvailability: Availability,
         products: [ProductModel])  {
        self.name = name
        self.products = products
        self.location = location
        self.shopAvailability = shopAvailability
        self.isClose = isClose
    }
    
    var color: UIColor { self.shopAvailability.uiColor }
}

extension Array where Element == ShopModel {
    static var preview: [ShopModel] {
        return [
            ShopModel(name: "Rewe",
                      isClose: true,
                      location: Location(latitude: 52.478419, longitude: 13.429619),
                      shopAvailability: .middle,
                      products: [
                        ProductModel(name: "Milch", emoji: "🥛", availability: .full),
                        ProductModel(name: "Bread", emoji: "🍞", availability: .unknown),
                        ProductModel(name: "Toilet Paper", emoji: "🧻", availability: .empty),
            ]),
            ShopModel(name: "Lidl",
                      location: Location(latitude: 52.481998, longitude: 13.432388),
                      shopAvailability: .empty,
                      products: [
                        ProductModel(name: "Milch", emoji: "🥛", availability: .empty),
                        ProductModel(name: "Bread", emoji: "🍞", availability: .empty),
                        ProductModel(name: "Toilet Paper", emoji: "🧻", availability: .empty),
            ]),
            ShopModel(name: "Aldi",
                      location: Location(latitude: 52.480135, longitude: 13.436681),
                      shopAvailability: .full,
                      products: [
                        ProductModel(name: "Milch", emoji: "🥛", availability: .full),
                        ProductModel(name: "Bread", emoji: "🍞", availability: .middle),
                        ProductModel(name: "Toilet Paper", emoji: "🧻", availability: .full),
            ]),
        ]
    }
}

