import SwiftUI

struct SettingsView: View {

    @ObservedObject var viewModel: HabitViewModel

    @State private var showConfirmation = false

    var body: some View {

        NavigationStack {

            Form {

                Section("Application") {

                    HStack {

                        Image(systemName: "app.fill")
                            .foregroundColor(.green)

                        Text("HabitFlow")

                        Spacer()

                        Text("Version 1.0")
                            .foregroundColor(.secondary)
                    }
                }

                Section("Manage Data") {

                    Button(role: .destructive) {

                        showConfirmation = true

                    } label: {

                        Label(
                            "Reset Today's Progress",
                            systemImage: "arrow.counterclockwise"
                        )
                    }
                }

                Section("About") {

                    Text("HabitFlow helps you build better habits and maintain consistency every day.")
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Settings")
            .confirmationDialog(
                "Reset today's progress?",
                isPresented: $showConfirmation,
                titleVisibility: .visible
            ) {

                Button("Reset Progress", role: .destructive) {
                    viewModel.resetToday()
                }

                Button("Cancel", role: .cancel) {}
            } message: {

                Text("This will unmark all habits completed today.")
            }
        }
    }
}
