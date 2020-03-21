import Combine
import SwiftUI
import CoreLocation
import MapKit

class ShopsModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var shops: [ShopModel] = []

    @Published var region: MKCoordinateRegion? {
        didSet {
            if let region = self.region {
                self.cellRegion = MKCoordinateRegion(center: region.center,
                                                     latitudinalMeters: 1000,
                                                     longitudinalMeters: 1000)
            }
        }
    }
    
    @Published var cellRegion: MKCoordinateRegion?
    
    @Published var selectedShop: ShopModel?
    
    @Published var error: API.Error?
    
    private var locationManager = CLLocationManager()
    private var shopTask: AnyCancellable?
    
    init(shops: [ShopModel] = []) {
        super.init()
        self.shops = shops
        self.shopTask = $region
            .debounce(for: 1,
                      scheduler: RunLoop.main,
                      options: nil)
            .filterNil()
            .flatMap {
                API.fetchStores(at: Location(coordinate: $0.center), with: $0.span.radius)
                    .map { $0.map { ShopModel(shop: $0) } }
                    .receive(on: RunLoop.main)
                    .mapError(API.Error.from(error:))
                    .assignError(to: \ShopsModel.error, on: self, replaceWith: [])
                
        }
            
        .receive(on: RunLoop.main)
        .assignWeak(to: \ShopsModel.shops, on: self)
        
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
        
        self.region = MKCoordinateRegion(center: location.coordinate,
                                         latitudinalMeters: 1000,
                                         longitudinalMeters: 1000)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}
