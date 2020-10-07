// part of 'graphql_query_api.dart';

class IssuesApis {
  static const String issues= r'''query userInfo($login: String!, $endCursor: String) {
  user(login: $login) {
    issues(first: 10, orderBy: {field: CREATED_AT, direction: DESC}, after:$endCursor) {
        totalCount
        pageInfo{
          endCursor
          hasNextPage
        }
        nodes {
          url
          title
          createdAt
          state
          number
          viewerDidAuthor
          closed
          authorAssociation
          author {
            login
            avatarUrl
            url
          }
          repository {
            name
            url
            owner {
              login
              avatarUrl
            }
          }
          labels(first: 10) {
            nodes {
              color
              name
            }
          }
        }
      }
    }
  }
''';

 static const String repoIssues = r'''query repo($name: String!, $owner: String!, $endCursor: String) {
    repository(name: $name, owner: $owner) {
      ... on Repository {
        issues(first: 10, orderBy: {field: CREATED_AT, direction: DESC}, after: $endCursor) {
          totalCount
          pageInfo {
            endCursor
            hasNextPage
          }
          nodes {
            url
            title
            createdAt
            state
            number
            viewerDidAuthor
            closed
            authorAssociation
            author {
              login
              avatarUrl
              url
            }
            repository {
              name
              url
              owner {
                login
                avatarUrl
              }
            }
            labels(first: 10) {
              nodes {
                color
                name
              }
            }
          }
        }
      }
    }
  }
''';
}