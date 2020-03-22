//
//  ShopDetailView.swift
//  Stock Tracking
//
//  Created by Leo Mehlig on 21.03.20.
//  Copyright © 2020 wIrvsvirus. All rights reserved.
//

import SwiftUI
import MapKit
import Combine
import SwiftUIX

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
    
    @Published var isLoading: Bool = false
    
    @Published var error: API.Error?
    
    let shop: Shop
    
    private var updateTask: AnyCancellable?
    
    var distanceString: String {
        ShopModel.distanceFormatter.string(from: Measurement(value: self.distance, unit: UnitLength.meters))
    }
    
    init(shop: Shop) {
        self.shop = shop
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
    
    func sendUpdate() {
        self.updateTask?.cancel()

        self.isLoading = true
        self.updateTask = API.sendUpdate(for: self.products, in: self.shop)
            .map { _ in false }
            .mapError { API.Error.from(error: $0) }
            .receive(on: RunLoop.main)
            .assignError(to: \DetailModel.error, on: self, replaceWith: false)
            .assignWeak(to: \DetailModel.isLoading, on: self)
    }
}
struct ShopDetailView: View {
    
    @ObservedObject
    var model: DetailModel
    
    @State var isEditing: Bool = false
    
    var body: some View {
        VStack {
            GeometryReader { proxy in
                ScrollView {
                    self.content
                        .frame(minHeight: proxy.size.height)
                        .padding(.bottom, 40)
                }
                .onAppear {
                    UIScrollView.appearance().backgroundColor = UIColor.systemGroupedBackground
                }
                .padding(.bottom, -40)
            }
            Button(action: {
                if self.isEditing {
                    self.model.sendUpdate()
                }
                withAnimation {
                    self.isEditing.toggle()
                }
            }) {
                HStack {
                    if !self.model.isLoading {
                        Image(systemName: self.isEditing ? "icloud.and.arrow.up.fill" : "tray.full.fill")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    
                    if self.model.isLoading {
                        ActivityIndicator()
                            .animated(self.model.isLoading)
                            .tintColor(.white)
                    }

                    Text(self.buttonTitle)
                        .font(.headline)
                        .foregroundColor(.white)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.accent)
                .cornerRadius(10)
                .disabled(self.model.isLoading)
                .animation(nil)
            }
            .padding(.horizontal)
            .padding()
            .padding(.top, 10)
            .background(
                VStack(spacing: 0) {
                    LinearGradient(gradient: Gradient(colors: [Color.grouped.opacity(0), .grouped]),
                                   startPoint: .top,
                                   endPoint: .bottom)
                        .frame(height: 20)
                    Color.grouped
                }
            )
        }
        .alert(item: self.$model.error) { error in
            Alert(title: Text("Something went wrong..."),
                  message: Text(error.localizedDescription),
                  dismissButton: .cancel())
        }
        .navigationBarTitle(self.model.name)
    }
    
    var buttonTitle: String {
        if self.model.isLoading {
            return "Sending Update..."
        } else if self.isEditing {
            return "Send Update"
        } else {
            return "Update Stock"
        }
    }
    
    var content: some View {
        VStack(spacing: 20) {
            Button(action: {
                self.model.region?.open(with: self.model.name)
            }) {
                VStack(spacing: 0) {
                    HStack {
                        Text(self.model.address + " • " + self.model.distanceString)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Image(systemName: "map.fill")
                            .font(.headline)
                            .foregroundColor(.accent)
                    }
                    .padding()
                    self.map
                }
            }
            .background(Color.white)
            .cornerRadius(10)
            .padding()
            
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    Text("Products")
                        .font(.system(size: 21, weight: .bold, design: .default))
                    Spacer()
                    if self.isEditing {
                        HStack(spacing: 6) {
                            AvailabilityLegend(availability: .empty)
                            AvailabilityLegend(availability: .mid)
                            AvailabilityLegend(availability: .full)
                        }
                        .frame(width: 180)
                    }
                    if !self.isEditing {
                        Text("Availability")
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                }
                .frame(height: 28)
                .padding(.horizontal)
                .padding(.trailing)
                
                VStack {
                    ForEach(self.model.products) { product in
                        VStack(spacing: 0) {
                            HStack(spacing: 12) {
                                if !self.isEditing {
                                    Text(product.emoji)
                                        .font(.headline)
                                }
                                Text(product.name)
                                    .font(.headline)
                                Spacer()
                                if !self.isEditing {
                                    Text(product.availability.text)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                        .transition(.opacity)
                                    AvailabilityView(availability: product.availability)
                                        .frame(height: 20)
                                }
                                if self.isEditing {
                                    HStack(spacing: 4) {
                                        AvailabilityButton(product: product, availability: .empty)
                                        AvailabilityButton(product: product, availability: .mid)
                                        AvailabilityButton(product: product, availability: .full)
                                    }
                                    .frame(width: 180)
                                    
                                }
                                
                            }
                            .frame(height: 36)
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

struct AvailabilityButton: View {
    @ObservedObject
    var product: ProductModel
    
    let availability: Availability
    
    var body: some View {
        Button(action: {
            self.product.selectedAvailability = self.availability
        }) {
            ZStack {
                self.availability.color
                    .opacity(0.3)
                    .cornerRadius(4)
//                    .frame(height: 36)
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
                    .frame(height: 16)
            }
        }
    }
}

struct AvailabilityLegend: View {
    
    let availability: Availability
    
    var body: some View {
        ZStack {
            self.availability.color
                .opacity(0.3)
                .cornerRadius(4)
            Text(self.availability.shortText)
                .font(.system(size: 11, weight: .bold, design: .default))
                .multilineTextAlignment(.center)
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
