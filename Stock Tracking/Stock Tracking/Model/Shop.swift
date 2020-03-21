
struct Shop: Codable, Equatable {
    let name: String
    let latitude: Double
    let longitude: Double
    let vicinity: String
    let distance: Double
    let openNow: Bool?
}
