
struct ShopResponse: Codable, Equatable {
    let result: String
    let supermarket: [Shop]
}

struct ShopRequest: Codable, Equatable {
    let gps_length: Double
    let gps_width: Double
    let radius: Double
}
struct Shop: Codable, Equatable {
    let id: Int
    let name: String
    let lat: String
    let lng: String
    let street: String
    let distance: String
    let open: Bool?
    let products: [Product]
}

struct Product: Codable, Equatable {
    let id: Int
    let name: String
    let availability: Int
}
