import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:share_plus/share_plus.dart';


class DynamicLinkProvider {

  Future<String> createLink(String refCode) async {
    final String url = "https://com.rimiomusic.rimio?ref=$refCode";

    final DynamicLinkParameters parameters = DynamicLinkParameters(
        link: Uri.parse(url),
        androidParameters: const AndroidParameters(packageName: "com.rimiomusic.rimio", minimumVersion: 0),
        uriPrefix: 'https://rimio.page.link');

    final FirebaseDynamicLinks link = await FirebaseDynamicLinks.instance;

    final refLink = await link.buildShortLink(parameters);

    return refLink.shortUrl.toString();
  }

  ///init Dynamic Link
  void initDynamicLink() async {
    final instanceLink = await FirebaseDynamicLinks.instance.getInitialLink();

    if (instanceLink != null){
      final Uri refLink = instanceLink.link;

      Share.share("this is the link ${refLink.data}");
    }
  }
}