import CoreLocation

struct Location: Equatable, Hashable {
    let latitude: Double
       let longitude: Double
}

extension CLLocationCoordinate2D {
    init(location: Location) {
        self.init(latitude: location.latitude, longitude: location.longitude)
    }
}
