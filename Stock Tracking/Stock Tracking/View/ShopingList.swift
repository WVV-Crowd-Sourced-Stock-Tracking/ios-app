//
//  ShopingList.swift
//  Stock Tracking
//
//  Created by Veit Progl on 21.03.20.
//  Copyright © 2020 wIrvsvirus. All rights reserved.
//

import SwiftUI

struct ShopingList: View {
    var body: some View {
		NavigationView() {
			List() {
				HStack() {
					VStack() {
						Text("Kategorie")
					}
				}
			}
			.navigationBarTitle("Einkaufsliste")
		}
    }
}

struct ShopingList_Previews: PreviewProvider {
    static var previews: some View {
        ShopingList()
    }
}
