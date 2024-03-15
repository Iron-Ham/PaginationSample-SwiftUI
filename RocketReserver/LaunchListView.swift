import SwiftUI

struct LaunchListView: View {
  @StateObject private var viewModel = LaunchListViewModel()

  var body: some View {
    NavigationView {
      List(viewModel.launches) { launch in
        LaunchRow(launch: launch)
          .task(id: viewModel.loadState) {
            guard launch.id == viewModel.launches.last?.id else { return }
            await viewModel.loadNextPage()
          }
          .listRowSeparator(.automatic)

        if launch.id == viewModel.launches.last?.id && viewModel.loadState == .tail {
          HStack {
            Spacer()
            ProgressView("Loading")
              .progressViewStyle(.circular)
            Spacer()
          }.listRowSeparator(.hidden)
        }
      }
      .refreshable {
        await viewModel.refresh()
      }
      .alert(viewModel.error?.localizedDescription ?? "", isPresented: $viewModel.showError, actions: {})
      .navigationTitle("Rocket Launches")
    }
  }
}

#Preview {
  LaunchListView()
}
