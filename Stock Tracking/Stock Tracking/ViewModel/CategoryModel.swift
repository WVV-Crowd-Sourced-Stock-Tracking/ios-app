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
	
	init(list: [CategoryModel]) {
        self.list = list
    }
}

class CategoryProduct: ObservableObject, Identifiable {
	@Published var id: UUID = .init()
	@Published var product: ProductModel
	@Published var selected: Bool
	
	init(product: ProductModel, selected: Bool)  {
        self.product = product
        self.selected = selected
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
