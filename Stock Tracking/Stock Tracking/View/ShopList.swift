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
            UIScrollView.appearance().backgroundColor = UIColor.systemGroupedBackground
        }
    }
}


struct ShopList_Previews: PreviewProvider {
    static var previews: some View {
        ShopList(model: ShopsModel(shops: .preview))
    }
}
