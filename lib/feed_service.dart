import 'package:http/http.dart' as http;
import 'package:webfeed/webfeed.dart';

class RssFeedService {
  static Future<RssFeed> fetchFeed(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return RssFeed.parse(response.body);
    } else {
      throw Exception('Failed to load RSS feed');
    }
  }
}
