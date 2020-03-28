
struct ShopResponse: Codable, Equatable {
    let result: String
    let supermarket: [Shop]
}

struct ShopRequest: Codable, Equatable {
    let longitude: Double
    let latitude: Double
    let radius: Double
}

struct Shop: Codable, Equatable {
    let marketId: Int
    let marketName: String
    let latitude: String
    let longitude: String
    let street: String
    let distance: String
    let open: Bool?
    let products: [Product]
}

struct Product: Codable, Equatable {
    let productId: Int
    let productName: String
    let availability: Int?
    let emoji: String
}
