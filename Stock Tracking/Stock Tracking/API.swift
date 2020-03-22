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
        let url = URL(string: "https://wvvcrowdmarket.herokuapp.com/ws/rest/market/scrape")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ShopRequest(gps_length: location.longitude, gps_width: location.latitude, radius: radius)
        request.httpBody = try! JSONEncoder.standard.encode(body)
        print(String.init(data: request.httpBody!, encoding: .utf8)!)

		return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: ShopResponse.self, decoder: JSONDecoder.standard)
            .map(\.supermarket)
			.eraseToAnyPublisher()
	}
    
    static func sendUpdate(for products: [ProductModel], in shop: Shop) -> AnyPublisher<(), Swift.Error> {
        
        let updates: [ProductUpdate] = products.compactMap { product in
            if let availability = product.selectedAvailability {
                return ProductUpdate(marketId: shop.id,
                                     productId: product.id,
                                     quantity: availability.quantity)
            }
            return nil
        }
        
        return Publishers.Sequence<[AnyPublisher<(), Swift.Error>], Swift.Error>(sequence: updates.map { self.sendUpdate($0) })
            .flatMap { $0 }.collect().reduce(()) { _, _ in () }.eraseToAnyPublisher()
    }
    
    static func sendUpdate(_ update: ProductUpdate) -> AnyPublisher<(), Swift.Error> {
        let url = URL(string: "https://wvvcrowdmarket.herokuapp.com/ws/rest/market/transmit")!

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder.standard.encode(update)
        print(String.init(data: request.httpBody!, encoding: .utf8)!)
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { String.init(data: $0.data, encoding: .utf8)! }
            .print()
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
