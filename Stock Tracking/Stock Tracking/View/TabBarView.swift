//
//  TabBarView.swift
//  Stock-Tracking
//
//  Created by Veit Progl on 21.03.20.
//  Copyright © 2020 Veit Progl. All rights reserved.
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
		TabView {
			VStack() {
                ShopsView()
                .environmentObject(ShopsModel())
			}.tabItem({
				TabLabel(imageName: "cart.fill", label: "Shops")
			})

			VStack() {
				ShopingList()
					.environmentObject(ShopListModel())
			}.tabItem({
				TabLabel(imageName: "list.bullet", label: "Einkaufsliste")
			})
		}
    }
	
	struct TabLabel: View {
		let imageName: String
		let label: String

		var body: some View {
			HStack {
				Image(systemName: imageName)
				Text(label)
			}
		}
	}
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}
