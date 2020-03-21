import SwiftUI

class ShopModel: ObservableObject, Identifiable {
    @Published var id: UUID = .init()
    @Published var name: String
    @Published var products: [ProductModel]
    @Published var isClose: Bool
    
    init(name: String, isClose: Bool = false, products: [ProductModel])  {
        self.name = name
        self.products = products
        self.isClose = isClose
    }
}

