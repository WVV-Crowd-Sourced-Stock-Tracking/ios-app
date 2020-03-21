import SwiftUI
import UIKit

struct ShopList: View {
    
    @ObservedObject
    var model: ShopListModel
    
    var body: some View {
        List(self.model.shops) { shop in
            ShopCell(model: shop)
        }
        .onAppear {
            self.model.fetchLocation()
        }
    }
}


struct ShopList_Previews: PreviewProvider {
    static var previews: some View {
        ShopList(model: ShopListModel(shops: .preview))
    }
}
