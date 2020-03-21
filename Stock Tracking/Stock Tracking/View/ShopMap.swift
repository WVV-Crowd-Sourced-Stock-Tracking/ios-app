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
    
    var body: some View {
        MapView(self.$model.shops,
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
            self.model.fetchLocation()
        }
    }
}



struct ShopMap_Previews: PreviewProvider {
    static var previews: some View {
        ShopMap(model: ShopsModel(shops: .preview))
    }
}
