import SwiftUI
import Combine

class HabitViewModel: ObservableObject {

    @Published var habits: [Habit] = [] {
        didSet {
            saveHabits()
        }
    }

    private let storageKey = "saved_habits"

    init() {
        loadHabits()
    }

    // MARK: Add Habit

    func addHabit(name: String, icon: String) {

        let newHabit = Habit(
            name: name,
            icon: icon
        )

        habits.append(newHabit)
    }

    // MARK: Delete Habit

    func deleteHabit(at offsets: IndexSet) {

        habits.remove(atOffsets: offsets)
    }
    // Delete individual habit
    func deleteHabitByID(_ habit: Habit) {
        habits.removeAll { existingHabit in
            existingHabit.id == habit.id
        }
    }

    // MARK: Toggle Completion

    func toggleHabit(_ habit: Habit) {

        guard let index = habits.firstIndex(
            where: { $0.id == habit.id }
        ) else {
            return
        }

        let today = Habit.dateKey(for: Date())

        if habits[index].completedDates.contains(today) {

            habits[index].completedDates.removeAll {
                $0 == today
            }

        } else {

            habits[index].completedDates.append(today)
        }
    }

    // MARK: Daily Progress

    var completedToday: Int {

        habits.filter {
            $0.isCompleted()
        }.count
    }

    var totalHabits: Int {

        habits.count
    }

    var progress: Double {

        guard !habits.isEmpty else {
            return 0
        }

        return Double(completedToday) / Double(totalHabits)
    }

    // MARK: Weekly Progress

    func weeklyProgress(for date: Date) -> Int {

        habits.filter {
            $0.isCompleted(on: date)
        }.count
    }

    // MARK: Reset Progress

    func resetToday() {

        let today = Habit.dateKey(for: Date())

        for index in habits.indices {

            habits[index].completedDates.removeAll {
                $0 == today
            }
        }
    }

    // MARK: Save Data

    private func saveHabits() {

        if let encodedData = try? JSONEncoder().encode(habits) {

            UserDefaults.standard.set(
                encodedData,
                forKey: storageKey
            )
        }
    }

    // MARK: Load Data

    private func loadHabits() {

        guard let savedData = UserDefaults.standard.data(
            forKey: storageKey
        ) else {
            return
        }

        if let decodedHabits = try? JSONDecoder().decode(
            [Habit].self,
            from: savedData
        ) {

            habits = decodedHabits
        }
    }
}
