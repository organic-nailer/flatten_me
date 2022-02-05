import 'package:url_launcher/url_launcher.dart';

void openUrl(String url) async {
  try {
    if (await canLaunch(url)) {
      await launch(url, forceSafariVC: false);
    } else {
      throw 'Could not launch $url';
    }
  } catch (e) {
    1;
  }
}
