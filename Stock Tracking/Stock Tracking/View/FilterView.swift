//
//  FilterView.swift
//  Stock Tracking
//
//  Created by Veit Progl on 21.03.20.
//  Copyright © 2020 wIrvsvirus. All rights reserved.
//

import SwiftUI

struct FilterView: View {
	@ObservedObject var allCategory: Categorys

    var body: some View {
		NavigationView() {
			VStack() {
				ForEach(allCategory.list) { category in
					Section(header: Text(category.name).bold().frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)) {
						ForEach(category.products) { product in
							FilterCell(product: product)
							Divider()
						}
					}
				}
				Spacer()
			}
			.padding()
			.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0,  maxHeight: .infinity, alignment: .leading)
			.onDisappear(perform: {
				self.allCategory.updateShopingList()
			})
			.navigationBarTitle("Filter")
		}
	}
}

struct FilterCell: View {
    @ObservedObject var product: CategoryProduct
    
    var body: some View {
        VStack() {
            HStack() {
                Image(systemName: product.filter ? "largecircle.fill.circle" : "circle")
                Text(product.product.name)
                    .frame(minWidth: 0,
                           maxWidth: .infinity,
                           minHeight: 0,
                           maxHeight: 30,
                           alignment: .leading)
            }.onTapGesture {
                self.product.filter.toggle()
            }
        }
    }
}
