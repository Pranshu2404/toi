import 'package:flutter/material.dart';
import 'package:toi/feed_service.dart';
import 'package:webfeed/webfeed.dart';
import 'package:intl/intl.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart'; // For iOS/macOS
import 'package:webview_flutter_android/webview_flutter_android.dart'; // For Android
import 'dart:io';

class RssFeedScreen extends StatefulWidget {
  final List<String> rssUrls;

  const RssFeedScreen({
    super.key,
    required this.rssUrls,
  });

  @override
  _RssFeedScreenState createState() => _RssFeedScreenState();
}

class _RssFeedScreenState extends State<RssFeedScreen> {
  List<RssItem> _items = [];
  bool _isLoading = true;
  String _selectedSortOption = 'All';
  DateTime? _selectedDate;
  String _searchKeyword = '';

  @override
  void initState() {
    super.initState();
    _loadFeeds();
  }

  @override
  void dispose() {
    // Cancel any ongoing operations or listeners here
    super.dispose();
  }

  Future<void> _loadFeeds() async {
    try {
      final items = await fetchAllFeeds(widget.rssUrls);

      if (mounted) {
        setState(() {
          _items = items;
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error loading feeds: $e");
    }
  }

  void _sortFeeds(String option) {
    setState(() {
      _selectedSortOption = option;
    });
  }

  List<RssItem> _getSortedItems() {
    List<RssItem> sortedItems = _items;

    if (_selectedSortOption == 'Today') {
      sortedItems = sortedItems.where((item) {
        final pubDate = item.pubDate;
        return pubDate != null &&
            pubDate.isAfter(DateTime.now().subtract(Duration(days: 1)));
      }).toList();
    } else if (_selectedSortOption == 'This Week') {
      sortedItems = sortedItems.where((item) {
        final pubDate = item.pubDate;
        return pubDate != null &&
            pubDate.isAfter(DateTime.now().subtract(Duration(days: 7)));
      }).toList();
    } else if (_selectedSortOption == 'This Month') {
      sortedItems = sortedItems.where((item) {
        final pubDate = item.pubDate;
        return pubDate != null &&
            pubDate.isAfter(
                DateTime(DateTime.now().year, DateTime.now().month, 1));
      }).toList();
    } else if (_selectedSortOption == 'Custom Date' && _selectedDate != null) {
      sortedItems = sortedItems.where((item) {
        final pubDate = item.pubDate;
        return pubDate != null &&
            pubDate.year == _selectedDate!.year &&
            pubDate.month == _selectedDate!.month &&
            pubDate.day == _selectedDate!.day;
      }).toList();
    }

    if (_searchKeyword.isNotEmpty) {
      sortedItems = sortedItems.where((item) {
        return item.title
                ?.toLowerCase()
                .contains(_searchKeyword.toLowerCase()) ??
            false;
      }).toList();
    }

    return sortedItems;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _selectedSortOption = 'Custom Date';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Latest News',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadFeeds,
            tooltip: 'Refresh Feeds',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButton<String>(
              value: _selectedSortOption,
              items: <String>[
                'All',
                'Today',
                'This Week',
                'This Month',
                'Custom Date'
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(value),
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue == 'Custom Date') {
                  _selectDate(context);
                } else {
                  _sortFeeds(newValue!);
                }
              },
              icon: Icon(Icons.filter_list),
              underline: Container(),
              dropdownColor: Theme.of(context).colorScheme.surface,
              elevation: 8,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
              ),
              onChanged: (value) {
                setState(() {
                  _searchKeyword = value;
                });
              },
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _getSortedItems().length,
                    itemBuilder: (context, index) {
                      final item = _getSortedItems()[index];
                      final imageUrl = _extractImageUrl(item);
                      final title = _decodeHtmlEntities(item.title ?? 'No Title');
                      if (title.contains('â')) {
                        return Container(); // Skip items with encoding issues
                      }
                      return NewsTile(
                        imageUrl: imageUrl ?? '',
                        title: title,
                        time: item.pubDate?.toString() ?? 'No Date',
                        ontap: () => _openFeedItem(item.link ?? ''),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  String? _extractImageUrl(RssItem item) {
    if (item.media?.contents?.isNotEmpty ?? false) {
      return item.media!.contents![0].url;
    }

    final description = item.description;
    if (description != null) {
      final regex = RegExp(r'url=(.*?)&');
      final match = regex.firstMatch(description);
      if (match != null) {
        final imageUrl = Uri.decodeComponent(match.group(1)!);
        if (imageUrl.endsWith('.jpg')) {
          return imageUrl;
        }
      }
    }

    return null;
  }

  void _openFeedItem(String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewsWebViewScreen(url: url),
      ),
    );
  }

  Future<List<RssItem>> fetchAllFeeds(List<String> urls) async {
    List<RssItem> allItems = [];

    for (String url in urls) {
      try {
        final feed = await RssFeedService.fetchFeed(url);
        if (feed.items != null) {
          allItems.addAll(feed.items!);
        }
      } catch (e) {
        print("Error fetching feed from $url: $e");
      }
    }

    return allItems;
  }

  String _decodeHtmlEntities(String text) {
    return text
        .replaceAll('â', '’')
        .replaceAll('âs', "’s")
        .replaceAll('Â', '')
        .replaceAll('â', '“')
        .replaceAll('â', '”')
        .replaceAll('â¦', '…')
        .replaceAll('â', '–')
        .replaceAll('â', '—');
  }
}

class NewsTile extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String time;
  final VoidCallback ontap;

  const NewsTile({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.time,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.8),
                      Colors.black.withOpacity(0.0),
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text(
                      DateFormat('yyyy-MM-dd').format(DateTime.parse(time)),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.access_time, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text(
                      DateFormat('HH:mm').format(DateTime.parse(time)),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NewsWebViewScreen extends StatefulWidget {
  final String url;

  NewsWebViewScreen({required this.url});

  @override
  _NewsWebViewScreenState createState() => _NewsWebViewScreenState();
}

class _NewsWebViewScreenState extends State<NewsWebViewScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _initializeWebView();
  }

  void _initializeWebView() {
    late final PlatformWebViewControllerCreationParams params;

    // Platform-specific setup
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    _controller = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            print('Page loading progress: $progress%');
          },
          onPageStarted: (String url) {
            print('Page started loading: $url');
          },
          onPageFinished: (String url) {
            print('Page finished loading: $url');
          },
          onHttpError: (HttpResponseError error) {
            //print('HTTP error: ${error.description}');
          },
          onWebResourceError: (WebResourceError error) {
            print('Web resource error: ${error.description}');
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url), headers: {
        "Cache-Control": "no-cache", // Ensure no caching issues
      });

    // Platform-specific settings for Android
    if (_controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (_controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
      
      // The `setMixedContentMode` method has been removed.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('News Article')),
      body: WebViewWidget(controller: _controller),
    );
  }
}
