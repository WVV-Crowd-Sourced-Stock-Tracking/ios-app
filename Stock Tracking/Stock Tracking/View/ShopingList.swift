//
//  ShopingList.swift
//  Stock Tracking
//
//  Created by Veit Progl on 21.03.20.
//  Copyright © 2020 wIrvsvirus. All rights reserved.
//

import SwiftUI

struct ShopingList: View {
	@State var landmarks: [Landmark] = [
		   Landmark(name: "Sydney Harbour Bridge", location: .init(latitude: -33.852222, longitude: 151.210556)),
		   Landmark(name: "Brooklyn Bridge", location: .init(latitude: 40.706, longitude: -73.997)),
		   Landmark(name: "Golden Gate Bridge", location: .init(latitude: 37.819722, longitude: -122.478611))
	   ]
	@State var selectedLandmark: Landmark? = nil
	
    var body: some View {
		NavigationView() {
			List() {
				Section(header: Text("Store")) {
					HStack() {
						MapView(landmarks: $landmarks, selectedLandmark: $selectedLandmark)
							.frame(width: 200, height: 200)
						VStack() {
							Text("Shop Name").font(Font.headline).bold()
						}
					}
				}
			}
			.navigationBarTitle("Einkaufsliste")
			.listStyle(GroupedListStyle())
		}
    }
}

struct ShopingList_Previews: PreviewProvider {
    static var previews: some View {
        ShopingList()
    }
}
