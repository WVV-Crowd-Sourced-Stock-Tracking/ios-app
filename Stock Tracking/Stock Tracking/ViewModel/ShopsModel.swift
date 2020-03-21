import Combine
import SwiftUI
import CoreLocation

class ShopsModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var shops: [ShopModel] = []

    @Published var coordinate: CLLocationCoordinate2D? {
        didSet {
            self.shopTask?.cancel()
            if let coordinate = coordinate {
                self.shopTask = API.fetchStores(at: Location(coordinate: coordinate))
                    .assertNoFailure()
                    .map { $0.map { ShopModel(shop: $0) } }
                    .receive(on: RunLoop.main)
                    .assign(to: \ShopMapModel.shops, on: self)
            }
        }
    }
    
    private var locationManager = CLLocationManager()
    private var shopTask: AnyCancellable?
    
    init(shops: [ShopModel] = []) {
        self.shops = shops
    }

    func fetchLocation() {
        guard CLLocationManager.locationServicesEnabled() else {
            print("Location Servics not enabled!!1")
            return
        }
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        
        self.locationManager.stopUpdatingLocation()
        
        self.coordinate = location.coordinate
    }
    
}
