import SwiftUI
import UIKit

struct ShopList: View {
    
    @ObservedObject
    var model: ShopsModel
    
    var body: some View {
        ScrollView {
            VStack {
                MapCell(model: self.model)
                ForEach(self.model.shops) { shop in
                    ShopCell(model: shop)
                }
                Spacer()
                    .frame(maxHeight: .infinity)
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
