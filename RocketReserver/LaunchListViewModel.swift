import Apollo
import ApolloPagination
import RocketReserverAPI
import SwiftUI

private let pageSize = 10

extension LaunchListQuery.Data.Launches.Launch: Identifiable { }

@Observable
@MainActor
final class LaunchListViewModel: ObservableObject {
  enum LoadState {
    case initial, refresh, tail, idle
  }

  var loadState: LoadState = .idle
  var canLoadNext: Bool { get async { await pager?.canLoadNext ?? false } }
  var launches: [LaunchListQuery.Data.Launches.Launch] = []
  var error: Error?
  var showError: Bool {
    get { error != nil }
    set { error = nil }
  }
  private var pager: AsyncGraphQLQueryPager<[LaunchListQuery.Data.Launches.Launch]>?

  init() {
    let initialQuery = LaunchListQuery(pageSize: .some(pageSize), cursor: .none)
    Task {
      self.pager = await AsyncGraphQLQueryPager(
        client: Network.shared.apollo,
        initialQuery: initialQuery,
        extractPageInfo: { data in
          CursorBasedPagination.Forward(hasNext: data.launches.hasMore, endCursor: data.launches.cursor)
        },
        pageResolver: { page, direction in
          LaunchListQuery(pageSize: .some(pageSize), cursor: page.endCursor ?? .none)
        },
        transform: { data in
          data.launches.launches.compactMap { $0 }
        }
      )
      pager?.subscribe { result in
        switch result {
        case .success((let launches, _)):
          self.launches = launches
        case .failure(let error):
          // These are network errors, and worth showing to the user.
          self.error = error
        }
      }
      await fetch() 
    }
  }

  func refresh() async {
    await execute {
      loadState = .refresh
      await pager?.refetch()
    }
  }

  func fetch() async {
    await execute {
      loadState = .initial
      await pager?.fetch()
    }
  }

  func loadNextPage() async {
    await execute {
      guard await canLoadNext, loadState != .tail else { return }
      loadState = .tail
      try? await pager?.loadNext()
    }
  }

  @MainActor
  private func execute(operation: () async -> Void) async {
    do {
      try Task.checkCancellation()
      await operation()
      loadState = .idle
    } catch {
      loadState = .idle
    }
  }
}
