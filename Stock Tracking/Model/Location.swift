import CoreLocation

struct Location: Equatable, Hashable {
    let latitude: Double
    let longitude: Double
}

extension Location {
    init(coordinate: CLLocationCoordinate2D) {
        self.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
}

extension CLLocationCoordinate2D {
    init(location: Location) {
        self.init(latitude: location.latitude, longitude: location.longitude)
    }
}
