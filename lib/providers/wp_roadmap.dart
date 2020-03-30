//
///// Get all available media.
/////
///// If [mediaIDs] list is provided then only these specific media items
///// will be returned. The [page] and [perPage] parameters allow for pagination.
//Future<List<Media>> listMedia(
//    {List<int> includeIDs, int page: 1, perPage: 10}) async {
//  String _endpoint = '/wp/v2/media';
//
//  // Build query string starting with pagination
//  String queryString = '';
//  queryString = _addParamToQueryString(queryString, 'page', page.toString());
//  queryString =
//      _addParamToQueryString(queryString, 'per_page', perPage.toString());
//
//  // Requesting specific items
//  if (includeIDs != null && includeIDs.length > 0) {
//    queryString =
//        _addParamToQueryString(queryString, 'include', includeIDs.join(','));
//  }
//
//  // Append the query string
//  _endpoint += queryString;
//
//  // Retrieve the data
//  List<Map> mediaMaps = await _get(_endpoint);
//
//  List<Media> media = new List();
//  media = mediaMaps.map((mediaMap) => new Media.fromMap(mediaMap)).toList();
//
//  return media;
//}
//
////****** */
///// Get all available user.
/////
///// If [userIDs] list is provided then only these specific user items
///// will be returned. The [page] and [perPage] parameters allow for pagination.
///* Future<List<User>> listUser() async {
//    String _endpoint = '/wp/v2/users';
//
//    List<Map> userMaps = await _get(_endpoint);
//
//    List<User> user = new List();
//    user = userMaps.map((userMap) => new User.fromMap(userMap)).toList();
//
//    return user;
//  }
//  */
//Future<List<User>> listUser(
//    {List<int> includeIDs, int page: 1, int perPage: 10}) async {
//  String _endpoint = '/wp/v2/users';
//
//  // // Build query string starting with pagination
//  // String queryString = '';
//  // queryString = _addParamToQueryString(queryString, 'page', page.toString());
//  // queryString =
//  //     _addParamToQueryString(queryString, 'per_page', perPage.toString());
//
//  // // Requesting specific items
//  // if (includeIDs != null && includeIDs.length > 0) {
//  //   queryString =
//  //       _addParamToQueryString(queryString, 'include', includeIDs.join(','));
//  // }
//
//  // Append the query string
//  // _endpoint += queryString;
//
//  // Retrieve the data
//  List<Map> userMaps = await _get(_endpoint).then((onValue) {
//    debugPrint('the userMpas'+ onValue.toString());
//  }).catchError((e)=> debugPrint(e));
//
//  var users = new List();
//
//  for (int i = 0; i < userMaps.length; i++) {
//    users.add(User.fromMap(userMaps[i]));
//  }
//
//  return users;
//}
//
///// Get post
//Future<Post> getPost(int postID, {bool injectObjects: true}) async {
//  if (postID == null) {
//    return null;
//  }
//
//  String _endpoint = '/wp/v2/posts/$postID?_embed';
//
//  // Retrieve the data
//  Map postMap = await _get(_endpoint);
//  if (postMap == null) {
//    return null;
//  }
//
//  Post p = new Post.fromMap(postMap);
//
//  // Inject objects if requested
////    if (injectObjects) {
////      if (p.featuredMediaID != null && p.featuredMediaID > 0) {
////        p.featuredMedia = await getMedia(p.featuredMediaID);
////      }
////    }
//
//  return p;
//}
//
///// Get media item
//Future<Media> getMedia(int mediaID) async {
//  if (mediaID == null) {
//    return null;
//  }
//
//  String _endpoint = '/wp/v2/media/$mediaID';
//
//  // Retrieve the data
//  Map mediaMap = await _get(_endpoint);
//  if (mediaMap == null) {
//    return null;
//  }
//
//  return new Media.fromMap(mediaMap);
//}
//
///// Get media item
//Future<Media> getAttMedia(int mediaID) async {
//  if (mediaID == null) {
//    return null;
//  }
//
//  String _endpoint = '/wp/v2/media/$mediaID';
//
//  // Retrieve the data
//  Map mediaMap = await _get(_endpoint);
//  if (mediaMap == null) {
//    return null;
//  }
//
//  return new Media.fromMap(mediaMap);
//}
//
///// Get User item
//Future<User> getUser(int userID) async {
//  if (userID == null) {
//    return null;
//  }
//
//  String _endpoint = '/wp/v2/users/$userID';
//
//  // Retrieve the user data
//  Map userMap = await _get(_endpoint);
//  if (userMap == null) {
//    return null;
//  }
//
//  return new User.fromMap(userMap);
//}
