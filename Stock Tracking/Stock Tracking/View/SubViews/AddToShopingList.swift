//
//  AddToShopingList.swift
//  Stock Tracking
//
//  Created by Veit Progl on 21.03.20.
//  Copyright © 2020 wIrvsvirus. All rights reserved.
//

import SwiftUI

struct AddToShopingList: View {
	@ObservedObject var allCategory: Categorys

    var body: some View {
		VStack() {
			ForEach(allCategory.list) { category in
				Section(header: Text(category.name).bold()) {
					ForEach(category.products) { product in
					AddToShoppingCell(product: product)
					}
				}
			}
		}.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0,  maxHeight: .infinity, alignment: .leading)
		.padding()
			.onDisappear(perform: {
				self.allCategory.updateShopingList()
			})
	}
}

struct AddToShoppingCell: View {
    @ObservedObject var product: CategoryProduct
    
    var body: some View {
        VStack() {
            HStack() {
                Image(systemName: product.selected ? "largecircle.fill.circle" : "circle")
                Text(product.product.name)
                    .frame(minWidth: 0,
                           maxWidth: .infinity,
                           minHeight: 0,
                           maxHeight: 30,
                           alignment: .leading)
            }.onTapGesture {
                self.product.selected.toggle()
                print(self.product.selected)
            }
            Divider()
        }
    }
}
struct AddToShopingList_Previews: PreviewProvider {
    static var previews: some View {
		AddToShopingList(allCategory: Categorys(list: [
			CategoryModel(name: "Lebensmittel", products: [
				CategoryProduct(product: ProductModel(name: "Milch", emoji: "🥛", availability: .empty), selected: false),
				CategoryProduct(product: ProductModel(name: "Bread", emoji: "🍞", availability: .empty), selected: false),
				CategoryProduct(product: ProductModel(name: "Toilet Paper", emoji: "🧻", availability: .empty), selected: false)
			]),
			CategoryModel(name: "Produkte", products: [
				CategoryProduct(product: ProductModel(name: "Klopapier", emoji: "🥛", availability: .empty), selected: false),
				CategoryProduct(product: ProductModel(name: "Seifen", emoji: "🍞", availability: .empty), selected: false)
			])
		]))
    }
}

