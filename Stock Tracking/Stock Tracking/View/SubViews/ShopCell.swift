//
//  ShopCell.swift
//  Stock Tracking
//
//  Created by Leo Mehlig on 21.03.20.
//  Copyright © 2020 wIrvsvirus. All rights reserved.
//

import SwiftUI

struct ShopCell: View {
    @ObservedObject
    var model: ShopModel
    
    var body: some View {
        NavigationLink(destination: EmptyView()) {
            VStack(spacing: 20) {
                VStack(spacing: 16) {
                    VStack(spacing: 8) {
                        HStack {
                            Text(self.model.name)
                                .font(.system(size: 21, weight: .bold, design: .default))
                                .foregroundColor(.primary)
                            Spacer()
                        }
                        HStack {
                            Text(self.model.address + " • " + self.model.distanceString)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                        HStack {
                            Group {
                                if self.model.isOpen != nil {
                                    if self.model.isOpen! {
                                        Text("Open Now")
                                            .foregroundColor(.full)
                                    } else {
                                        Text("Closed")
                                            .foregroundColor(.empty)
                                    }
                                }
                            }
                           
                            Spacer()
                        }
                    }
                    HStack(spacing: 20) {
                        ForEach(self.model.products.prefix(5)) { product in
                            HStack(spacing: 4) {
                                AvailabilityView(availability: product.availability)
                                    .frame(height: 12)
                                Text(product.name)
                                    .font(.system(size: 12, weight: .bold, design: .default))
                            }
                        }
                        Spacer()
                    }
                    Text("Last refresh today at 13:40")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.trailing)
                
                if self.model.isClose {
                    Button(action: { }) {
                        Text("Enter Stock")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .padding()
        }
    }
}

struct AvailabilityView: View {
    let availability: Availability
    
    var body: some View {
        Circle()
            .foregroundColor(self.availability.color)
            .aspectRatio(1, contentMode: .fit)
            .shadow(radius: 2)
            .overlay(
                Circle()
                    .foregroundColor(self.availability.color)
                    .blur(radius: 0.7)
        )
    }
}

struct ShopCell_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            ShopCell(model:  ShopModel(name: "Rewe",
                                       location: Location(latitude: 52.481998, longitude: 13.432388),
                                       address: "Herrfurtplatz 12, Berlin",
                                       distance: 500,
                                       shopAvailability: .middle,
                                       products: [
                                        ProductModel(name: "Milch", emoji: "🥛", availability: .full),
                                        ProductModel(name: "Bread", emoji: "🍞", availability: .unknown),
                                        ProductModel(name: "Toilet Paper", emoji: "🧻", availability: .empty),
            ]))
            Spacer()
        }
        
    }
}
