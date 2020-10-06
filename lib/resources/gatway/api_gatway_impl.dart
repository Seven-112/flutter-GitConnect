import 'package:dio/dio.dart';
import 'package:flutter_github_connect/bloc/User/User_model.dart';
import 'package:flutter_github_connect/bloc/User/model/event_model.dart';
import 'package:flutter_github_connect/bloc/User/model/gist_model.dart';
import 'package:flutter_github_connect/bloc/issues/issues_model.dart' as issues;
import 'package:flutter_github_connect/bloc/notification/index.dart';
import 'package:flutter_github_connect/bloc/people/people_model.dart';
import 'package:flutter_github_connect/bloc/search/index.dart';
import 'package:flutter_github_connect/bloc/search/model/search_userModel.dart'
    as model;
import 'package:flutter_github_connect/helper/config.dart';
import 'package:flutter_github_connect/model/forks_model.dart';
import 'package:flutter_github_connect/model/pul_request.dart';
import 'package:flutter_github_connect/resources/dio_client.dart';
import 'package:flutter_github_connect/resources/graphql_client.dart';
import 'package:flutter_github_connect/resources/gatway/api_gatway.dart';
import 'package:flutter_github_connect/resources/service/session_service.dart';
import 'package:flutter_github_connect/bloc/people/people_model.dart' as people;
import 'package:flutter_github_connect/bloc/commit/commit_model.dart' as commit;
import 'package:flutter_github_connect/bloc/bloc/repo_response_model.dart';

class ApiGatwayImpl implements ApiGateway {
  final DioClient _dioClient;
  final SessionService _sessionService;
  ApiGatwayImpl(this._dioClient, this._sessionService);

  @override
  Future<UserModel> fetchUserProfile({String login}) async {
    try {
      var accesstoken = await _sessionService.loadSession();
      var username = login ?? await _sessionService.getUserName();
      assert(username != null);
      initClient(accesstoken);
      final result = await getUser(username);
      if (result.hasException) {
        print(result.exception.toString());
        throw result.exception;
      }

      final userMap = result.data['user'] as Map<String, dynamic>;
      final user = UserModel.fromJson(userMap);

      return user;
    } catch (error) {
      throw error;
    }
  }

  @override
  Future<List<RepositoryModel2>> fetchRepositories() async {
    try {
      var accesstoken = await _sessionService.loadSession();
      var response = await _dioClient.get(
        Config.repos,
        options: Options(
          headers: {
            'Authorization': 'token $accesstoken',
            'Accept': 'application/vnd.github.v3+json'
          },
        ),
      );
      final list = _dioClient
          .getJsonBodyList(response)
          .map((e) => RepositoryModel2.fromJson(e))
          .toList();
      return list;
    } catch (error) {
      throw error;
    }
  }

  @override
  Future<List<NotificationModel>> fetchNotificationList({int pageNo}) async {
    try {
      assert(pageNo != null, "Please provice page no to get notifications");
      var accesstoken = await _sessionService.loadSession();
      String since =
          DateTime.now().add(Duration(days: -(365 * 5))).toIso8601String();
      var response = await _dioClient.get(
        Config.notificationsList(since: since, pageNo: pageNo),
        options: Options(
          headers: {'Authorization': 'token $accesstoken'},
        ),
      );
      List<NotificationModel> list = [];
      list = _dioClient.getJsonBodyList(response).map((value) {
        return NotificationModel.fromJson(value);
      }).toList();
      print(list.length);
      return list;
    } catch (error) {
      throw error;
    }
  }

  @override
  Future<model.Search> searchQuery(
      {GithubSearchType type, String query, String endCursor}) async {
    try {
      var accesstoken = await _sessionService.loadSession();
      initClient(accesstoken);
      String queryType = type.asString();
      final result = await searchQueryAsync(query, queryType, endCursor);
      if (result.hasException) {
        print(result.exception.toString());
        throw result.exception;
      }
      // final userMap = result.data['search'] as Map<String, dynamic>;
      final user = model.Data.fromJson(result.data, type: type);

      return user.search;
    } catch (error) {
      throw error;
    }
  }

  @override
  Future<issues.Issues> fetchIssues({String login, String endCursor}) async {
    try {
      var accesstoken = await _sessionService.loadSession();
      initClient(accesstoken);
      var username = login ?? await _sessionService.getUserName();
      final result = await getIssues(username, endCursor);
      if (result.hasException) {
        print(result.exception.toString());
        throw result.exception;
      }
      final issueMap = result.data['user'] as Map<String, dynamic>;
      final list = issues.Issues.fromJson(issueMap["issues"]);

      return list;
    } catch (error) {
      throw error;
    }
  }

  @override
  Future<List<EventModel>> fetchUserEvent({String login,int pageNo}) async {
    try {
      var accesstoken = await _sessionService.loadSession();
      var username =login ?? await _sessionService.getUserName();
      assert(username != null);
      var response = await _dioClient.get(
        Config.getEvent(userName:username,pageNo:pageNo),
        options: Options(
          headers: {
            'Authorization': 'token $accesstoken',
            'Accept': 'application/vnd.github.v3+json'
          },
        ),
      );
      List<EventModel> list = [];
      list = _dioClient.getJsonBodyList(response).map((value) {
        return EventModel.fromJson(value);
      }).toList();
      print(list.length);
      return list;
    } catch (error) {
      throw error;
    }
  }

  @override
  Future<UserPullRequests> fetchPullRequest({String login, endCursor}) async {
    try {
      print("fetchPullRequest Init");
      var accesstoken = await _sessionService.loadSession();
      initClient(accesstoken);
      print("fetchPullRequest");
      var username = login ?? await _sessionService.getUserName();
      assert(login != null);
      final result = await getUserPullRequest(username, endCursor);
      if (result.hasException) {
        print(result.exception.toString());
        throw result.exception;
      }
      print(result.data);
      final list =
          UserPullRequestResponse.fromJson(result.data).user.pullRequests;

      return list;
    } catch (error) {
      throw error;
    }
  }

  @override
  Future<Gists> fetchGistList({String login, String endCursor}) async {
    try {
      var accesstoken = await _sessionService.loadSession();
      initClient(accesstoken);
      var username = login ?? await _sessionService.getUserName();
      assert(username != null);
      final result = await getUserGistList(username, endCursor);
      if (result.hasException) {
        print(result.exception.toString());
        throw result.exception;
      }
      print(result.data);
      final list = GistResponse.fromJson(result.data).user.gists;
      return list;
    } catch (error) {
      throw error;
    }
  }

  @override
  Future<people.FollowModel> fetchFollowUserList(
      {String login, PeopleType type, String endCursor}) async {
    try {
      assert(login != null);
      var accesstoken = await _sessionService.loadSession();
      initClient(accesstoken);
      print("Get ${type.asString()} list");
      final result =
          await getFollowerList(login, endCursor: endCursor, type: type);
      if (result.hasException) {
        print(result.exception.toString());
        throw result.exception;
      }
      print(result.data);
      final list = people.User.fromJson(result.data["user"]).followModel;

      return list;
    } catch (error) {
      throw error;
    }
  }

  @override
  Future<RepositoryModel> fetchRepository({String name, String owner}) async {
    try {
      var accesstoken = await _sessionService.loadSession();
      initClient(accesstoken);
      final result = await getRepositoryDetail(name: name, owner: owner);
      if (result.hasException) {
        print(result.exception.toString());
        throw result.exception;
      }

      final map = result.data['repository'] as Map<String, dynamic>;
      final repository = RepositoryModel.fromJson(map);

      return repository;
    } catch (error) {
      throw error;
    }
  }

  @override
  Future<String> fetchReadme({String name, String owner}) async {
    try {
      var accesstoken = await _sessionService.loadSession();
      var login = await _sessionService.getUserName();
      assert(login != null);
      var response = await _dioClient.get(
        null,
        completeUrl: Config.getReadme(name: name, owner: owner),
        options: Options(
          headers: {
            'Authorization': 'token $accesstoken',
            'Accept': 'application/vnd.github.v3+json'
          },
        ),
      );

      final String text = response.data as String;
      return text;
    } catch (error) {
      throw error;
    }
  }

  @override
  Future<UserModel> fetchNextRepositorries(
      {String login, String endCursor}) async {
    assert(endCursor != null && login != null);
    try {
      var accesstoken = await _sessionService.loadSession();
      initClient(accesstoken);
      final result =
          await getNextRepositoriesList(login: login, endCursor: endCursor);
      if (result.hasException) {
        print(result.exception.toString());
        throw result.exception;
      }
      final userMap = result.data['user'] as Map<String, dynamic>;
      final user = UserModel.fromJson(userMap);

      return user;
    } catch (error) {
      throw error;
    }
  }

  @override
  Future<GistDetail> fetchGistDetail(String id)async {
    try {
      var accesstoken = await _sessionService.loadSession();
      var response = await _dioClient.get(
        Config.getGistDetail(id),
        options: Options(
          headers: {
            'Authorization': 'token $accesstoken',
            'Accept': 'application/vnd.github.v3+json'
          },
        ),
      );

      final map  = _dioClient.getJsonBody(response);
      final GistDetail model = GistDetail.fromJson(map);
      return model;
    } catch (error) {
      throw error;
    }
  }

  @override
  Future<UserPullRequests> fetchRepoPullRequest({String owner, String endCursor, String name})async {
    try {
      assert(name != null,"Repository name is required");
      assert(owner != null);
      print("fetchRepoPullRequest Init");
      var accesstoken = await _sessionService.loadSession();
      initClient(accesstoken);
      print("fetchPullRequest");
      
      assert(owner != null);
      final result = await getRepoPullRequest(owner,name,endCursor);
      if (result.hasException) {
        print(result.exception.toString());
        throw result.exception;
      }
      print(result.data);
      final list =
          UserPullRequests.fromJson(result.data["repository"]["pullRequests"]);

      return list;
    } catch (error) {
      throw error;
    }
  }

  @override
  Future<issues.Issues> fetchRepoIssues({String owner, String endCursor, String name}) async{
   try {
      assert(name != null,"Repository name is required");
      assert(owner != null);
      var accesstoken = await _sessionService.loadSession();
      initClient(accesstoken);
      
      final result = await getRepoIssues(owner,name,endCursor);
      if (result.hasException) {
        print(result.exception.toString());
        throw result.exception;
      }
      print(result.data);
      final list = issues.Issues.fromJson(result.data["repository"]["issues"]);

      return list;
    } catch (error) {
      throw error;
    }
  }

  @override
  Future<Watchers> fetchRepoWatchers({String name, String owner, String endCursor}) async{
    try {
      assert(name != null,"Repository name is required");
      assert(owner != null);
      var accesstoken = await _sessionService.loadSession();
      initClient(accesstoken);
      
      final result = await getRepoWatchers(owner,name,endCursor);
      if (result.hasException) {
        print(result.exception.toString());
        throw result.exception;
      }
      print(result.data);
      final watchers = Watchers.fromJson(result.data["repository"]["watchers"]);

      return watchers;
    } catch (error) {
      throw error;
    }
  }

  @override
  Future<Stargazers> fetchRepoStargazers({String owner, String endCursor, String name}) async{
    try {
      assert(name != null,"Repository name is required");
      assert(owner != null);
      var accesstoken = await _sessionService.loadSession();
      initClient(accesstoken);
      
      final result = await getRepoStargazres(owner,name,endCursor);
      if (result.hasException) {
        print(result.exception.toString());
        throw result.exception;
      }
      print(result.data);
      final stargazers = Stargazers.fromJson(result.data["repository"]["stargazers"]);

      return stargazers;
    } catch (error) {
      throw error;
    }
  }

  @override
  Future<ForksModel> fetchRepoForks({String owner, String endCursor, String name}) async{
     try {
      assert(name != null,"Repository name is required");
      assert(owner != null);
      var accesstoken = await _sessionService.loadSession();
      initClient(accesstoken);
      
      final result = await getRepoForks(owner,name,endCursor);
      if (result.hasException) {
        print(result.exception.toString());
        throw result.exception;
      }
      print(result.data);
      final stargazers = ForksModel.fromJson(result.data["repository"]["forks"]);

      return stargazers;
    } catch (error) {
      throw error;
    }
  }

  @override
  Future<commit.History> fetchCommits({String name, String owner, String endCursor}) async{
   try {
      assert(name != null,"Repository name is required");
      assert(owner != null);
      var accesstoken = await _sessionService.loadSession();
      initClient(accesstoken);
      
      final result = await getRepoCommits(owner,name,endCursor);
      if (result.hasException) {
        print(result.exception.toString());
        throw result.exception;
      }
      print(result.data);
      final map = result.data["repository"]["ref"]["target"] as Map<String, dynamic>;
      final commits = commit.History.fromJson(map["history"]);
      return commits;
    } catch (error) {
      throw error;
    }
  }
}
