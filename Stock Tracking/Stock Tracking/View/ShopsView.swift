//
//  ShopsView.swift
//  Stock Tracking
//
//  Created by Leo Mehlig on 21.03.20.
//  Copyright © 2020 wIrvsvirus. All rights reserved.
//

import SwiftUI

struct ShopsView: View {
    @EnvironmentObject
    var listModel: ShopListModel
    
    @EnvironmentObject
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
                Group {
                    if showList {
                        Image(systemName: "map.fill")
                    } else {
                        Image(systemName: "list.bullet")
                    }
                }
                    .font(.title)
            })
        }
    }
}

struct ShopsView_Previews: PreviewProvider {
    static var previews: some View {
        ShopsView()
            .environmentObject(ShopListModel(shops: .preview))
            .environmentObject(ShopMapModel(shops: .preview))
    }
}
