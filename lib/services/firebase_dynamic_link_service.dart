import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

// Ex
// deepLink = https://subarnapdl.page.link/first_page
// path = /first_page

class FirebaseDynamicLinkService {
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  final Function(String) handleDynamicLinks;

  FirebaseDynamicLinkService(this.handleDynamicLinks);

  Future<void> init() async {
    // Check if you received the link via `getInitialLink` first
    final PendingDynamicLinkData? initialLink =
        await dynamicLinks.getInitialLink();

    if (initialLink != null) {
      final Uri deepLink = initialLink.link;
      handleDynamicLinks(deepLink.path);
    }

    dynamicLinks.onLink.listen(
      (PendingDynamicLinkData? pendingDynamicLinkData) {
        // Set up the `onLink` event listener next as it may be received here
        if (pendingDynamicLinkData != null) {
          final Uri deepLink = pendingDynamicLinkData.link;
          handleDynamicLinks(deepLink.path);
        }
      },
    ).onError((error) {
      print('Error Occurred : ${error.message}');
    });
  }

  Future<String> createDynamicLink(bool isShort, String path) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://subarnapdl.page.link/',
      link: Uri.parse('https://subarnapdl.page.link/$path'),
      androidParameters: const AndroidParameters(
        packageName: 'com.example.dynamic_links',
      ),
    );

    Uri url;
    if (isShort) {
      final ShortDynamicLink shortLink =
          await dynamicLinks.buildShortLink(parameters);
      url = shortLink.shortUrl;
    } else {
      url = await dynamicLinks.buildLink(parameters);
    }

    return url.toString();
  }
}
