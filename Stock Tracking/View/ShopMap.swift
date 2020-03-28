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
import Combine

struct ShopMap: View {
    @ObservedObject
    var model: ShopsModel
    
    var detail: some View {
          LazyView {
            ShopDetailView(model: DetailModel(shop: self.model.selectedShop!.shop, products: self.model.selectedShop!.products))
          }
      }
    
    var body: some View {
        MapView(self.$model.shops,
                selected: self.$model.selectedShop,
                region: self.$model.region) { shop in
                    HStack(spacing: 12) {
                        ForEach(shop.products.prefix(3)) { product in
                            HStack(spacing: 6) {
                                AvailabilityView(availability: product.availability)
                                    .frame(height: 16)
                                Text(product.emoji)
                                    .font(.footnote)
                            }
                        }
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.clear)
                    .padding(.vertical, 4)
        }
        .background(
            NavigationLink(destination: self.detail, isActive: self.$model.hasSelection, label: { EmptyView() })
                .opacity(0)
        )
            .edgesIgnoringSafeArea(.all)
        .onAppear {
            self.model.fetchLocation()
        }
    }
}



struct ShopMap_Previews: PreviewProvider {
    static var previews: some View {
        ShopMap(model: ShopsModel(shops: .preview))
    }
}
