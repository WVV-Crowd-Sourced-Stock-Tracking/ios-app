import SwiftUI
import UIKit

struct ShopList: View {
    
    @ObservedObject
    var model: ShopsModel
    
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
        ShopList(model: ShopsModel(shops: .preview))
    }
}
