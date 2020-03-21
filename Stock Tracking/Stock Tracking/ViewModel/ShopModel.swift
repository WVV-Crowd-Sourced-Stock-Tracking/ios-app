import SwiftUI
import Foundation
import MapKit

class ShopModel: ObservableObject, Identifiable, LandmarkConvertible {
    static let distanceFormatter: MeasurementFormatter = {
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .medium
        formatter.unitOptions = .naturalScale
        formatter.numberFormatter = NumberFormatter()
        formatter.numberFormatter.maximumFractionDigits = 1
        return formatter
    }()
    
    
    @Published var products: [ProductModel]
    @Published var isClose: Bool
    @Published var location: Location
    @Published var shopAvailability: Availability
    @Published var name: String
    @Published var distance: Double
    @Published var address: String
    @Published var isOpen: Bool?
        
    let id: String
    
    var title: String { self.name }

    let shop: Shop
    
    var distanceString: String {
        ShopModel.distanceFormatter.string(from: Measurement(value: self.distance, unit: UnitLength.meters))
    }
    
    init(id: String = "",
         name: String,
         isClose: Bool = false,
         location: Location,
         address: String,
         distance: Double,
         isOpen: Bool? = nil,
         shopAvailability: Availability,
         products: [ProductModel])  {
        self.id = id
        self.products = products
        self.location = location
        self.shopAvailability = shopAvailability
        self.isClose = isClose
        self.distance = distance
        self.address = address
        self.isOpen = isOpen
        self.name = name
        self.shop = Shop(id: id, name: name, latitude: location.latitude, longitude: location.longitude, vicinity: address, distance: distance, openNow: isOpen)
    }
    
    convenience init(shop: Shop) {
        self.init(
            id: shop.id,
            name: shop.name,
            isClose: shop.distance <= 100,
            location: Location(latitude: shop.latitude, longitude: shop.longitude),
            address: shop.vicinity,
            distance: round(shop.distance),
            isOpen: shop.openNow,
            shopAvailability: .full,
            products: [])
    }
    
    var color: UIColor { self.shopAvailability.uiColor }
}

extension Array where Element == ShopModel {
    static var preview: [ShopModel] {
        return [
            ShopModel(name: "Rewe",
                      isClose: true,
                      location: Location(latitude: 52.478419, longitude: 13.429619),
                      address: "Herrfurtplatz 12, Berlin",
                      distance: 500,
                      shopAvailability: .mid,
                      products: [
                        ProductModel(name: "Milch", emoji: "🥛", availability: .full),
                        ProductModel(name: "Bread", emoji: "🍞", availability: .unknown),
                        ProductModel(name: "Toilet Paper", emoji: "🧻", availability: .empty),
            ]),
            ShopModel(name: "Lidl",
                      location: Location(latitude: 52.481998, longitude: 13.432388),
                      address: "Herrfurtplatz 12, Berlin",
                      distance: 500,
                      shopAvailability: .empty,
                      products: [
                        ProductModel(name: "Milch", emoji: "🥛", availability: .empty),
                        ProductModel(name: "Bread", emoji: "🍞", availability: .empty),
                        ProductModel(name: "Toilet Paper", emoji: "🧻", availability: .empty),
            ]),
            ShopModel(name: "Aldi",
                      location: Location(latitude: 52.480135, longitude: 13.436681),
                      address: "Herrfurtplatz 12, Berlin",
                      distance: 500,
                      shopAvailability: .full,
                      products: [
                        ProductModel(name: "Milch", emoji: "🥛", availability: .full),
                        ProductModel(name: "Bread", emoji: "🍞", availability: .mid),
                        ProductModel(name: "Toilet Paper", emoji: "🧻", availability: .full),
            ]),
        ]
    }
}

