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
		self.sendNotification()
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
	
	func sendNotification() {
		let notificationContent = UNMutableNotificationContent()
		notificationContent.title = name
		notificationContent.body = "Test body"
		notificationContent.badge = NSNumber(value: 3)

		let center = CLLocationCoordinate2D.init(location: location)
		let region = CLCircularRegion(center: center, radius: 2000.0, identifier: name)
		region.notifyOnEntry = true
		region.notifyOnExit = false
		let trigger = UNLocationNotificationTrigger(region: region, repeats: false)
		
		let request = UNNotificationRequest(identifier: "testNotification",
											content: notificationContent,
											trigger: trigger)
		
		NotificationCenter.add(request) { (error) in
			if let error = error {
				print("Notification Error: ", error)
			}
		}
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

