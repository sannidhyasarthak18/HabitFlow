import SwiftUI

@main
struct HabitFlowApp: App {

    @StateObject private var viewModel = HabitViewModel()

    var body: some Scene {

        WindowGroup {

            MainTabView(viewModel: viewModel)
        }
    }
}

struct MainTabView: View {

    @ObservedObject var viewModel: HabitViewModel

    var body: some View {

        TabView {

            HomeView(viewModel: viewModel)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            StatisticsView(viewModel: viewModel)
                .tabItem {
                    Label("Statistics", systemImage: "chart.bar.fill")
                }

            SettingsView(viewModel: viewModel)
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
    }
}
