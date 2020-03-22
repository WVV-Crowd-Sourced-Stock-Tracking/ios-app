//
//  ShopingList.swift
//  Stock Tracking
//
//  Created by Veit Progl on 21.03.20.
//  Copyright © 2020 wIrvsvirus. All rights reserved.
//

import SwiftUI

struct ShopingList: View {
	@ObservedObject var shopList: ShopsModel
	@ObservedObject var categorys: Categorys

	@State var showSheet = false

    var body: some View {
		NavigationView() {
			VStack() {
				ForEach(categorys.list) { category in
					Section(header: Text(category.name).bold().frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)) {
						ForEach(category.products) { product in
							if product.selected {
								ShoppingCell(product: product)
								Divider()
							}
						}
					}
				}
				ForEach(categorys.customItems) { item in
					HStack() {
						CustomItemCell(item: item)
						Button(action: {
							self.categorys.deleteCustomItem(item: item)
						}) {
							Image(systemName: "trash.fill").foregroundColor(Color.blue)
						}
					}
				}
				Spacer()
			}
			.padding()
			.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0,  maxHeight: .infinity, alignment: .leading)
			.onDisappear(perform: {
				self.categorys.updateShopingList()
			})
			.navigationBarTitle("Einkaufsliste")
			.navigationBarItems(trailing: Button(action: {
				self.showSheet.toggle()
			}) {
				Image(systemName: "plus.circle.fill").imageScale(.large)
            })
			.sheet(isPresented: $showSheet, content: {
				AddToShopingList(allCategory: self.categorys)
			})
			.onAppear(perform: {
				self.categorys.list = self.categorys.getShopingList()
			})
		}
    }
}

struct ShoppingCell: View {
    @ObservedObject var product: CategoryProduct
    
    var body: some View {
        VStack() {
            HStack() {
				Image(systemName: product.bought ? "checkmark.circle.fill" : "circle")
                Text(product.product.name)
                    .frame(minWidth: 0,
                           maxWidth: .infinity,
                           minHeight: 0,
                           maxHeight: 30,
                           alignment: .leading)
            }.onTapGesture {
				self.product.bought.toggle()
            }
        }
    }
}

struct CustomItemCell: View {
	@ObservedObject var item: CustomItemModel
    
    var body: some View {
        HStack() {
            HStack() {
				Image(systemName: item.bought ? "checkmark.circle.fill" : "circle")
				Text(item.name)
				Spacer()
				
			}.onTapGesture {
				self.item.bought.toggle()
			}
        }
    }
}
