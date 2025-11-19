
// ignore_for_file: unused_local_variable, unused_import
import 'package:cached_network_image/cached_network_image.dart';
import 'package:myapp/provider/theme.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

Route createRoute(
    String urlImage, String title, var time, onOff, String msgs, context) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 100),
    reverseTransitionDuration: const Duration(milliseconds: 100),
    pageBuilder: (context, animation, secondaryAnimation) =>
        ChatMessagingScreen(urlImage: urlImage, title: title, onOff: onOff),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeIn;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

class ChatMessagingScreen extends StatelessWidget {
  final String urlImage;
  final String title;
  final String onOff;

  const ChatMessagingScreen(
      {super.key,
      required this.urlImage,
      required this.title,
      required this.onOff});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: Row(
          children: [
            SizedBox(
              height: 40,
              width: 40,
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: urlImage,
                  fit: BoxFit.fill,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      color: Colors.white,
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title),
                const SizedBox(
                  height: 2,
                ),
                Text(
                  onOff,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
        actions: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Icon(Icons.call),
          ),
          PopupMenuButton(
            padding: EdgeInsets.zero,
            itemBuilder: (context) => [
              PopupMenuItem(
                height: 0,
                padding: EdgeInsets.zero,
                value: 0,
                child: ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.volume_up_outlined,
                        color: Colors.grey,
                        //size: 30,
                      ),
                    ],
                  ),
                  title: Transform.translate(
                    offset: Offset(-16, 0),
                    child: Text(
                      "Senyap",
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_outlined,
                    size: 20,
                  ),
                ),
              ),
              PopupMenuItem(
                height: 0,
                padding: EdgeInsets.zero,
                child: Divider(
                  thickness: 7,
                  color: const Color.fromARGB(255, 186, 183, 183).withAlpha(26),
                ),
              ),
              PopupMenuItem(
                height: 0,
                padding: EdgeInsets.zero,
                value: 1,
                child: ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.videocam_outlined,
                        color: Colors.grey,
                        //size: 30,
                      ),
                    ],
                  ),
                  title: Transform.translate(
                    offset: Offset(-16, 0),
                    child: Text(
                      "Panggilan Video",
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
              ),
              PopupMenuItem(
                height: 0,
                padding: EdgeInsets.zero,
                value: 1,
                child: ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_outlined,
                        color: Colors.grey,
                        //size: 30,
                      ),
                    ],
                  ),
                  title: Transform.translate(
                    offset: Offset(-16, 0),
                    child: Text(
                      "Cari",
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
              ),
              PopupMenuItem(
                height: 0,
                padding: EdgeInsets.zero,
                value: 1,
                child: ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.brush_outlined,
                        color: Colors.grey,
                        //size: 30,
                      ),
                    ],
                  ),
                  title: Transform.translate(
                    offset: Offset(-16, 0),
                    child: Text(
                      "Bersihkan Riwayat",
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
              ),
              PopupMenuItem(
                height: 0,
                padding: EdgeInsets.zero,
                value: 1,
                child: ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.colorize_outlined,
                        color: Colors.grey,
                        //size: 30,
                      ),
                    ],
                  ),
                  title: Transform.translate(
                    offset: Offset(-16, 0),
                    child: Text(
                      "Ganti Warna",
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
              ),
              PopupMenuItem(
                height: 0,
                padding: EdgeInsets.zero,
                value: 1,
                child: ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  leading: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.delete_outline_outlined,
                        color: Colors.grey,
                        //size: 30,
                      ),
                    ],
                  ),
                  title: Transform.translate(
                    offset: Offset(-16, 0),
                    child: Text(
                      "Hapus Obrolan",
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: const ChatScr(),
    );
  }
}


class ChatMess extends StatelessWidget {
  final String text;
  final AnimationController animationController;

  const ChatMess(
      {super.key, required this.text, required this.animationController});

  @override
  Widget build(BuildContext context) {
    var dt = DateTime.now();

    return Consumer<ThemeModel>(
      builder: (context, ThemeModel themeNotifier, child) {
        return SizeTransition(
          sizeFactor: CurvedAnimation(
              parent: animationController, curve: Curves.easeOut),
          axisAlignment: 0.0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              color: themeNotifier.isDark
                  ? const Color.fromARGB(255, 35, 107, 167)
                  : const Color.fromARGB(255, 205, 243, 176),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10.0),
                bottomLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
            ),
            margin: const EdgeInsets.symmetric(vertical: 2.0),
            child: Row(
              children: [
                Text(
                  text,
                  style: const TextStyle(fontSize: 17),
                ),
                const SizedBox(
                  width: 7,
                ),
                Column(
                  children: [
                    const Text(""),
                    Row(
                      children: [
                        Text(
                          "${dt.hour}:${dt.minute}",
                          style: TextStyle(
                            fontSize: 12,
                            color: themeNotifier.isDark
                                ? const Color.fromARGB(255, 185, 185, 185)
                                : Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          width: 7,
                        ),
                        Icon(
                          Icons.done,
                          size: 15,
                          color: themeNotifier.isDark
                              ? const Color.fromARGB(255, 80, 171, 246)
                              : Colors.grey,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ChatScr extends StatefulWidget {
  const ChatScr({super.key});

  @override
  State<ChatScr> createState() => _ChatScrState();
}

class _ChatScrState extends State<ChatScr> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final List<ChatMess> _messages = [];
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    for (var message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }

  void _handleSubmitted(String text) {
    _textController.clear();

    var message = ChatMess(
      text: text,
      animationController: AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
      ),
    );
    setState(() {
      _messages.insert(0, message);
    });
    _focusNode.requestFocus();
    message.animationController.forward();
  }

  Widget _buildTextComposer() {
    bool sendMic = false;

    return Consumer<ThemeModel>(
      builder: (context, ThemeModel themeNotifier, child) {
        return Row(
          children: [
            Flexible(
              child: SizedBox(
                height: 50,
                child: TextField(
                  controller: _textController,
                  onChanged: (text) {
                    setState(() {
                      sendMic = true;
                    });
                  },
                  onSubmitted: _handleSubmitted,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    filled: true,
                    fillColor:
                        themeNotifier.isDark ? Colors.black : Colors.white,
                    prefixIcon: const Icon(
                      Icons.emoji_emotions_outlined,
                      color: Colors.grey,
                    ),
                    hintText: 'Pesan',
                    hintStyle:
                        const TextStyle(fontSize: 20, color: Colors.grey),
                    suffixIconConstraints:
                        const BoxConstraints(minWidth: 80, maxWidth: 100),
                    suffixIcon: _textController.text == ''
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.attach_file_outlined,
                                color: Colors.grey,
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.mic_none_outlined,
                                ),
                                onPressed: () => // MODIFIED
                                    _handleSubmitted(
                                        _textController.text) // MODIFIED
                                ,
                              ),
                            ],
                          )
                        : IconButton(
                            icon: const Icon(
                              Icons.send,
                              color: Colors.blue,
                            ),
                            onPressed: () => // MODIFIED
                                _handleSubmitted(
                                    _textController.text) // MODIFIED
                            ,
                          ),
                  ),
                  focusNode: _focusNode,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ↓ hold tap position, set during onTapDown, using getPosition() method
  Offset? tapXY;
  // ↓ hold screen size, using first line in build() method
  RenderBox? overlay;
  @override
  Widget build(BuildContext context) {
    overlay = Overlay.of(context).context.findRenderObject() as RenderBox?;
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Consumer<ThemeModel>(
        builder: (context, ThemeModel themeNotifier, child) {
      return Container(
        constraints: const BoxConstraints.expand(),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: themeNotifier.isDark
                ? const AssetImage("web/icons/Icon-512.png")
                : const AssetImage("web/icons/Icon-512.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            _messages.isEmpty
                ? Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: Container(
                      margin: EdgeInsets.only(top: height * 0.24),
                      width: width * 0.65,
                      height: width * 0.5,
                      decoration: BoxDecoration(
                        color: Colors.black.withAlpha(87),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          SizedBox(
                            height: width * 0.05,
                          ),
                          const Text(
                            "Belum ada pesan di sini...",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: width * 0.07,
                          ),
                          const Text(
                            "Kirim pesan dan tekan sambutan di bawah.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: width * 0.01,
                          ),
                          SizedBox(
                            height: width * 0.2,
                            child: CachedNetworkImage(
                              imageUrl: "https://picsum.photos/seed/hi/200/200",
                              placeholder: (context, url) =>
                                  Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  color: Colors.white,
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : const Text(""),
            // NEW
            Flexible(
              // NEW
              child: ListView.builder(
                // NEW
                padding: const EdgeInsets.all(8.0), // NEW
                reverse: true, // NEW
                itemBuilder: (_, index) => Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTapDown: getPosition,
                      onLongPress: () {
                        //FIX pop up menu
                        showMenu<String>(
                          context: context,
                          position: relRectSize,
                          items: [
                            PopupMenuItem<String>(
                              onTap: () {
                                setState(() {
                                  _messages.removeAt(index);
                                });
                              },
                              value: '1',
                              child: const Text('Delete'),
                            ),
                          ],
                          elevation: 8.0,
                        );
                      },
                      child: _messages[index],
                    ),
                  ],
                ), // NEW
                itemCount: _messages.length, // NEW
              ), // NEW
            ), // NEW
            const Divider(height: 1.0),
            Container(
              decoration: BoxDecoration(color: Theme.of(context).cardColor),
              child: _buildTextComposer(),
            ),
          ], // NEW
        ),
      );
    });
  }

  RelativeRect get relRectSize =>
      RelativeRect.fromSize(tapXY! & const Size(40, 40), overlay!.size);

  // ↓ get the tap position Offset
  void getPosition(TapDownDetails detail) {
    tapXY = detail.globalPosition;
  }
}
