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
        ShopList(model: ShopListModel(shops: [
            ShopModel(name: "Rewe", isClose: true, products: [
                ProductModel(name: "Milch", emoji: "🥛", availability: .full),
                ProductModel(name: "Bread", emoji: "🍞", availability: .unknown),
                ProductModel(name: "Toilet Paper", emoji: "🧻", availability: .empty),
            ]),
            ShopModel(name: "Lidl", products: [
                ProductModel(name: "Milch", emoji: "🥛", availability: .empty),
                ProductModel(name: "Bread", emoji: "🍞", availability: .empty),
                ProductModel(name: "Toilet Paper", emoji: "🧻", availability: .empty),
            ]),
            ShopModel(name: "Aldi", products: [
                ProductModel(name: "Milch", emoji: "🥛", availability: .full),
                ProductModel(name: "Bread", emoji: "🍞", availability: .middle),
                ProductModel(name: "Toilet Paper", emoji: "🧻", availability: .full),
            ]),
        ]))
    }
}
