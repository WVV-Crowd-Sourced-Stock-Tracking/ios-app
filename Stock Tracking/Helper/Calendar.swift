import Foundation


extension Calendar {
    static var todayId: Int {
        var cal = Calendar(identifier: .gregorian)
        cal.locale = Locale(identifier: "en-US")
        return cal.component(.weekday, from: Date()) - 1
    }
}

extension DateFormatter {
    static func date(from time: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm"
        return formatter.date(from: time)!
    }
}
