import SwiftUI

struct StatisticsView: View {

    @ObservedObject var viewModel: HabitViewModel

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(alignment: .leading, spacing: 25) {

                    Text("Your Performance")
                        .font(.title2)
                        .fontWeight(.bold)

                    // Summary Cards

                    HStack(spacing: 12) {

                        statCard(
                            title: "Total Habits",
                            value: "\(viewModel.totalHabits)",
                            icon: "list.bullet"
                        )

                        statCard(
                            title: "Completed",
                            value: "\(viewModel.completedToday)",
                            icon: "checkmark.circle.fill"
                        )
                    }

                    // Daily Progress

                    VStack(alignment: .leading, spacing: 12) {

                        Text("Daily Completion")
                            .font(.headline)

                        ProgressView(value: viewModel.progress)
                            .tint(.green)

                        Text("\(Int(viewModel.progress * 100))% completed today")
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(15)

                    // Weekly Progress

                    VStack(alignment: .leading, spacing: 20) {

                        Text("Last 7 Days")
                            .font(.headline)

                        HStack(alignment: .bottom, spacing: 12) {

                            ForEach(-6...0, id: \.self) { offset in

                                let date = Calendar.current.date(
                                    byAdding: .day,
                                    value: offset,
                                    to: Date()
                                ) ?? Date()

                                let completed = viewModel.weeklyProgress(
                                    for: date
                                )

                                let ratio = viewModel.totalHabits == 0
                                    ? 0.0
                                    : Double(completed) /
                                      Double(viewModel.totalHabits)

                                VStack {

                                    Text("\(completed)")
                                        .font(.caption)

                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(Color.green)
                                        .frame(
                                            height: max(
                                                5,
                                                CGFloat(ratio) * 120
                                            )
                                        )

                                    Text(date.formatted(
                                        .dateTime.weekday(.narrow)
                                    ))
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }
                        .frame(height: 165, alignment: .bottom)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(15)
                }
                .padding()
            }
            .navigationTitle("Statistics")
        }
    }

    // Reusable Statistics Card

    func statCard(
        title: String,
        value: String,
        icon: String
    ) -> some View {

        VStack(alignment: .leading, spacing: 10) {

            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.green)

            Text(value)
                .font(.largeTitle)
                .fontWeight(.bold)

            Text(title)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(15)
    }
}
