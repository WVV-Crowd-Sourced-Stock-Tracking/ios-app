import MapKit

extension MKCoordinateRegion: Equatable {
    public static func == (lhs: MKCoordinateRegion, rhs: MKCoordinateRegion) -> Bool {
        return lhs.center == rhs.center
            && lhs.span == rhs.span
    }
}

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D,
                           rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude
            && lhs.longitude == rhs.longitude
    }
}

extension MKCoordinateSpan: Equatable {
    public static func == (lhs: MKCoordinateSpan,
                           rhs: MKCoordinateSpan) -> Bool {
        return lhs.latitudeDelta == rhs.latitudeDelta
            && lhs.longitudeDelta == rhs.longitudeDelta
    }
}

extension MKCoordinateSpan {
    var radius: CLLocationDegrees {
        return max(self.latitudeDelta, self.longitudeDelta) * 111 * 1000 // https://stackoverflow.com/a/5798913
    }
}

extension MKCoordinateRegion {
    func open(with name: String) {
        let placemark = MKPlacemark(coordinate: self.center, addressDictionary: nil)
        let item = MKMapItem(placemark: placemark)
        item.name = name
        item.openInMaps(launchOptions: nil)
    }
}
