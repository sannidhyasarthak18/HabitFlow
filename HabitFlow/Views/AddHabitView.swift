import SwiftUI

struct AddHabitView: View {

    @Environment(\.dismiss) private var dismiss

    @State private var habitName = ""
    @State private var selectedIcon = "book.fill"

    var onSave: (String, String) -> Void

    let icons = [
        "book.fill",
        "figure.run",
        "laptopcomputer",
        "drop.fill",
        "heart.fill",
        "brain.head.profile",
        "dumbbell.fill",
        "moon.fill"
    ]

    var body: some View {

        NavigationStack {

            Form {

                Section("Habit Details") {

                    TextField(
                        "Enter habit name",
                        text: $habitName
                    )
                }

                Section("Choose an Icon") {

                    LazyVGrid(
                        columns: [
                            GridItem(.adaptive(minimum: 55))
                        ],
                        spacing: 20
                    ) {

                        ForEach(icons, id: \.self) { icon in

                            Button {

                                selectedIcon = icon

                            } label: {

                                Image(systemName: icon)
                                    .font(.title2)
                                    .frame(width: 45, height: 45)
                                    .background(
                                        selectedIcon == icon
                                        ? Color.green.opacity(0.2)
                                        : Color.gray.opacity(0.1)
                                    )
                                    .cornerRadius(10)
                                    .foregroundColor(.green)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
            .navigationTitle("New Habit")
            .navigationBarTitleDisplayMode(.inline)

            .toolbar {

                ToolbarItem(placement: .cancellationAction) {

                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {

                    Button("Save") {

                        let name = habitName.trimmingCharacters(
                            in: .whitespacesAndNewlines
                        )

                        guard !name.isEmpty else {
                            return
                        }

                        onSave(name, selectedIcon)
                        dismiss()
                    }
                    .disabled(
                        habitName.trimmingCharacters(
                            in: .whitespacesAndNewlines
                        ).isEmpty
                    )
                }
            }
        }
    }
}
