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

//	@State var showSheet = false

    var body: some View {
		NavigationView() {
//			VStack() {
//				List() {
//					ForEach(categorys.list) { category in
//						Section(header: Text(category.name).bold()) {
//							ForEach(category.products) { product in
//								if product.selected {
//									Text(product.product.name)
//								}
//							}
//						}
//					}
//				}
//				VStack() {
//					Divider()
//					ScrollView(.horizontal, showsIndicators: true) {
//						HStack() {
//							ForEach(shopList.shops) { shop in
//								ShopCell(model: shop)
//								Divider()
//							}
//						}
//					}
//				}.padding()
//			}
			VStack() {
				ForEach(categorys.list) { category in
					Section(header: Text(category.name).bold().frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)) {
						ForEach(category.products) { product in
							AddToShoppingCell(product: product)
							Divider()
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
//			.navigationBarItems(trailing: Button(action: {
//				self.showSheet.toggle()
//			}) {
//				Image(systemName: "plus.circle.fill").imageScale(.large)
//            })
//			.sheet(isPresented: $showSheet, content: {
//				AddToShopingList(allCategory: self.categorys)
//			})
			.onAppear(perform: {
				self.categorys.list = self.categorys.getShopingList()
			})
		}
    }
}

//struct ShopingList_Previews: PreviewProvider {
//    static var previews: some View {
//        ShopingList()
//		 .environmentObject(ShopsModel(shops: .preview))
//    }
//}
