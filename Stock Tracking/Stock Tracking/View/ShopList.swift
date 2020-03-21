import SwiftUI
import UIKit

struct ShopList: View {
    
    @ObservedObject
    var model: ShopListModel
    
    var body: some View {
        NavigationView {
            List(self.model.shops) { shop in
                ShopCell(model: shop)
            }
            .navigationBarTitle("Shops")
            .navigationBarItems(trailing: Button(action: { }) {
                Image(systemName: "map.fill")
            })
        }
    }
}


struct ShopList_Previews: PreviewProvider {
    static var previews: some View {
        ShopList(model: ShopListModel(shops: .preview))
    }
}
