import SwiftUI

class ShopListModel: ObservableObject {
    @Published var shops: [ShopModel]
    
    init(shops: [ShopModel]) {
        self.shops = shops
    }
}
