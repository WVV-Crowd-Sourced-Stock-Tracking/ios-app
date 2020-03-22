//
//  ShopCell.swift
//  Stock Tracking
//
//  Created by Leo Mehlig on 21.03.20.
//  Copyright © 2020 wIrvsvirus. All rights reserved.
//

import SwiftUI


struct LazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}
struct ShopCell: View {
    @ObservedObject
    var model: ShopModel
    
    var detail: some View {
        LazyView {
            ShopDetailView(model: DetailModel(shop: self.model.shop))
        }
    }
    var editDetail: some View {
        LazyView {
            ShopDetailView(model: DetailModel(shop: self.model.shop), isEditing: true)
        }
    }
    
    var body: some View {
        VStack(spacing: 20) {
            NavigationLink(destination: self.detail) {
                VStack(spacing: 16) {
                    VStack(spacing: 8) {
                        HStack {
                            Text(self.model.name)
                                .font(.system(size: 21, weight: .bold, design: .default))
                                .foregroundColor(.primary)
                            Spacer()
                            Group {
                                if self.model.isOpen != nil {
                                    if self.model.isOpen! {
                                        Text(.shopOpen)
                                            .foregroundColor(.full)
                                    } else {
                                        Text(.shopClosed)
                                            .foregroundColor(.empty)
                                    }
                                }
                            }
                            .font(.footnote)
                        }
                        HStack {
                            Text(self.model.address + " • " + self.model.distanceString)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                    }
                    HStack(spacing: 20) {
                        ForEach(self.model.products.prefix(3)) { product in
                            HStack(spacing: 4) {
                                AvailabilityView(availability: product.availability)
                                    .frame(height: 12)
                                Text(product.name)
                                    .font(.system(size: 11, weight: .bold, design: .default))
                            }
                        }
                        Spacer()
                    }
//                    Text("Last refresh today at 13:40")
//                        .font(.caption)
//                        .foregroundColor(.secondary)
                }
                .padding(.trailing)
            }
            if self.model.isClose {
                NavigationLink(destination: self.editDetail) {
                    HStack {
                        Image(systemName: "tray.full.fill")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Text(.shopEdit)
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.accent)
                    .cornerRadius(10)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .padding(.horizontal)
    }
}

struct GlowModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
			.shadow(color: Color.black.opacity(0.1), radius: 2)
            .overlay(
                content
                    .blur(radius: 0.7)
        )
    }
    
    
    
}

struct AvailabilityView: View {
    let availability: Availability
    
    var body: some View {
        Circle()
            .foregroundColor(self.availability.color)
            .aspectRatio(1, contentMode: .fit)
            .modifier(GlowModifier())
    }
}

struct ShopCell_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            ShopCell(model:  ShopModel(name: "Rewe",
                                       isClose: true,
                                       location: Location(latitude: 52.481998, longitude: 13.432388),
                                       address: "Herrfurtplatz 12, Berlin",
                                       distance: 100,
                                       isOpen: true,
                                       shopAvailability: 44,
                                       products: [
                                        ProductModel(name: "Milch", emoji: "🥛", availability: .full),
                                        ProductModel(name: "Bread", emoji: "🍞", availability: .unknown),
                                        ProductModel(name: "Toilet Paper", emoji: "🧻", availability: .empty),
            ]))
            
            HStack {
                Spacer()
                AvailabilityButton(product: [ProductModel].all.first!,
                                   availability: .mid)
                    .frame(width: 60, height: 36)
                Spacer()
            }
            Spacer()
        }
        
    }
}
