import SwiftUI

enum Availability {
    case full, mid, empty, unknown
    
    var color: Color {
        switch self {
        case .full:
            return .full
        case .mid:
            return .mid
        case .empty:
            return .empty
        case .unknown:
            return .unknown
        }
    }
    
    var uiColor: UIColor {
        switch self {
            case .full:
                return .full
            case .mid:
                return .mid
            case .empty:
                return .empty
            case .unknown:
                return .unknown
            }
    }
    
    var text: String {
           switch self {
           case .full:
               return "available"
           case .mid:
               return "almost sold out"
           case .empty:
               return "sold out"
           case .unknown:
               return "unknown"
           }
       }
}
