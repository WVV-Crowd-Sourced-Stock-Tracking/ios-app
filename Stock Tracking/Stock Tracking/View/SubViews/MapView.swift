//
//  MapView.swift
//  MapViewApp
//
//  Created by Thomas Sivilay on 28/7/19.
//  Copyright © 2019 Thomas Sivilay. All rights reserved.
//

import SwiftUI
import MapKit

final class LandmarkAnnotation: NSObject, MKAnnotation {
    let id: String
    let title: String?
    let subtitle: String? = "Closing 19:00"
    let coordinate: CLLocationCoordinate2D
    let color: UIColor

    init(landmark: LandmarkConvertible) {
        self.id = landmark.id
        self.title = landmark.title
        self.coordinate = CLLocationCoordinate2D(location: landmark.location)
        self.color = landmark.color
    }
}

protocol LandmarkConvertible {
    var id: String { get }
    var title: String { get }
    var location: Location { get }
    var color: UIColor { get }
}

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
        return max(self.latitudeDelta, self.longitudeDelta)
    }
}

struct MapView<Landmark: LandmarkConvertible, Content: View>: UIViewRepresentable {
    @Binding var landmarks: [Landmark]
    @Binding var selectedLandmark: Landmark?
    @Binding var region: MKCoordinateRegion?
    var content: (Landmark) -> Content
    
    init(_ landmarks: Binding<[Landmark]>, selected: Binding<Landmark?>, region: Binding<MKCoordinateRegion?>, content: @escaping (Landmark) -> Content) {
        self._landmarks = landmarks
        self._selectedLandmark = selected
        self._region = region
        self.content = content
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let map = MKMapView()
        map.delegate = context.coordinator
        map.showsUserLocation = true
        return map
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        updateAnnotations(from: uiView)
        updateRegion(from: uiView)
    }
    
    private func updateRegion(from mapView: MKMapView) {
        if let region = self.region, region != mapView.region {
            mapView.setRegion(region, animated: true)
        }
    }
    
    private func updateAnnotations(from mapView: MKMapView) {
        let ids = Set(mapView.annotations.compactMap { ($0 as? LandmarkAnnotation)?.id })
        if ids != Set(landmarks.map { $0.id }) {
            mapView.removeAnnotations(mapView.annotations)
            let newAnnotations = landmarks.map { LandmarkAnnotation(landmark: $0) }
            mapView.addAnnotations(newAnnotations)
        }
        if (mapView.selectedAnnotations.first as? LandmarkAnnotation)?.id != selectedLandmark?.id,
            let selected = mapView.annotations.first(where: { ($0 as? LandmarkAnnotation)?.id == selectedLandmark?.id })
        {
            mapView.selectAnnotation(selected, animated: true)
        }
    }
    
    func makeCoordinator() -> MapCoordinator {
        MapCoordinator(self)
    }
    
    final class MapCoordinator: NSObject, MKMapViewDelegate {
        var control: MapView

        init(_ control: MapView) {
            self.control = control
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            self.control.region = mapView.region
        }
        
        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            if let annotation = view.annotation as? LandmarkAnnotation {
                self.control.selectedLandmark = self.control.landmarks.first(where: { $0.id == annotation.id })
            }
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard let annotation = annotation as? LandmarkAnnotation,
                let landmark = self.control.landmarks.first(where: { $0.id == annotation.id }) else { return nil }
            let identifier = "landmark.annotation"
            let annotationView = (mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView)
                ?? MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView.canShowCallout = true
            annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView.glyphImage = UIImage(systemName: "cart.fill")
            annotationView.annotation = annotation
            annotationView.markerTintColor = annotation.color
            annotationView.displayPriority = .required
            annotationView.detailCalloutAccessoryView = {
                let view = UIHostingController(rootView: self.control.content(landmark)).view
                view?.backgroundColor = .clear
                return view
            }()
            return annotationView
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(.constant([ShopModel].preview),
                selected: .constant(nil),
                region: .constant(nil)) { shop in
                    HStack(spacing: 12) {
                        ForEach(shop.products.prefix(5)) { product in
                            HStack(spacing: 6) {
                                AvailabilityView(availability: product.availability)
                                    .frame(height: 16)
                                Text(product.emoji)
                                    .font(.footnote)
                            }
                        }
                        Spacer()
                    }
                    .padding(.vertical, 4)
        }
    }
}
