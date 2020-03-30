import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import 'nrproperty.dart';
import 'category.dart';
import 'package:http/http.dart';
//import 'models/media.dart';
//import 'models/post.dart';
//import 'models/users.dart';

final String urWebsiteUrl = "https://nasser-real.com";
final String mainApiUrl = "$urWebsiteUrl/wp-json";


WordPressClient wpData = new WordPressClient(_baseUrl, http.Client());
final String _baseUrl = mainApiUrl;

// TODO: Cache into local DB
// var dbHelper = DatabaseHelper();

int perPageInt = 10;

List<NRProperty> cachedPosts;
int dbCount;
bool netConnection = false;

List<int> postsIDs = List();
List<int> cachedPostsIDs = List();


Future<List<NRProperty>> getPosts() async {
  posts = await wpData.listProps(
      perPage: perPageInt,
      injectObjects: true).then(_);
  return posts ;
}

Future<List<NRProperty>> posts = getPosts();


typedef void APIErrorHandler(String endpoint, int statusCode, String response);

class WordPressClient {
  final Logger _logger = new Logger();
  String _baseURL;
  Client _client;
  APIErrorHandler _errorHandler;

  WordPressClient(this._baseURL, this._client, [this._errorHandler]);

  /// Get all available categories.
  ///
  /// If [hideEmpty] is false then ALL categories will be returned, and
  /// [excludeIDs] can be used to ignore specific category IDs
  Future<List<Category>> listCategories(
      {bool hideEmpty: true, List<int> excludeIDs}) async {
    // String _endpoint = '/wp/v2/categories';
    String _endpoint = '/wp/v2/property-types';

    // Build query string
    String queryString = '';
    if (hideEmpty) {
      queryString = _addParamToQueryString(queryString, 'hide_empty', 'true');
    }
    if (excludeIDs != null && excludeIDs.length > 0) {
      queryString =
          _addParamToQueryString(queryString, 'exclude', excludeIDs.join(','));
    }

    // Append the query string
    _endpoint += queryString;

    // Retrieve the data
    List<Map> categoryMaps = await _get(_endpoint);

    List<Category> categories = new List();
    categories = categoryMaps
        .map((categoryMap) => new Category.fromMap(categoryMap))
        .toList();

    return categories;
  }

  /// Get all available posts.
  ///
  /// If [categoryIDs] list is provided then only posts within those categories
  /// will be returned. Use [injectObjects] to have full objects injected
  /// rather than just the object ID (i.e. a posts's featured media). The [page]
  /// and [perPage] parameters allow for pagination.
  Future<List<NRProperty>> listProps(
      { List<int> categoryIDs,
      bool injectObjects: false,
      List<int> excludeIDs,
      int page: 1,
      int perPage: 10}) async {
    // String _endpoint = '/wp/v2/posts?_embed';
    String _endpoint = '/wp/v2/properties?_embed';

    print(_endpoint);

    // Build query string starting with pagination
    String queryString = '&per_page=$perPage';
    //queryString = _addParamToQueryString(queryString, 'page', page.toString());

    // If category IDs were sent, limit to those
    if (categoryIDs != null && categoryIDs.length > 0) {
      queryString = _addParamToQueryString(
          queryString, 'property-types', categoryIDs.join(','));
    }

    // Exclude posts?
    if (excludeIDs != null && excludeIDs.length > 0) {
      queryString =
          _addParamToQueryString(queryString, 'exclude', excludeIDs.join(','));
    }

    // Append the query string
    _endpoint += queryString;
    //_endpoint =
    // Retrieve the data
    List<Map> postMaps = await _get(_endpoint);
    print(_endpoint);

    List<NRProperty> posts = new List();
    posts = postMaps.map((postMap) => new NRProperty.fromMap(postMap)).toList();
    //print(posts.toString()) ;
    // Inject objects if requested
//    if (injectObjects) {
//      for (Post p in posts) {
//        if (p.featuredMediaID != null && p.featuredMediaID > 0) {
//          p.featuredMedia = await getMedia(p.featuredMediaID);
//        }
//      }
//    }

    return posts;
  }

  _handleError(String endpoint, int statusCode, String response) {
    // If an error handler has been provided use that, otherwise log
    if (_errorHandler != null) {
      debugPrint(statusCode.toString());
      _errorHandler(endpoint, statusCode, response);
      return;
    }

    _logger.log(
        Level.warning, "Received $statusCode from '$endpoint' => $response");
  }

  Future _get(String url) async {
    dynamic jsonObj;
    String endpoint = '$_baseURL$url';
    print("END POINT is " + endpoint);
    try {
      Response response =
          await _client.get(endpoint, headers: {"Accept": "application/json"});

      // Error handling
      if (response.statusCode != 200) {
        _handleError(url, response.statusCode, response.body);
        print("status code != 200");
        return null;
      }
      jsonObj = json.decode(response.body);
    } catch (e) {
      _logger.log(Level.error, 'Error in GET call to $endpoint', e);
    }

    if (jsonObj is List) {
      // This is needed for Dart 2 type constraints
      return jsonObj.map((item) => item as Map).toList();
    }

    return jsonObj;
  }

  String _addParamToQueryString(String queryString, String key, String value) {
    if (queryString == null) {
      queryString = '';
    }

    if (queryString.length == 0) {
      queryString += '?';
    } else {
      queryString += '&';
    }

    queryString += '$key=$value';

    return queryString;
  }
}
