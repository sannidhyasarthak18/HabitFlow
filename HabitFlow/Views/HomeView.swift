
import SwiftUI

struct HomeView: View {

    @ObservedObject var viewModel: HabitViewModel
    @State private var showAddHabit = false

    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())

        if hour < 12 {
            return "Good morning,"
        } else if hour < 17 {
            return "Good afternoon,"
        } else {
            return "Good evening,"
        }
    }

    var body: some View {

        NavigationStack {

            List {

                dashboardSection

                habitsSection
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(Color(.systemGroupedBackground))
            .navigationTitle("HabitFlow")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showAddHabit) {
                AddHabitView { name, icon in
                    viewModel.addHabit(name: name, icon: icon)
                }
            }
        }
        .tint(.red)
    }

    // MARK: Dashboard Section

    private var dashboardSection: some View {

        Section {

            VStack(alignment: .leading, spacing: 12) {

                Text(greeting)
                    .font(.title2)
                    .foregroundStyle(.secondary)

                Text("Let's build better habits.")
                    .font(.system(size: 28, weight: .bold))

                Text(Date.now.formatted(
                    date: .complete,
                    time: .omitted
                ))
                .font(.subheadline)
                .foregroundStyle(.secondary)

                progressCard
                    .padding(.top, 10)
            }
            .padding(.vertical, 8)
            .listRowBackground(Color.clear)
            .listRowInsets(
                EdgeInsets(top: 8, leading: 16, bottom: 12, trailing: 16)
            )
        }
    }

    // MARK: Progress Card

    private var progressCard: some View {

        HStack {

            VStack(alignment: .leading, spacing: 10) {

                Text("DAILY PROGRESS")
                    .font(.caption)
                    .fontWeight(.bold)
                    .tracking(1)

                Text("\(viewModel.completedToday) of \(viewModel.totalHabits)")
                    .font(.system(size: 30, weight: .bold))

                Text("Habits completed")
                    .font(.subheadline)

                Text("Keep your momentum going!")
                    .font(.caption)
                    .padding(.top, 5)
            }
            .foregroundStyle(.white)

            Spacer()

            ProgressRing(progress: viewModel.progress)
                .frame(width: 95, height: 95)
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                colors: [
                    Color(red: 0.12, green: 0.55, blue: 0.35),
                    Color(red: 0.08, green: 0.38, blue: 0.25)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 24))
    }

    // MARK: Habits Section

    private var habitsSection: some View {

        Section {

            if viewModel.habits.isEmpty {

                emptyHabitsView

            } else {

                ForEach(viewModel.habits) { habit in
                    habitRow(habit)
                }
                .onDelete(perform: viewModel.deleteHabit)
            }

        } header: {

            HStack {

                Text("MY HABITS")
                    .font(.caption)
                    .fontWeight(.bold)
                    .tracking(1)

                Spacer()

                Button {
                    showAddHabit = true
                } label: {
                    Label("Add Habit", systemImage: "plus")
                        .fontWeight(.semibold)
                }
            }
        }
    }

    // MARK: Empty State

    private var emptyHabitsView: some View {

        VStack(spacing: 12) {

            Image(systemName: "leaf.circle.fill")
                .font(.system(size: 45))
                .foregroundStyle(.green)

            Text("Your journey starts here")
                .font(.headline)

            Text("Add your first habit and start building a better routine.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Button {
                showAddHabit = true
            } label: {
                Label("Create a habit", systemImage: "plus")
                    .fontWeight(.semibold)
            }
            .buttonStyle(.borderedProminent)
            .tint(.green)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 25)
        .listRowBackground(Color.clear)
    }

    // MARK: Individual Habit Row

    private func habitRow(_ habit: Habit) -> some View {

        HStack(spacing: 14) {

            Image(systemName: habit.icon)
                .font(.title2)
                .foregroundStyle(.green)
                .frame(width: 45, height: 45)
                .background(Color.green.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 14))

            VStack(alignment: .leading, spacing: 4) {

                Text(habit.name)
                    .font(.system(size: 16, weight: .semibold))

                Text(
                    habit.isCompleted()
                    ? "Completed today"
                    : "Not completed yet"
                )
                .font(.caption)
                .foregroundStyle(.secondary)
            }

            Spacer()

            Button {

                withAnimation(.spring(response: 0.3)) {
                    viewModel.toggleHabit(habit)
                }

            } label: {

                Image(
                    systemName: habit.isCompleted()
                    ? "checkmark.circle.fill"
                    : "circle"
                )
                .font(.system(size: 27))
                .foregroundStyle(
                    habit.isCompleted() ? Color.green : Color.gray
                )
                .contentTransition(.symbolEffect(.replace))
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 8)
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {

            Button(role: .destructive) {
                withAnimation {
                    viewModel.deleteHabitByID(habit)
                }
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}

// MARK: Circular Progress Indicator

struct ProgressRing: View {

    let progress: Double

    var body: some View {

        ZStack {

            Circle()
                .stroke(
                    Color.white.opacity(0.2),
                    lineWidth: 9
                )

            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    Color.white,
                    style: StrokeStyle(
                        lineWidth: 9,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.spring(), value: progress)

            Text("\(Int(progress * 100))%")
                .font(.system(size: 21, weight: .bold))
                .foregroundStyle(.white)
        }
    }
}

#Preview {
    HomeView(viewModel: HabitViewModel())
}
