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
    var model: ShopsModel

    @State private var showList = true
    
    var body: some View {
        NavigationView {
            Group {
                if self.showList {
                    ShopList(model: self.model)
                } else {
                    ShopMap(model: self.model)
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
                    .font(.headline)
            })
        }
    }
}

struct ShopsView_Previews: PreviewProvider {
    static var previews: some View {
        ShopsView()
            .environmentObject(ShopsModel(shops: .preview))
            .environmentObject(ShopsModel(shops: .preview))
    }
}
