//
//  ShopsView.swift
//  Stock Tracking
//
//  Created by Leo Mehlig on 21.03.20.
//  Copyright © 2020 wIrvsvirus. All rights reserved.
//

import SwiftUI
import SwiftUIX

struct ShopsView: View {
    @EnvironmentObject var model: ShopsModel
    @EnvironmentObject var categorys: Categorys
    
    @State var showShowingList: Bool = false
    @State var showFilter = false
    
    let center = UNUserNotificationCenter.current()
    let content = UNMutableNotificationContent()
    
    var body: some View {
        NavigationView {
            ShopList(model: self.model)
                .alert(item: self.$model.error) { error in
                    Alert(title: Text(.errorTitle),
                          message: Text(error.localizedDescription),
                          dismissButton: .cancel())
            }
            .navigationBarTitle(.shopsTitle)
            .navigationBarItems(trailing:
                HStack(spacing: 36) {
                    Button(action: {
                        self.showFilter = true
                    }) {
                        Image(systemName: "line.horizontal.3.decrease.circle")
                            .font(.system(size: 26, weight: .medium, design: .rounded))
                            .foregroundColor(.accent)
                    }
                    .sheet(isPresented: self.$showFilter) {
						FilterView(show: self.$showFilter)
                    }
                    
//                    Button(action: {
//                        self.showShowingList = true
//                    }) {
//                        Image(systemName: "cart")
//                            .font(.system(size: 26, weight: .medium, design: .rounded))
//                    }
//                    .sheet(isPresented: self.$showShowingList) {
//                        ShopingList(shopList: self.model,
//                                    categorys: self.categorys)
//                    }
                }
            )
		}.navigationViewStyle(StackNavigationViewStyle())
    }
    
    func sendNotification() {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Test"
        notificationContent.body = "Test body"
        notificationContent.badge = NSNumber(value: 3)
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5,
                                                        repeats: false)
        let request = UNNotificationRequest(identifier: "testNotification",
                                            content: notificationContent,
                                            trigger: trigger)
        
        center.add(request) { (error) in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }
}

struct ShopsView_Previews: PreviewProvider {
    static var previews: some View {
        ShopsView()
            .environmentObject(ShopsModel(shops: .preview))
            .environmentObject(ShopsModel(shops: .preview))
    }
}
