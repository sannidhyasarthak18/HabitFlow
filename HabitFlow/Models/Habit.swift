
import Foundation

struct Habit: Identifiable, Codable {
    var id: UUID
    var name: String
    var icon: String
    var completedDates: [String]

    init(
        id: UUID = UUID(),
        name: String,
        icon: String = "star.fill",
        completedDates: [String] = []
    ) {
        self.id = id
        self.name = name
        self.icon = icon
        self.completedDates = completedDates
    }

    func isCompleted(on date: Date = Date()) -> Bool {
        completedDates.contains(Self.dateKey(for: date))
    }

    static func dateKey(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}
