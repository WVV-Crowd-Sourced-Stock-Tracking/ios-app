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
}

extension JSONDecoder {
    static var standard: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }
}
