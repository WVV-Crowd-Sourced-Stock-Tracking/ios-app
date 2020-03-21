//
//  ShopMap.swift
//  Stock Tracking
//
//  Created by Leo Mehlig on 21.03.20.
//  Copyright © 2020 wIrvsvirus. All rights reserved.
//

import SwiftUI

struct ShopMap: View {
    @ObservedObject
    var model: ShopMapModel
    
    var body: some View {
//        MapView(landmarks: self.model.shops,
//                selectedLandmark: self.$model.selectedShop,
//                region: .constant(nil))
        EmptyView()
        
    }
}

class ShopMapModel: ObservableObject {
    @Published var shops: [ShopModel]
    @Published var selectedShop: ShopModel?
    
    init(shops: [ShopModel], selectedShop: ShopModel? = nil) {
        self.shops = shops
        self.selectedShop = selectedShop
    }
}

struct ShopMap_Previews: PreviewProvider {
    static var previews: some View {
        ShopMap(model: ShopMapModel(shops: .preview))
    }
}
