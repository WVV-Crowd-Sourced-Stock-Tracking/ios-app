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
	@Published var customItems: [CustomItemModel]
	
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
		self.customItems = []
		self.list = getShopingList()
		self.customItems = getCustomItems()
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
	
	func getCustomItems() -> [CustomItemModel] {
		let items =  defaults.array(forKey: "customItems") as? [[String]]
		if items != nil {
			var savedItems = [CustomItemModel]()
			for item in items! {
				savedItems.append(CustomItemModel(name: item[0], bought: item[1] == "true" ? true : false))
			}
			return savedItems
		} else {
			return []
		}
	}
	
	func updateCustomItems(){
		var saveItems = [[String]]()
		for item in customItems {
			saveItems.append([item.name, "\(item.bought)"])
		}
		defaults.set(saveItems, forKey: "customItems")
	}
	
	func deleteCustomItem(item: CustomItemModel) {
		if let index = customItems.firstIndex(of: item) {
			customItems.remove(at: index)
		}
	}
}

class CustomItemModel: ObservableObject, Codable, Identifiable, Equatable {
	static func == (lhs: CustomItemModel, rhs: CustomItemModel) -> Bool {
		return lhs.id == rhs.id
	}
	
	@Published var id: UUID = .init()
	@Published var name: String
	@Published var bought: Bool
	
	init(name: String, bought: Bool) {
		self.name = name
		self.bought = bought
	}
	
	enum CodingKeys: CodingKey {
		case id
		case name
		case bought
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)

		try container.encode(id, forKey: .id)
		try container.encode(name, forKey: .name)
		try container.encode(bought, forKey: .bought)
	}
	
	required init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		id = try container.decode(UUID.self, forKey: .id)
		name = try container.decode(String.self, forKey: .name)
		bought = try container.decode(Bool.self, forKey: .bought)
	}
}

class CategoryProduct: ObservableObject, Identifiable {
	@Published var id: UUID = .init()
	@Published var product: ProductModel
	@Published var selected: Bool
	@Published var bought: Bool
	@Published var filter: Bool
	
	init(product: ProductModel, selected: Bool, bought: Bool = false, filter: Bool = false)  {
        self.product = product
        self.selected = selected
		self.bought = bought
		self.filter = filter
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
