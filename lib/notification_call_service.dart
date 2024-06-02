import 'dart:convert';

import 'package:Rimio/view/homeScreen.dart';
import 'package:dio/dio.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;

class NotificationCallService {
  sendNotification(notification, data, fcmToken) async {
    try {
      await getJsonData();
      String token = await getAccessToken();
      print("token $token");
      var map = {
        "message": {
          "notification": notification,
          "data": data,
          "token": fcmToken
        }
      };
      String url =
          "https://fcm.googleapis.com/v1/projects/rimio-190cd/messages:send";
      Map<String, dynamic> header = {
        "content-type": "application/x-www-form-urlencoded",
        "Authorization": token
      };
      // var response =
      //     await http.post(Uri.parse(url), body: map, headers: header);
      Dio dio = Dio();
      // dio.options.headers['Authorization'] = token;
      Options options = Options();
      options.headers = header;
      dio.options.headers['Authorization'] = token;
      var response = await dio.post(url, data: map);
      var res = jsonEncode(map);
      print("");
    } catch (ex) {
      print(ex.toString());
    }
  }

  Future<String> getAccessToken() async {
    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];
    http.Client client = await auth.clientViaServiceAccount(
        auth.ServiceAccountCredentials.fromJson(jsonData), scopes);

    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
            auth.ServiceAccountCredentials.fromJson(jsonData), scopes, client);

    client.close();

    var token =
        ('${credentials.accessToken.type} ${credentials.accessToken.data}');
    return token;
  }
}
