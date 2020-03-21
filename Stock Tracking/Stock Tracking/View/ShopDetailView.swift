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
    
    @State var isEditing: Bool = true
    
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
                    HStack(spacing: 12) {
                        Text("Products")
                            .font(.system(size: 21, weight: .bold, design: .default))
                        Spacer()
                        Text("Availability")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                    .padding(.trailing)
                    
                    VStack {
                        ForEach(self.model.products) { product in
                            VStack(spacing: 0) {
                                HStack(spacing: 12) {
                                    Text(product.emoji)
                                        .font(.headline)
                                    Text(product.name)
                                        .font(.headline)
                                    Spacer()
                                    if !self.isEditing {
                                        Text(product.availability.text)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                            .transition(.opacity)
                                    }
                                    if self.isEditing {
                                        HStack {
                                            AvailabilityButton(product: product, availability: .empty)
                                            AvailabilityButton(product: product, availability: .mid)
                                            AvailabilityButton(product: product, availability: .full)
                                        }
                                        .frame(width: 140, height: 20)
                                        
                                    }
                                    if !self.isEditing {
                                        AvailabilityView(availability: product.availability)
                                            .frame(height: 20)
                                    }
                                    
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
                    
                    Button(action: {
                        self.isEditing.toggle()
                    }) {
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
            .onAppear {
                UIScrollView.appearance().backgroundColor = UIColor.systemGroupedBackground
            }
        }
        .navigationBarTitle(self.model.name)
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

struct AvailabilityButton: View {
    @ObservedObject
    var product: ProductModel
    
    let availability: Availability
    
    var body: some View {
        Button(action: {
            self.product.selectedAvailability = self.availability
        }) {
            Circle()
                .stroke(self.availability.color, lineWidth: 2)
                .modifier(GlowModifier())
                .overlay(
                    Circle()
                        .fill(self.availability.color)
                        .modifier(GlowModifier())
                        .padding(3)
                        .opacity(product.selectedAvailability == self.availability ? 1 : 0)
                    
            )
        }
    }
}

struct ShopDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ShopDetailView(model: DetailModel(shop: [ShopModel].preview.first!.shop))
        }
    }
}
