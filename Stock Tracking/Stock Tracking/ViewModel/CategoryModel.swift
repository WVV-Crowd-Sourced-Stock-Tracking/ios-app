//
//  CategoryModel.swift
//  Stock Tracking
//
//  Created by Veit Progl on 21.03.20.
//  Copyright © 2020 wIrvsvirus. All rights reserved.
//

import SwiftUI

class Categorys: ObservableObject {
	@Published var list: [CategoryModel]
	
	let defaults = UserDefaults.standard

	let defaultList = [
		CategoryModel(name: "Lebensmittel", products: [
			CategoryProduct(product: ProductModel(name: "Milch", emoji: "🥛", availability: .empty), selected: false),
			CategoryProduct(product: ProductModel(name: "Bread", emoji: "🍞", availability: .empty), selected: false),
			CategoryProduct(product: ProductModel(name: "Toilet Paper", emoji: "🧻", availability: .empty), selected: false)
		]),
		CategoryModel(name: "Produkte", products: [
			CategoryProduct(product: ProductModel(name: "Klopapier", emoji: "🥛", availability: .empty), selected: false),
			CategoryProduct(product: ProductModel(name: "Seifen", emoji: "🍞", availability: .empty), selected: false)
		])
	]
	
	init(list: [CategoryModel]) {
		self.list = defaultList
		self.list = getShopingList()
    }

	func updateShopingList() {
		var selectedItemsID = [[Int]]()
		var categorieID = 0
		for categorie in list {
			var productID = 0
			for product in categorie.products {
				if product.selected {
					if product.bought {
						selectedItemsID.append([categorieID, productID, 1])
					} else {
						selectedItemsID.append([categorieID, productID, 0])
					}
				}
				productID += 1
			}
			categorieID += 1
		}
		defaults.set(selectedItemsID, forKey: "categorys")
	}

	func getShopingList() -> [CategoryModel] {
		let categorys = defaults.array(forKey: "categorys")
		if categorys != nil {
			let selectedItemsID = categorys as! [[Int]]
			for product in selectedItemsID {
				defaultList[product[0]].products[product[1]].selected = true
				print(defaultList.endIndex)
				if defaultList.endIndex == 2 {
					defaultList[product[0]].products[product[1]].bought = product[2] == 1 ? true : false
				}
			}
		}
		return defaultList
	}
}

class CategoryProduct: ObservableObject, Identifiable {
	@Published var id: UUID = .init()
	@Published var product: ProductModel
	@Published var selected: Bool
	@Published var bought: Bool
	
	init(product: ProductModel, selected: Bool, bought: Bool = false)  {
        self.product = product
        self.selected = selected
		self.bought = bought
    }
}

class CategoryModel: ObservableObject, Identifiable {
    @Published var id: UUID = .init()
    @Published var name: String
	@Published var products: [CategoryProduct]
    
    init(name: String, products: [CategoryProduct])  {
        self.name = name
        self.products = products
    }
}
