import 'package:url_launcher/url_launcher.dart';

class UrlService {
  Future<bool> openExternal(String url) async {
    final uri = Uri.parse(url);
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

