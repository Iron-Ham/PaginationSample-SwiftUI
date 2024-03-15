// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class LaunchListQuery: GraphQLQuery {
  public static let operationName: String = "LaunchList"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query LaunchList($pageSize: Int, $cursor: String) { launches(pageSize: $pageSize, after: $cursor) { __typename hasMore cursor launches { __typename id site mission { __typename name missionPatch(size: SMALL) } } } }"#
    ))

  public var pageSize: GraphQLNullable<Int>
  public var cursor: GraphQLNullable<String>

  public init(
    pageSize: GraphQLNullable<Int>,
    cursor: GraphQLNullable<String>
  ) {
    self.pageSize = pageSize
    self.cursor = cursor
  }

  public var __variables: Variables? { [
    "pageSize": pageSize,
    "cursor": cursor
  ] }

  public struct Data: RocketReserverAPI.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: ApolloAPI.ParentType { RocketReserverAPI.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("launches", Launches.self, arguments: [
        "pageSize": .variable("pageSize"),
        "after": .variable("cursor")
      ]),
    ] }

    public var launches: Launches { __data["launches"] }

    /// Launches
    ///
    /// Parent Type: `LaunchConnection`
    public struct Launches: RocketReserverAPI.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: ApolloAPI.ParentType { RocketReserverAPI.Objects.LaunchConnection }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("hasMore", Bool.self),
        .field("cursor", String.self),
        .field("launches", [Launch?].self),
      ] }

      public var hasMore: Bool { __data["hasMore"] }
      public var cursor: String { __data["cursor"] }
      public var launches: [Launch?] { __data["launches"] }

      /// Launches.Launch
      ///
      /// Parent Type: `Launch`
      public struct Launch: RocketReserverAPI.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: ApolloAPI.ParentType { RocketReserverAPI.Objects.Launch }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", RocketReserverAPI.ID.self),
          .field("site", String?.self),
          .field("mission", Mission?.self),
        ] }

        public var id: RocketReserverAPI.ID { __data["id"] }
        public var site: String? { __data["site"] }
        public var mission: Mission? { __data["mission"] }

        /// Launches.Launch.Mission
        ///
        /// Parent Type: `Mission`
        public struct Mission: RocketReserverAPI.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: ApolloAPI.ParentType { RocketReserverAPI.Objects.Mission }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("name", String?.self),
            .field("missionPatch", String?.self, arguments: ["size": "SMALL"]),
          ] }

          public var name: String? { __data["name"] }
          public var missionPatch: String? { __data["missionPatch"] }
        }
      }
    }
  }
}
