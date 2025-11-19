import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:myapp/chat_messaging_screen.dart';
import 'package:shimmer/shimmer.dart';

class ChatModel {
  final String name;
  final String message;
  final String time;
  final String imgPath;
  final bool status;
  final int? messNum;

  ChatModel({
    required this.name,
    required this.message,
    required this.time,
    required this.imgPath,
    this.status = false,
    this.messNum,
  });
}

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});
  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  late List<ChatModel> items;
  late List<StoryItem> stories;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    items = [
      ChatModel(
        name: "John Doe",
        message: "Hello there!",
        time: "12:30 PM",
        imgPath: "https://picsum.photos/seed/p1/200/200",
        status: true,
        messNum: 2,
      ),
      ChatModel(
        name: "Jane Doe",
        message: "How are you?",
        time: "12:35 PM",
        imgPath: "https://picsum.photos/seed/p2/200/200",
      ),
      ChatModel(
        name: "Peter Jones",
        message: "See you soon.",
        time: "12:40 PM",
        imgPath: "https://picsum.photos/seed/p3/200/200",
        status: true,
        messNum: 1,
      ),
    ];
    stories = [
      StoryItem(name: 'Alex', imageUrl: 'https://picsum.photos/seed/s1/200/200'),
      StoryItem(name: 'Ben', imageUrl: 'https://picsum.photos/seed/s2/200/200'),
      StoryItem(
          name: 'Catherine',
          imageUrl: 'https://picsum.photos/seed/s3/200/200'),
      StoryItem(name: 'David', imageUrl: 'https://picsum.photos/seed/s4/200/200'),
      StoryItem(name: 'Ella', imageUrl: 'https://picsum.photos/seed/s5/200/200'),
      StoryItem(name: 'Frank', imageUrl: 'https://picsum.photos/seed/s6/200/200'),
      StoryItem(name: 'Grace', imageUrl: 'https://picsum.photos/seed/s7/200/200'),
      StoryItem(name: 'Henry', imageUrl: 'https://picsum.photos/seed/s8/200/200'),
    ];
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.menu),
          ),
          title: const Text('myapps'),
          actions: <Widget>[
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.search),
            )
          ],
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.notifications)),
              Tab(text: "add"),
              Tab(text: "chats"),
              Tab(text: "meeting"),
              Tab(icon: Icon(Icons.call)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            const Center(child: Text("Notifications")),
            const Center(child: Text("Add")),
            ListView(
              children: [
                const SizedBox(height: 10),
                StatusBar(
                  isLoading: isLoading,
                  stories: stories,
                ),
                ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (ctx, i) {
                      return ListTile(
                        onTap: () {
                          Navigator.of(context).push(
                            createRoute(
                              items[i].imgPath,
                              items[i].name,
                              items[i].time,
                              items[i].status ? "Online" : "Offline",
                              items[i].message,
                              context,
                            ),
                          );
                        },
                        leading: CircleAvatar(
                          radius: 28,
                          child: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: items[i].imgPath,
                              placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: 56,
                                  height: 56,
                                  color: Colors.white,
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              fit: BoxFit.cover,
                              width: 56,
                              height: 56,
                            ),
                          ),
                        ),
                        title: items[i].status
                            ? Text(
                                items[i].name,
                                style:
                                    const TextStyle(fontWeight: FontWeight.bold),
                              )
                            : Row(
                                children: [
                                  Text(
                                    items[i].name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Icon(
                                    Icons.volume_mute,
                                    size: 18,
                                    color: Colors.grey[400],
                                  )
                                ],
                              ),
                        subtitle: Text(
                          items[i].message,
                          style: const TextStyle(color: Colors.grey),
                        ),
                        trailing: items[i].messNum != null
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(items[i].time),
                                  const SizedBox(
                                    height: 7,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: items[i].status
                                            ? Colors.green
                                            : Colors.grey[400],
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        '${items[i].messNum}',
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(items[i].time),
                                  const SizedBox(
                                    height: 7,
                                  ),
                                ],
                              ),
                      );
                    },
                    separatorBuilder: (ctx, i) {
                      return const Divider();
                    },
                    itemCount: items.length),
              ],
            ),
            const Center(child: Text("Meeting")),
            const Center(child: Text("Calls")),
          ],
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: const Color(0xFF65a9e0),
            onPressed: () {},
            child: const Icon(Icons.create, color: Colors.white)),
      ),
    );
  }
}

class StatusBar extends StatelessWidget {
  final bool isLoading;
  final List<StoryItem> stories;

  const StatusBar({
    super.key,
    required this.isLoading,
    required this.stories,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: isLoading ? 8 : stories.length,
        itemBuilder: (context, index) {
          if (isLoading) return _ShimmerStory();
          return _StoryBubble(item: stories[index]);
        },
      ),
    );
  }
}

class StoryItem {
  final String name;
  final String imageUrl;

  StoryItem({
    required this.name,
    required this.imageUrl,
  });
}

class _StoryBubble extends StatelessWidget {
  final StoryItem item;

  const _StoryBubble({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      margin: const EdgeInsets.only(right: 14),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(2.4),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Colors.purple,
                  Colors.orange,
                ],
              ),
            ),
            child: CircleAvatar(
              radius: 28,
              backgroundImage: NetworkImage(item.imageUrl),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            item.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _ShimmerStory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade900,
      highlightColor: Colors.grey.shade700,
      child: Container(
        width: 72,
        margin: const EdgeInsets.only(right: 14),
        child: const Column(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.black,
            ),
            SizedBox(height: 10),
            Text('data')
          ],
        ),
      ),
    );
  }
}
