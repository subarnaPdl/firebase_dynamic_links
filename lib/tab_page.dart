import 'package:dynamic_links/services/firebase_dynamic_link_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TabPage extends StatefulWidget {
  final String title;
  final FirebaseDynamicLinkService firebaseDynamicLinkService;
  const TabPage(
      {super.key,
      required this.title,
      required this.firebaseDynamicLinkService});

  @override
  State<TabPage> createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
  String? dynamicLink;

  Future<void> createDynamicLink(
      {required bool isShort, required String path}) async {
    dynamicLink = await widget.firebaseDynamicLinkService
        .createDynamicLink(isShort, path);
  }

  Future<void> copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: dynamicLink)).then(
        (value) => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Url copied to clipbaord'),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          if (widget.title == 'Third Page')
            Column(
              children: [
                const SizedBox(height: 20),
                Text(
                  dynamicLink ?? 'Dynamic Link',
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () =>
                      createDynamicLink(isShort: false, path: 'third_page')
                          .then((_) => setState(() {})),
                  child: const Text('Create Long Link'),
                ),
                ElevatedButton(
                  onPressed: () =>
                      createDynamicLink(isShort: true, path: 'third_page')
                          .then((_) => setState(() {})),
                  child: const Text('Create Short Link'),
                ),
                ElevatedButton(
                  onPressed: copyToClipboard,
                  child: const Text('Copy Link'),
                ),
              ],
            ),
        ],
      )),
    );
  }
}
