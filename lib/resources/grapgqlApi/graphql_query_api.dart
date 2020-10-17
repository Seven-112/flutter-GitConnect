import 'package:flutter_github_connect/resources/grapgqlApi/gist_api.dart';
import 'package:flutter_github_connect/resources/grapgqlApi/issues_api.dart';
import 'package:flutter_github_connect/resources/grapgqlApi/people_api.dart';
import 'package:flutter_github_connect/resources/grapgqlApi/pull_request_api.dart';
import 'package:flutter_github_connect/resources/grapgqlApi/repo_api.dart';

class Apis {
  static String get issues => IssuesApis.issues;
  static String get repoIssues => IssuesApis.repoIssues;
  static String get pullRequests => PullRequestQraphQl.pullRequests;
  static String get repoPullRequests => PullRequestQraphQl.repoPullRequest;
  static String get gist => GistGraphQl.gist;
  static String get followers => PeopleApi.followers;
  static String get following => PeopleApi.following;
  static String get repoWatchers => RepoApi.watchers;
  static String get repositoryDetail => RepoApi.repositoryDetail;
  static String get repository => RepoApi.repository;
  static String get stargazers => RepoApi.startgazers;
  static String get forks => RepoApi.forks;
  static String get commits => RepoApi.commits;
  static const String user = r'''
   query userInfo($login: String!) {
    user(login: $login) {
      name
      avatarUrl
      company
      location
      bioHTML
      company
      companyHTML
      createdAt
      databaseId
      id
      isEmployee
      isViewer
      isBountyHunter
      isCampusExpert
      isDeveloperProgramMember
      isEmployee
      isHireable
      isSiteAdmin
      isViewer
      location
      login
      #organizationVerifiedDomainEmails(login: $login)
      pinnedItemsRemaining
      projectsResourcePath
      projectsUrl
      resourcePath
      twitterUsername
      updatedAt
      url
      viewerCanChangePinnedItems
      viewerCanCreateProjects
      viewerCanFollow
      viewerIsFollowing
      websiteUrl
      anyPinnableItems
      bio
      status {
        emoji
        message
      }
      gists {
        totalCount
      }
      followers {
        totalCount
      }
      following {
        totalCount
      }
      topRepositories(orderBy: {field: CREATED_AT, direction: ASC}, first: 10) {
        totalCount
        totalDiskUsage
        nodes {
          id
          name
          isFork
          isPrivate
          url
          forkCount
          stargazers {
            totalCount
          }
          owner {
            __typename
            ... on User {
              name
              avatarUrl
              login
            }
          }
          languages(first: 30, orderBy: {field: SIZE, direction: DESC}) {
            totalCount
            nodes {
              color
              id
              name
            }
            totalSize
          }
        }
      }
      repositoriesContributedTo(first: 100, contributionTypes: [COMMIT, ISSUE, PULL_REQUEST, REPOSITORY]) {
        totalCount
      }
      pullRequests(first: 100) {
        totalCount
      }
      issues(first: 100) {
        totalCount
      }
      repositories(first: 10, orderBy: {field: CREATED_AT, direction: DESC}) {
        pageInfo {
          endCursor
          hasNextPage
        }
        totalCount
        totalDiskUsage
        nodes {
          name
          description
          owner {
            avatarUrl
            login
          }
          languages(first: 10, orderBy: {field: SIZE, direction: DESC}) {
            totalSize
            nodes {
              name
              color
            }
          }
          stargazers {
            totalCount
          }
        }
      }
      itemShowcase {
        items(first: 10) {
          nodes {
            ... on Repository {
              id
              name
              url
              owner {
                avatarUrl
                login
              }
              stargazers {
                totalCount
              }
              languages(first: 30, orderBy: {field: SIZE, direction: DESC}) {
                totalCount
                nodes {
                  color
                  id
                  name
                }
                totalSize
              }
            }
          }
        }
        hasPinnedItems
      }
    }
  }
''';

  static String search =
        r'''query userInfo($query: String!, $type: SearchType!, $endCursor: String) {
    search(query: $query, first: 30, type: $type, after: $endCursor) {
      pageInfo {
        endCursor
      }
      userCount
      nodes {
        ... on User {
          __typename
          id
          name
          avatarUrl
          bio
          login
        }
        ... on Issue {
          __typename
          url
          title
          number
          closed
          closedAt
          createdAt
          repository {
            name
            url
            owner {
              login
            }
          }
          labels(first: 10) {
            __typename
            nodes {
              color
              name
            }
          }
          author {
            login
            avatarUrl
            url
          }
          state
        }
        ... on Repository {
          __typename
          id
          name
          url
          description
          stargazers {
            totalCount
          }
          languages(first: 10, orderBy: {field: SIZE, direction: DESC}) {
            totalSize
            nodes {
              name
              color
            }
          }
          owner {
            avatarUrl
            login
            url
          }
        }
        ... on PullRequest {
          __typename
          url
          number
          closed
          title
          author {
            login
            avatarUrl
            url
          }
          repository {
            nameWithOwner
            url
          }
          state
          closedAt
          createdAt
          deletions
          additions
          files {
            totalCount
          }
        }
      }
    }
  }
''';

  static const String userName = r'''query  {
         viewer {
             login
         }
     }''';
}
