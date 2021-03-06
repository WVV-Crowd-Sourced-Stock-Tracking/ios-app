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
    
    @Published var isLoading: Bool = false {
        didSet {
            if !self.isLoading && oldValue {
                self.isThanksDisplayed = true
            }
        }
    }
    
    @Published var isThanksDisplayed: Bool = false


    @Published var error: API.Error?
    
    let shop: Shop
    
    private var updateTask: AnyCancellable?
    
    var distanceString: String {
        ShopModel.distanceFormatter.string(from: Measurement(value: self.distance, unit: UnitLength.meters))
    }
    
    init(shop: Shop, products: [ProductModel]) {
        self.shop = shop
        self.id = shop.marketId.description
        self.name = shop.marketName
        self.distance = round(Double(shop.distance)!)
        self.address = shop.street
        self.isOpen = shop.open
        self.location = Location(latitude: Double(shop.latitude!)!, longitude: Double(shop.longitude!)!)
        self.region = MKCoordinateRegion(center: .init(location: self.location), latitudinalMeters: 1000, longitudinalMeters: 1000)
        self.products = products
        self.isClose = Double(shop.distance)! <= 100
    }
    
    func sendUpdate() {
        self.updateTask?.cancel()

        self.isLoading = true
        self.updateTask = API.sendUpdate(for: self.products, in: self.shop)
            .map { _ in false }
            .mapError { API.Error.from(error: $0) }
            .receive(on: RunLoop.main)
            .assignError(to: \DetailModel.error, on: self, replaceWith: false)
            .handleEvents(receiveCompletion: { _ in NotificationCenter.default.post(name: .reloadShops, object: nil) })
            .assignWeak(to: \DetailModel.isLoading, on: self)
    }
}
struct ShopDetailView: View {
    
    @ObservedObject
    var model: DetailModel
    
    @State var isEditing: Bool = false
    @State var isThanksDisplayed: Bool = false
    
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
                        Group {
                            if self.isThanksDisplayed {
                                Image(systemName: "heart.fill")
                            } else if self.isEditing {
                                Image(systemName: "icloud.and.arrow.up.fill")
                            } else {
                                Image(systemName: "tray.full.fill")
                            }
                        }
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
                    Color.grouped.edgesIgnoringSafeArea(.all)
                }
            )
                .background(
            ConfettiView(contents: [
                   .image(UIImage(named: "heart")!, UIColor.empty),
                   .image(UIImage(named: "heart")!, UIColor.mid),
                   .image(UIImage(named: "heart")!, UIColor.accent),
                   .image(UIImage(named: "heart")!, UIColor.full),
               ], isEmitting: $isThanksDisplayed)
                   .frame(maxWidth: .infinity, maxHeight: .infinity)
            )
        }
            .onReceive(self.model.$isThanksDisplayed) { thanks in // workaround
                if thanks {
                    withAnimation {
                        self.isThanksDisplayed = thanks
                    }
                }
        }
        .alert(item: self.$model.error) { error in
            Alert(title: Text(.errorTitle),
                  message: Text(error.localizedDescription),
                  dismissButton: .cancel())
        }
        .navigationBarTitle(self.model.name)
    }
    
    var buttonTitle: LocalizedStringKey {
        if self.isThanksDisplayed {
            return .thanksText
        } else if self.model.isLoading {
            return .shopSending
        } else if self.isEditing {
            return .shopSend
        } else {
            return .shopEdit
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
            .background(Color.tertiarySystemBackground)
            .cornerRadius(10)
            .padding()
            
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    Text(.shopProductsTitle)
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
                        HStack {
                            Text(.shopProductsAvailability)
                                .font(.headline)
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                        .frame(width: 148)
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
                                    .minimumScaleFactor(0.8)
                                    .lineLimit(1)
                                Spacer()
                                if !self.isEditing {
//                                    HStack {
                                        AvailabilityView(availability: product.availability)
                                            .frame(height: 12)
                                    HStack {
                                        Text(product.availability.text)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                            .transition(.opacity)
                                        Spacer()
                                    }
                                            .frame(width: 120)
//                                    }
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
                .background(Color.tertiarySystemBackground)
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
                Circle()
                    .stroke(self.availability.color, lineWidth: 2)
                    .overlay(
                        Circle()
                            .fill(self.availability.color)
                            .padding(3)
                            .opacity(product.selectedAvailability == self.availability ? 1 : 0)
                        
                )
                    .frame(height: 12)
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
                .font(.system(size: 10, weight: .bold, design: .default))
                .multilineTextAlignment(.center)
        }
    }
}

struct ShopDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ShopDetailView(model: DetailModel(shop: [ShopModel].preview.first!.shop, products: .preview), isEditing: false)
        }
    }
}
