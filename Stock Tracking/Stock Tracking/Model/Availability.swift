import SwiftUI

enum Availability {
    case full, mid, empty, unknown
    
    static func from(quantity: Int) -> Availability {
        switch quantity {
        case 0..<33:
            return .empty
        case 33..<66:
            return .mid
        case 66...100:
            return .full
        default:
            return .unknown
        }
    }
    
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
    
    var text: LocalizedStringKey {
        switch self {
        case .full:
            return .fullTitle
        case .mid:
            return .midTitle
        case .empty:
            return .emptyTitle
        case .unknown:
            return .unknownTitle
        }
    }
    
    var shortText: LocalizedStringKey {
        switch self {
        case .full:
            return .fullShort
        case .mid:
            return .midShort
        case .empty:
            return .emptyShort
        case .unknown:
            return .unknownShort
        }
    }
    
    var quantity: Int {
        switch self {
        case .full:
            return 100
        case .mid:
            return 50
        case .empty:
            return 0
        case .unknown:
            return 0
        }
    }
}
