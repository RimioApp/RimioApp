// ad_helper.dart
import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3926377469464915/4194021528'; // test: 'ca-app-pub-3940256099942544/6300978111';
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }
  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/1033173712';
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }
}