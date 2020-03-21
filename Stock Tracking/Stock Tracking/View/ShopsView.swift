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
    var body: some View {
        NavigationView {
                ShopList(model: self.model)
                    .alert(item: self.$model.error) { error in
                        Alert(title: Text("Something went wrong..."),
                              message: Text(error.localizedDescription),
                              dismissButton: .cancel())
                }
                .navigationBarTitle("Shops")
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
