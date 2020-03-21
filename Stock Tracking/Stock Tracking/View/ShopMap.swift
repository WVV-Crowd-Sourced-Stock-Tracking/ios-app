//
//  ShopMap.swift
//  Stock Tracking
//
//  Created by Leo Mehlig on 21.03.20.
//  Copyright © 2020 wIrvsvirus. All rights reserved.
//

import SwiftUI
import CoreLocation
import MapKit

struct ShopMap: View {
    @ObservedObject
    var model: ShopMapModel
    
    var body: some View {
        MapView(self.model.shops,
                selected: self.$model.selectedShop,
                region: self.$model.region) { shop in
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
        .onAppear {
            self.model.zoomToLocation()
        }
    }
}

class ShopMapModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var shops: [ShopModel]
    @Published var selectedShop: ShopModel?
    @Published var region: MKCoordinateRegion?
    private let locationManager = CLLocationManager()
    
    init(shops: [ShopModel], selectedShop: ShopModel? = nil) {
        self.shops = shops
        self.selectedShop = selectedShop
    }
    
    func zoomToLocation() {
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
}

struct ShopMap_Previews: PreviewProvider {
    static var previews: some View {
        ShopMap(model: ShopMapModel(shops: .preview))
    }
}
