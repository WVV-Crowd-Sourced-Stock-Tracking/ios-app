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
                Image(systemName: "map")
            })
        }
    }
}

struct ShopCell: View {
    @ObservedObject
    var model: ShopModel
    
    var body: some View {
        VStack(spacing: 20) {
            NavigationLink(destination: EmptyView()) {
                VStack(spacing: 16) {
                    VStack(spacing: 4) {
                        HStack {
                            Text(self.model.name)
                                .font(.system(size: 21, weight: .bold, design: .default))
                                .foregroundColor(.primary)
                            Spacer()
                            Text("Closing 19:00")
                                .font(.subheadline)
                                .foregroundColor(.orange)
                        }
                        HStack {
                            Text("Herrfurtplatz 12, Berlin • 500 m")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                    }
                    HStack(spacing: 20) {
                        ForEach(self.model.products.prefix(5)) { product in
                            HStack(spacing: 4) {
                                AvailabilityView(availability: product.availability)
                                    .frame(height: 20)
                                //                        Text(product.emoji)
                                //                            .padding(4)
                                Text(product.name)
                                    .font(.system(size: 12, weight: .bold, design: .default))
                            }
                        }
                        Spacer()
                    }
                }
                .padding(.trailing)
            }

            if self.model.isClose {
                Button(action: { }) {
                    Text("Enter Stock")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 6)
    }
}

struct AvailabilityView: View {
    let availability: Availability
    
    var body: some View {
        Circle()
            .foregroundColor(self.availability.color)
            .aspectRatio(1, contentMode: .fit)
            .shadow(radius: 1)
    }
}

class ShopListModel: ObservableObject {
    @Published var shops: [ShopModel]
    
    init(shops: [ShopModel]) {
        self.shops = shops
    }
}

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

class ProductModel: ObservableObject, Identifiable {
    @Published var id: UUID = .init()
    @Published var name: String
    @Published var emoji: String
    @Published var availability: Availability
    
    init(name: String, emoji: String, availability: Availability) {
        self.name = name
        self.emoji = emoji
        self.availability = availability
    }
}

enum Availability {
    case full, middle, empty, unknown
    
    var color: Color {
        switch self {
        case .full:
            return .green
        case .middle:
            return .yellow
        case .empty:
            return .red
        case .unknown:
            return .gray
        }
    }
}

struct ShopList_Previews: PreviewProvider {
    static var previews: some View {
        //        VStack {
        //            Spacer()
        //            ShopCell(model:  ShopModel(name: "Rewe", products: [
        //                ProductModel(name: "Milch", emoji: "🥛", availability: .full),
        //                ProductModel(name: "Bread", emoji: "🍞", availability: .unknown),
        //                ProductModel(name: "Toilet Paper", emoji: "🧻", availability: .empty),
        //            ]))
        //            Spacer()
        //        }
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
