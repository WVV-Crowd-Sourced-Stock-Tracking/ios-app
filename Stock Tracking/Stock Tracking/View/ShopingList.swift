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
    var body: some View {
		NavigationView() {
			VStack() {
				List() {
					HStack() {
						VStack() {
							Text("Kategorie")
						}
					}
				}
				ScrollView(.horizontal, showsIndicators: true) {
					HStack() {
						ForEach(shopList.shops) { shop in
							ShopCell(model: shop)
						}
					}
				}.padding()
			}
			.navigationBarTitle("Einkaufsliste")
		}
    }
}

struct ShopingList_Previews: PreviewProvider {
    static var previews: some View {
        ShopingList(shopList: ShopListModel(shops: [
            ShopModel(name: "Rewe", isClose: true, products: [
                ProductModel(name: "Milch", emoji: "🥛", availability: .full),
                ProductModel(name: "Bread", emoji: "🍞", availability: .unknown),
                ProductModel(name: "Toilet Paper", emoji: "🧻", availability: .empty),
            ]),
            ShopModel(name: "Lidl", products: [
                ProductModel(name: "Milch", emoji: "🥛", availability: .empty),
                ProductModel(name: "Bread", emoji: "🍞", availability: .empty),
                ProductModel(name: "Toilet Paper", emoji: "🧻", availability: .empty),
            ]),
            ShopModel(name: "Aldi", products: [
                ProductModel(name: "Milch", emoji: "🥛", availability: .full),
                ProductModel(name: "Bread", emoji: "🍞", availability: .middle),
                ProductModel(name: "Toilet Paper", emoji: "🧻", availability: .full),
            ]),
        ]))
    }
}
