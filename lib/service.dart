import 'package:dio/dio.dart';

class Service {
  sendNotification() async {
    Dio dio = Dio();
    var body = {};
    String url = "https://fcm.googleapis.com/fcm/send";
    var response = await dio.post(url, data: body);
  }
}
