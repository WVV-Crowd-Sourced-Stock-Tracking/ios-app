import Foundation
import Combine
import SwiftUI

struct API {
    
    static func fetchStores(at location: Location, with radius: Double) -> AnyPublisher<[Shop], Error> {
        print("start")
        let url = URL(string: "http://3.120.206.89/markets?latitude=\(location.latitude)&longitude=\(location.longitude)")!

		return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
			.decode(type: [Shop].self, decoder: JSONDecoder())
			.eraseToAnyPublisher()
	}
}
