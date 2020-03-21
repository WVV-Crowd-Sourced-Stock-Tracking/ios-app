//
//  ShopingList.swift
//  Stock Tracking
//
//  Created by Veit Progl on 21.03.20.
//  Copyright © 2020 wIrvsvirus. All rights reserved.
//

import SwiftUI



struct ShopingList: View {
	@ObservedObject var shopList: ShopListModel
	@ObservedObject var categorys: Categorys

    var body: some View {
		NavigationView() {
			VStack() {
				List() {
					ForEach(categorys.list) { category in
						Section(header: Text(category.name).bold()) {
							ForEach(category.products) { product in
								Text(product.name)
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
			.navigationBarItems(trailing: Button(action: { }) {
				Image(systemName: "plus.circle.fill").imageScale(.large)
            })
		}
    }
}

struct ShopingList_Previews: PreviewProvider {
    static var previews: some View {
        ShopingList(shopList: ShopListModel(shops: .preview),
                    categorys: Categorys(list: [
				CategoryModel(name: "Lebensmittel", products: [
					ProductModel(name: "Milch", emoji: "🥛", availability: .empty),
					ProductModel(name: "Bread", emoji: "🍞", availability: .empty),
					ProductModel(name: "Toilet Paper", emoji: "🧻", availability: .empty)
				]),
				CategoryModel(name: "Produkte", products: [
					ProductModel(name: "Klopapier", emoji: "🥛", availability: .empty),
					ProductModel(name: "Seifen", emoji: "🍞", availability: .empty)
				])
			])
		)
    }
}
