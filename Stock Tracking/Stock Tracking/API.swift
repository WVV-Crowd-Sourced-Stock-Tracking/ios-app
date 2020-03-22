import Foundation
import Combine
import SwiftUI

struct API {
    
    enum Error: LocalizedError, Identifiable {
        case noConnection
        case serverError
        case notFound
        case other(Swift.Error)
        
        var id: String {
            switch self {
            case .noConnection:
                return "no_connection"
            case .serverError:
                return "server_error"
            case .notFound:
                return "not_found"
            case .other(let error):
                return error.localizedDescription
            }
        }
        
        static func from(error: Swift.Error) -> Error {
            return .other(error)
        }
    }
    
    static func fetchStores(at location: Location, with radius: Double) -> AnyPublisher<[Shop], Swift.Error> {
        let url = URL(string: "http://3.120.206.89/markets?latitude=\(location.latitude)&longitude=\(location.longitude)&radius=\(radius)")!

		return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [Shop].self, decoder: JSONDecoder.standard)
			.eraseToAnyPublisher()
	}
    
    static func sendUpdate(for products: [ProductModel], in shop: Shop) -> AnyPublisher<(), Swift.Error> {
        let url = URL(string: "https://wvvcrowdmarket.herokuapp.com/ws/rest/market/transmit")!
        
        let updates: [ProductUpdate] = products.compactMap { product in
            if let availability = product.selectedAvailability {
                return ProductUpdate(marketId: shop.id.hashValue,
                                     productId: product.id,
                                     quantity: availability.quantity)
            }
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder.standard.encode(updates.first!)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { _ in () }
            .mapError { $0 as Swift.Error }
            .eraseToAnyPublisher()
    }
}

struct ProductUpdate: Codable {
    let marketId: Int
    let productId: Int
    let quantity: Int
}

extension JSONDecoder {
    static var standard: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}


extension JSONEncoder {
    static var standard: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return encoder
    }
}
