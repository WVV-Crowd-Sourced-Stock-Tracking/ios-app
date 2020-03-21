//
//  AddToShopingList.swift
//  Stock Tracking
//
//  Created by Veit Progl on 21.03.20.
//  Copyright © 2020 wIrvsvirus. All rights reserved.
//

import SwiftUI

struct AddToShopingList: View {
	@State var allCategory = Categorys(list: [
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

    var body: some View {
		VStack() {
			ForEach(allCategory.list) { category in
				Section(header: Text(category.name).bold()) {
					ForEach(category.products) { product in
						VStack() {
							HStack() {
								Image(systemName: "circle")
								Text(product.name)
									.frame(minWidth: 0,
										   maxWidth: .infinity,
										   minHeight: 0,
										   maxHeight: 30,
										   alignment: .leading)
							}
							Divider()
						}
					}
				}
			}
		}.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0,  maxHeight: .infinity, alignment: .leading)
		.padding()
	}
}

struct AddToShopingList_Previews: PreviewProvider {
    static var previews: some View {
        AddToShopingList()
    }
}

