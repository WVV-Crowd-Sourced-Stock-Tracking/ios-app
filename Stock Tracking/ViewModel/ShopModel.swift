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
    @Published var shopAvailability: Double
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
    
    init(id: Int = 0,
         name: String,
         isClose: Bool = false,
         location: Location,
         address: String,
         distance: Double,
         isOpen: Bool? = nil,
         shopAvailability: Double,
         products: [Product])  {
        self.id = id.description
        let productModel = products.map { ProductModel(product: $0) }
        self.products = productModel
        self.location = location
        self.shopAvailability = shopAvailability
        self.isClose = isClose
        self.distance = distance
        self.address = address
        self.isOpen = isOpen
        self.name = name
        self.shop = Shop(marketId: id, marketName: name, latitude: location.latitude.description, longitude: location.longitude.description, street: address, distance: distance.description, open: isOpen, products: products)
}

init(shop: Shop, allProducts: [Product]) {
        self.id = shop.marketId.description
        let productModels = allProducts.map { ProductModel(product: $0) }
        self.products = .models(from: shop.products, with: .sorted(with: productModels))
        self.location = Location(latitude: Double(shop.latitude)!, longitude: Double(shop.longitude)!)
        self.shopAvailability = [ProductModel].shopScore(for: shop.products, with: productModels)
        self.isClose =  Double(shop.distance)! <= 100
        self.distance = round(Double(shop.distance)!)
        self.address = shop.street
        self.isOpen = shop.open
        self.name = shop.marketName
        self.shop = shop
    }
    
    var color: UIColor { Availability.from(quantity: Int(self.shopAvailability)).uiColor }
	
	func registerGeofence() {
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        let format = NSLocalizedString("notification.title", comment: "")
        content.title = String(format: format, "\(self.name)")
        content.body = NSLocalizedString("notification.body", comment: "")
        
        let centerLoc = CLLocationCoordinate2D.init(location: location)
        let region = CLCircularRegion(center: centerLoc, radius: 50.0, identifier: self.id)
        region.notifyOnEntry = true
        region.notifyOnExit = false

		#if targetEnvironment(macCatalyst)
		#else
			let trigger = UNLocationNotificationTrigger(region: region, repeats: true)
			let request = UNNotificationRequest(identifier: self.id,
												content: content,
												trigger: trigger)
			center.add(request)
		#endif
    }
}

extension Array where Element == ShopModel {
    static var preview: [ShopModel] {
        return [
            ShopModel(name: "Rewe",
                      isClose: true,
                      location: Location(latitude: 52.478419, longitude: 13.429619),
                      address: "Herrfurtplatz 12, Berlin",
                      distance: 500,
                      shopAvailability: 55,
                      products: [
                        ProductModel(name: "Milch", emoji: "🥛", availability: .full).product,
                        ProductModel(name: "Bread", emoji: "🍞", availability: .unknown).product,
                        ProductModel(name: "Toilet Paper", emoji: "🧻", availability: .empty).product,
            ]),
            ShopModel(name: "Lidl",
                      location: Location(latitude: 52.481998, longitude: 13.432388),
                      address: "Herrfurtplatz 12, Berlin",
                      distance: 500,
                      shopAvailability: 22,
                      products: [
                        ProductModel(name: "Milch", emoji: "🥛", availability: .empty).product,
                        ProductModel(name: "Bread", emoji: "🍞", availability: .empty).product,
                        ProductModel(name: "Toilet Paper", emoji: "🧻", availability: .empty).product,
            ]),
            ShopModel(name: "Aldi",
                      location: Location(latitude: 52.480135, longitude: 13.436681),
                      address: "Herrfurtplatz 12, Berlin",
                      distance: 500,
                      shopAvailability: 88,
                      products: [
                        ProductModel(name: "Milch", emoji: "🥛", availability: .full).product,
                        ProductModel(name: "Bread", emoji: "🍞", availability: .mid).product,
                        ProductModel(name: "Toilet Paper", emoji: "🧻", availability: .full).product,
            ]),
        ]
    }
}

