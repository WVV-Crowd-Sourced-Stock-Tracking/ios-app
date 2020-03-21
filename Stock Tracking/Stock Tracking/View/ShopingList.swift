//
//  ShopingList.swift
//  Stock Tracking
//
//  Created by Veit Progl on 21.03.20.
//  Copyright © 2020 wIrvsvirus. All rights reserved.
//

import SwiftUI

struct ShopingList: View {
	@EnvironmentObject var shopList: ShopsModel
	@EnvironmentObject var categorys: Categorys

	@State var showSheet = false

    var body: some View {
		NavigationView() {
			VStack() {
				List() {
					ForEach(categorys.list) { category in
						Section(header: Text(category.name).bold()) {
							ForEach(category.products) { product in
								if product.selected {
									Text(product.product.name)
								}
							}
						}
					}
				}
				VStack() {
					Divider()
					ScrollView(.horizontal, showsIndicators: true) {
						HStack() {
							ForEach(shopList.shops) { shop in
								ShopCell(model: shop)
								Divider()
							}
						}
					}
				}.padding()
			}
			.navigationBarTitle("Einkaufsliste")
			.navigationBarItems(trailing: Button(action: {
				self.showSheet.toggle()
			}) {
				Image(systemName: "plus.circle.fill").imageScale(.large)
            })
			.sheet(isPresented: $showSheet, content: {
				AddToShopingList(allCategory: self.categorys)
			})
		}
    }
}

struct ShopingList_Previews: PreviewProvider {
    static var previews: some View {
        ShopingList()
		 .environmentObject(ShopsModel(shops: .preview))
    }
}
