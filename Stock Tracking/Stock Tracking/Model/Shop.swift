
struct Shop: Codable, Equatable {
    let id: String
    let name: String
    let latitude: Double
    let longitude: Double
    let vicinity: String
    let distance: Double
    let openNow: Bool?
}
