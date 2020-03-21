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

class CategoryModel: ObservableObject, Identifiable {
    @Published var id: UUID = .init()
    @Published var name: String
    @Published var products: [ProductModel]
    
    init(name: String, products: [ProductModel])  {
        self.name = name
        self.products = products
    }
}
