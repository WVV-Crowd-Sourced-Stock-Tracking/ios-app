//
//  ShopsView.swift
//  Stock Tracking
//
//  Created by Leo Mehlig on 21.03.20.
//  Copyright © 2020 wIrvsvirus. All rights reserved.
//

import SwiftUI

struct ShopsView: View {
    @EnvironmentObject var model: ShopsModel
	@EnvironmentObject var categorys: Categorys
	
	@State var showShowingList = false
	@State var showFilter = false
	
    var body: some View {
        NavigationView {
                ShopList(model: self.model)
                    .alert(item: self.$model.error) { error in
                        Alert(title: Text("Something went wrong..."),
                              message: Text(error.localizedDescription),
                              dismissButton: .cancel())
                }
                .navigationBarTitle("Shops")
				.navigationBarItems(trailing: VStack() {
					Button(action: {
						self.showShowingList.toggle()
					}) {
						Image(systemName: "bag.fill").imageScale(.large)
					}
				})
				.sheet(isPresented: self.$showShowingList, content: {
					VStack() {
						ShopingList(shopList: self.model, categorys: self.categorys)
					}
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
