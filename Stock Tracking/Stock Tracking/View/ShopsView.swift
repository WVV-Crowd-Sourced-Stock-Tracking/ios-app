//
//  ShopsView.swift
//  Stock Tracking
//
//  Created by Leo Mehlig on 21.03.20.
//  Copyright © 2020 wIrvsvirus. All rights reserved.
//

import SwiftUI

struct ShopsView: View {
    @ObservedObject
    var listModel: ShopListModel
    
    @ObservedObject
    var mapModel: ShopMapModel
    
    @State private var showList = true
    
    var body: some View {
        NavigationView {
            Group {
                if self.showList {
                    ShopList(model: self.listModel)
                } else {
                    ShopMap(model: self.mapModel)
                }
            }
            .navigationBarTitle("Shops")
            .navigationBarItems(trailing: Button(action: {
                self.showList.toggle()
            }) {
                Image(systemName: "map.fill")
            })
        }
    }
}

struct ShopsView_Previews: PreviewProvider {
    static var previews: some View {
        ShopsView(listModel: ShopListModel(shops: .preview),
                  mapModel: ShopMapModel(shops: .preview))
    }
}
