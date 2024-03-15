# A Sample Application for `ApolloPagination`, in SwiftUI

This is a sample application that demonstrates how to use the `ApolloPagination` library in a SwiftUI application.

The two main components of the sample are:

1. Setting up and using the `AsyncGraphQLQueryPager` within `LaunchListViewModel` to fetch and display a paginated list of launches.
2. Sending signals to fetch the next page within `LaunchListView` when the user scrolls to the bottom of the list.

The sample application is built around the `AsyncGraphQLQueryPager`, as opposed to the `GraphQLQueryPager`, because SwiftUI has a built-in mechanism for entering an asynchronous context.

## Known Issues

`AsyncGraphQLQueryPager`:

- At present, there is potential for a race condition depending on the way the initial fetch is triggered. See [this comment](https://github.com/apollographql/apollo-ios-dev/pull/299#discussion_r1526411532) for more information.

`GraphQLQueryPager`:

- The `GraphQLQueryPager` does not have callbacks available for when the initial `fetch` (or `refetch`) complete, but [should in the next release](https://github.com/apollographql/apollo-ios-dev/pull/292).

Usage with `SwiftUI`:

- Secondary Triggers
  - The `task` which is used to fetch next pages must have a secondary trigger, as the standard `task` is not sufficient for triggering the next page fetch. This is because the `task` is only triggered when the view will appear, but there are situations where a fetch is disallowed. For example, if the user triggers a pull-to-refresh action, and very quickly scrolls to the bottom of the page prior to the completion of the refresh, the pager will not fetch the next page, as it will lead to inconsistent state. Thus, the `task` must be triggerd by a secondary action, after the completion of the `refresh` action. This is demonstrated in the `LaunchListView` by using the `loadState` as a secondary trigger.
  - The `task` modifier will cancel any operation when the view will disappear. This is not ideal for a pager, as the user may want to continue fetching pages even when the view is not visible. This can be worked around by using a custom `task` modifier, or by using a combination of `onAppear` and `onChange`.
  - The need for a secondary trigger may cause the `loadNextPage` to be called multiple times. This is not an issue, as the pager will only fetch the next page if it is not already fetching a page – but the pager will throw a `loadInProgress` error on invocation of the `loadNextPage` method if it is already fetching a page. `PaginationError`s are not fatal errors, and are largely to inform the developer of a misuse. They can be ignored, or handled as necessary.
