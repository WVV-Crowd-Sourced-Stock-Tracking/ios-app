import Foundation
import Combine
import SwiftUI

struct API {
    
    enum Error: LocalizedError, Identifiable {
        case noConnection
        case serverError
        case notFound
        case location(Swift.Error)
        case other(Swift.Error)
        
        var id: String {
            switch self {
            case .noConnection:
                return "no_connection"
            case .serverError:
                return "server_error"
            case .notFound:
                return "not_found"
            case .location(_):
                return "Unable to determine location."
            case .other(let error):
                return error.localizedDescription
            }
        }
        
        var localizedDescription: String {
            switch self {
            case .noConnection:
                return "no_connection"
            case .serverError:
                return "server_error"
            case .notFound:
                return "not_found"
            case .location(_):
                return "Unable to determine location."
            case .other(let error):
                return "\(error)"
            }
        }
        
        static func from(error: Swift.Error) -> Error {
            return .other(error)
        }
    }
    
    static func fetchStores<Root>(at location: Location,
                                  with radius: Double,
                                  isLoading: ReferenceWritableKeyPath<Root, Bool>,
                                  on root: Root) -> AnyPublisher<[Shop], Swift.Error> {
        let url = URL(string: "https://wvv2.herokuapp.com/ws/rest/market/scrape")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ShopRequest(longitude: location.longitude, latitude: location.latitude, radius: radius)
        request.httpBody = try! JSONEncoder.standard.encode(body)
        print(String(data: request.httpBody!, encoding: .utf8)!)
        root[keyPath: isLoading] = true
		return URLSession.shared.dataTaskPublisher(for: request)
            .set(isLoading, on: root, to: false)
            .map(\.data)
            .map { String(data: $0, encoding: .utf8)! }
             .print()
             .map { $0.data(using: .utf8)! }
            .decode(type: ShopResponse.self, decoder: JSONDecoder.standard)
            .cache(for: "market.scrape")
            .map(\.supermarket)
            .map { $0.filter { $0.latitude != nil }}
			.eraseToAnyPublisher()
	}
    
    static func sendUpdate(for products: [ProductModel], in shop: Shop) -> AnyPublisher<(), Swift.Error> {
        
        let updates: [ProductUpdate] = products.compactMap { product in
            if let availability = product.selectedAvailability, product.sentAvaiablility != availability {
                return ProductUpdate(marketId: shop.marketId,
                                     productId: product.id,
                                     availability: availability.quantity)
            }
            return nil
        }
        
        products.forEach { $0.sendSelected() }
        
        guard !updates.isEmpty else {
            return Just(())
                .setFailureType(to: Swift.Error.self)
                .eraseToAnyPublisher()
        }
        
        let url = URL(string: "https://wvv2.herokuapp.com/ws/rest/market/transmit")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder.standard.encode(BulkUpdate(bulk: updates))
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { _ in () }
            .mapError { $0 as Swift.Error }
            .eraseToAnyPublisher()
    }
    
    static func fetchProducts() -> AnyPublisher<[Product], Swift.Error> {
        let url = URL(string: "https://wvv2.herokuapp.com/ws/rest/product/scrape")!
               var request = URLRequest(url: url)
         request.httpMethod = "POST"
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: ProductResponse.self, decoder: JSONDecoder.standard)
            .cache(for: "product.scrape")
            .map(\.product)
            .eraseToAnyPublisher()
    }
    
    static let allProducts: AnyPublisher<[Product], Swift.Error> = fetchProducts()
}

struct BulkUpdate: Codable {
    let bulk: [ProductUpdate]
}

struct ProductUpdate: Codable {
    let marketId: Int
    let productId: Int
    let availability: Int
}

struct ProductResponse: Codable {
    let result: String
    let product: [Product]
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
