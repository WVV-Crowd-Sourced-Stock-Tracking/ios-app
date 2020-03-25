import SwiftUI

extension Color {
    static var full = Color("full")
    static var mid = Color("mid")
    static var empty = Color("empty")
    static var unknown = Color("unknown")
    static var accent = Color("accent")
    static var grouped = Color(UIColor.systemGroupedBackground)
}

extension UIColor {
    static var full = UIColor(named: "full")!
    static var mid = UIColor(named: "mid")!
    static var empty = UIColor(named: "empty")!
    static var unknown = UIColor(named: "unknown")!
}
