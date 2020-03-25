import SwiftUI
import UIKit
import SwiftUIX

struct ShopList: View {
    
    @ObservedObject
    var model: ShopsModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if !self.model.isLocationErrorVisisble {
                    MapCell(model: self.model)
                    if self.model.isLoading {
                        ActivityIndicator()
                            .style(.large)
                            .tintColor(.accent)
                    }
                    ForEach(self.model.shops) { shop in
                        ShopCell(model: shop)
                    }
                } else {
                    LocationErrorView()
                }
            }
        }
        .onAppear {
            self.model.fetchLocation()
            let center = UNUserNotificationCenter.current()
            let options: UNAuthorizationOptions = [.alert, .sound];
            center.requestAuthorization(options: options) {
                (granted, error) in
                if !granted {
                    print("Something went wrong")
                }
            }
            UIScrollView.appearance().backgroundColor = UIColor.systemGroupedBackground
        }
    }
}


struct ShopList_Previews: PreviewProvider {
    static var previews: some View {
        ShopList(model: ShopsModel(shops: .preview))
    }
}
