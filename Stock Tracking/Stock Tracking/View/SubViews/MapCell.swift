//
//  MapCell.swift
//  Stock Tracking
//
//  Created by Leo Mehlig on 21.03.20.
//  Copyright © 2020 wIrvsvirus. All rights reserved.
//

import SwiftUI

struct MapCell: View {
    @ObservedObject
    var model: ShopsModel
    
    var body: some View {
        NavigationLink(destination: ShopMap(model: self.model)) {
            VStack {
                HStack {
                    Text(.mapTitle)
                        .font(.system(size: 21, weight: .bold, design: .default))
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.headline)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                .padding(.top)
                ZStack {
                    MapView(self.$model.shops,
                            selected: .constant(nil),
                            region: self.$model.cellRegion) { _ in
                                EmptyView()
                    }
                    .allowsHitTesting(false)
                    Color.white.opacity(0.0001)
                }
                .frame(height: 150)
            }
            .background(Color.secondarySystemBackground)
            .cornerRadius(10)
            .padding()
        }
    }
}

struct MapCell_Previews: PreviewProvider {
    static var previews: some View {
        MapCell(model: ShopsModel(shops: .preview))
    }
}
