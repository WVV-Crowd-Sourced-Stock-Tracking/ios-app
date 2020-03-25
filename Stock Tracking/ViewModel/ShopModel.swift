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
         products: [ProductModel])  {
        self.id = id.description
        self.products = products
        self.location = location
        self.shopAvailability = shopAvailability
        self.isClose = isClose
        self.distance = distance
        self.address = address
        self.isOpen = isOpen
        self.name = name
        self.shop = Shop(id: id, name: name, lat: location.latitude.description, lng: location.longitude.description, street: address, distance: distance.description, open: isOpen, products: products.map { $0.product })
    }
    
    init(shop: Shop) {
        self.id = shop.id.description
        self.products = .models(from: shop.products)
        self.location = Location(latitude: Double(shop.lat)!, longitude: Double(shop.lng)!)
        self.shopAvailability = [ProductModel].shopScore(for: shop.products)
        self.isClose =  Double(shop.distance)! <= 100
        self.distance = round(Double(shop.distance)!)
        self.address = shop.street
        self.isOpen = shop.open
        self.name = shop.name
        self.shop = shop
    }
    
    var color: UIColor { Availability.from(quantity: Int(self.shopAvailability)).uiColor }
	
	// Notification
	let NotificationCenter = UNUserNotificationCenter.current()
	let NotificationContent = UNMutableNotificationContent()
	
	func registerGeofence() {
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = self.name
        content.body = "Run! This zone is dangerous! :o"
        content.categoryIdentifier = "alarm"
        
        let centerLoc = CLLocationCoordinate2D.init(location: location)
        let region = CLCircularRegion(center: centerLoc, radius: 50.0, identifier: self.id)
        region.notifyOnEntry = true
        region.notifyOnExit = true

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
                        ProductModel(name: "Milch", emoji: "🥛", availability: .full),
                        ProductModel(name: "Bread", emoji: "🍞", availability: .unknown),
                        ProductModel(name: "Toilet Paper", emoji: "🧻", availability: .empty),
            ]),
            ShopModel(name: "Lidl",
                      location: Location(latitude: 52.481998, longitude: 13.432388),
                      address: "Herrfurtplatz 12, Berlin",
                      distance: 500,
                      shopAvailability: 22,
                      products: [
                        ProductModel(name: "Milch", emoji: "🥛", availability: .empty),
                        ProductModel(name: "Bread", emoji: "🍞", availability: .empty),
                        ProductModel(name: "Toilet Paper", emoji: "🧻", availability: .empty),
            ]),
            ShopModel(name: "Aldi",
                      location: Location(latitude: 52.480135, longitude: 13.436681),
                      address: "Herrfurtplatz 12, Berlin",
                      distance: 500,
                      shopAvailability: 88,
                      products: [
                        ProductModel(name: "Milch", emoji: "🥛", availability: .full),
                        ProductModel(name: "Bread", emoji: "🍞", availability: .mid),
                        ProductModel(name: "Toilet Paper", emoji: "🧻", availability: .full),
            ]),
        ]
    }
}

