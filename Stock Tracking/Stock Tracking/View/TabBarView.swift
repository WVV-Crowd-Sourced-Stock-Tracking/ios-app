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
				Text("Suche")
			}.tabItem({
				TabLabel(imageName: "house.fill", label: "Suche")
			})

			VStack() {
				Text("Einkaufsliste")
			}.tabItem({
				TabLabel(imageName: "house.fill", label: "Einkaufsliste")
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
