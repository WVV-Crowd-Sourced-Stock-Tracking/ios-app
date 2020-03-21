import SwiftUI

enum Availability {
    case full, middle, empty, unknown
    
    var color: Color {
        switch self {
        case .full:
            return .full
        case .middle:
            return .mid
        case .empty:
            return .empty
        case .unknown:
            return .unknown
        }
    }
}
