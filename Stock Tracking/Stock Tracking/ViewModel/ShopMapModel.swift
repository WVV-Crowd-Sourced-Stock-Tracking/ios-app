import Combine
import SwiftUI
import CoreLocation
import MapKit

class ShopMapModel: ShopsModel {
    @Published var selectedShop: ShopModel?
    @Published var region: MKCoordinateRegion? {
        didSet {
            if self.shopsModel.coordinate != self.region?.center {
                self.shopsModel.coordinate = self.region?.center
            }
        }
    }
    
    @Published var shopsModel: ShopsModel = ShopsModel()
    
    override init(shops: [ShopModel] = []) {
        super.init(shops: shops)
    }
    
    override func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        super.locationManager(manager, didUpdateLocations: locations)
        guard let location = locations.last else {
            return
        }
        
        self.region = MKCoordinateRegion(center: location.coordinate,
                                             latitudinalMeters: 1000,
                                             longitudinalMeters: 1000)
    }
}
