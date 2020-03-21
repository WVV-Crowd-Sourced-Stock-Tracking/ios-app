//
//  ShopDetailView.swift
//  Stock Tracking
//
//  Created by Leo Mehlig on 21.03.20.
//  Copyright © 2020 wIrvsvirus. All rights reserved.
//

import SwiftUI
import MapKit

class DetailModel: ObservableObject, LandmarkConvertible {
    var title: String {
        self.name
    }
    
    let location: Location
    
    let color: UIColor = .full
    
    @Published var id: String
    
    @Published var name: String
    @Published var distance: Double
    @Published var address: String
    @Published var isOpen: Bool?
    @Published var region: MKCoordinateRegion?
    @Published var products: [ProductModel]
    
    @Published var isClose: Bool
    
    
    var distanceString: String {
        ShopModel.distanceFormatter.string(from: Measurement(value: self.distance, unit: UnitLength.meters))
    }
    
    init(shop: Shop) {
        self.id = shop.id
        self.name = shop.name
        self.distance = shop.distance
        self.address = shop.vicinity
        self.isOpen = shop.openNow
        self.location = Location(latitude: shop.latitude, longitude: shop.longitude)
        self.region = MKCoordinateRegion(center: .init(location: self.location), latitudinalMeters: 1000, longitudinalMeters: 1000)
        self.products = [ShopModel].preview.first!.products
        self.isClose = shop.distance <= 100
    }
}
struct ShopDetailView: View {
    
    @ObservedObject
    var model: DetailModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(spacing: 0) {
                    HStack {
                        Text(self.model.address + " • " + self.model.distanceString)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Image(systemName: "map.fill")
                            .font(.headline)
                            .foregroundColor(.blue)
                    }
                    .padding()
                    self.map
                }
                .background(Color.white)
                .cornerRadius(10)
                .padding()
                
                VStack(spacing: 12) {
                    HStack {
                        Text("Products")
                            .font(.system(size: 21, weight: .bold, design: .default))
                        Spacer()
                        Text("Availability")
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .padding(.trailing)
                    }
                    .padding(.horizontal)

                    VStack {
                        ForEach(self.model.products) { product in
                            VStack(spacing: 0) {
                                HStack(spacing: 12) {
                                    AvailabilityView(availability: product.availability)
                                        .frame(height: 16)
                                    Text(product.name)
                                        .font(.headline)
                                    Spacer()
                                    Text(product.availability.text)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                        .padding(.trailing)
                                    
                                }
                                .padding()
                                if self.model.products.last !== product {
                                    Divider()
                                }
                            }
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.horizontal)

                    Button(action: { }) {
                        Text("Enter Stock")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    
                }
                
            }
            .navigationBarTitle(self.model.name)
            .onAppear {
                UIScrollView.appearance().backgroundColor = UIColor.systemGroupedBackground
            }
        }
    }
    
    
    var map: some View {
        ZStack {
            MapView(Binding(get: { [self.model] }, set: { _ in }),
                    selected: .constant(nil),
                    region: self.$model.region) { _ in
                        EmptyView()
            }
            .allowsHitTesting(false)
            Color.white.opacity(0.0001)
        }
        .frame(height: 150)
    }
}

struct ShopDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ShopDetailView(model: DetailModel(shop: [ShopModel].preview.first!.shop))
        }
    }
}
