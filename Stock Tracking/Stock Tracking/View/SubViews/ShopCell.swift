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
        VStack(spacing: 20) {
            NavigationLink(destination: EmptyView()) {
                VStack(spacing: 16) {
                    VStack(spacing: 4) {
                        HStack {
                            Text(self.model.name)
                                .font(.system(size: 21, weight: .bold, design: .default))
                                .foregroundColor(.primary)
                            Spacer()
                            Text("Closing 19:00")
                                .font(.subheadline)
                                .foregroundColor(.orange)
                        }
                        HStack {
                            Text("Herrfurtplatz 12, Berlin • 500 m")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                    }
                    HStack(spacing: 20) {
                        ForEach(self.model.products.prefix(5)) { product in
                            HStack(spacing: 4) {
                                AvailabilityView(availability: product.availability)
                                    .frame(height: 20)
                                //                        Text(product.emoji)
                                //                            .padding(4)
                                Text(product.name)
                                    .font(.system(size: 12, weight: .bold, design: .default))
                            }
                        }
                        Spacer()
                    }
                }
                .padding(.trailing)
            }

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
        .padding(.horizontal)
        .padding(.vertical, 6)
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
            ShopCell(model:  ShopModel(name: "Rewe", products: [
                ProductModel(name: "Milch", emoji: "🥛", availability: .full),
                ProductModel(name: "Bread", emoji: "🍞", availability: .unknown),
                ProductModel(name: "Toilet Paper", emoji: "🧻", availability: .empty),
            ]))
            Spacer()
        }
    }
}
