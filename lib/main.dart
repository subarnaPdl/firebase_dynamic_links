import 'package:dynamic_links/tab_page.dart';
import 'package:dynamic_links/services/firebase_dynamic_link_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  late FirebaseDynamicLinkService firebaseDynamicLinkService;
  late TabController _tabController;
  int index = 0;

  Map<String, IconData> pages = {
    'First Page': Icons.one_k,
    'Second Page': Icons.two_k,
    'Third Page': Icons.three_k,
  };

  @override
  void initState() {
    _tabController =
        TabController(length: pages.length, vsync: this, initialIndex: index);
    initDynamicLinks();
    super.initState();
  }

  Future<void> initDynamicLinks() async {
    firebaseDynamicLinkService = FirebaseDynamicLinkService(handleDynamicLinks);
    await firebaseDynamicLinkService.init();
  }

  void handleDynamicLinks(String path) {
    switch (path) {
      case '/first_page':
        changeTab('First Page');
        break;
      case '/second_page':
        changeTab('Second Page');
        break;
      case '/third_page':
        changeTab('Third Page');
        break;
      default:
        changeTab('First Page');
    }
  }

  void changeTab(String page) {
    setState(() {
      index = pages.keys.toList().indexOf(page);
      _tabController.animateTo(index);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: pages.length,
        child: Scaffold(
          body: TabBarView(
            controller: _tabController,
            children: pages.keys
                .map((e) => TabPage(
                    title: e,
                    firebaseDynamicLinkService: firebaseDynamicLinkService))
                .toList(),
          ),
          bottomNavigationBar: Container(
            color: Colors.grey[100],
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.blue,
              labelStyle: const TextStyle(color: Colors.blue),
              unselectedLabelColor: Colors.grey,
              unselectedLabelStyle: const TextStyle(color: Colors.grey),
              tabs: pages.entries
                  .map((e) => Tab(
                        text: e.key,
                        icon: Icon(e.value),
                      ))
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}
