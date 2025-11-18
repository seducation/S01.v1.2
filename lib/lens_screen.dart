import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class LensScreen extends StatefulWidget {
  const LensScreen({super.key});

  @override
  LensScreenState createState() => LensScreenState();
}

class LensScreenState extends State<LensScreen> {
  late Client client;
  late Databases databases;
  final List<Document> _items = [];
  bool _isLoading = false;
  String? _lastId;

  @override
  void initState() {
    super.initState();
    client = Client()
        .setEndpoint('https://cloud.appwrite.io/v1')
        .setProject('YOUR_PROJECT_ID');
    databases = Databases(client);
    _fetchData();
  }

  Future<void> _fetchData() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await databases.listDocuments(
        databaseId: 'YOUR_DATABASE_ID',
        collectionId: 'YOUR_COLLECTION_ID',
        queries: [
          Query.limit(10),
          if (_lastId != null) Query.cursorAfter(_lastId!)
        ],
      );

      setState(() {
        _items.addAll(response.documents);
        if (response.documents.isNotEmpty) {
          _lastId = response.documents.last.$id;
        }
        _isLoading = false;
      });
    } catch (e) {
      log('Error fetching data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // Handle menu button press
          },
        ),
        title: const Text('Lens'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _items.clear();
              _lastId = null;
              _fetchData();
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: const Center(
                child: Text(
                  'Camera',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (!_isLoading &&
              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            _fetchData();
          }
          return true;
        },
        child: StaggeredGrid.count(
          crossAxisCount: 2,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          children: List.generate(
            _items.length,
            (index) {
              final isBigTile = index % 5 == 0;
              final item = _items[index].data;
              return StaggeredGridTile.count(
                crossAxisCellCount: isBigTile ? 2 : 1,
                mainAxisCellCount: isBigTile ? 1.5 : 1,
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Image.network(
                          item['imageUrl'],
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          item['title'],
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}