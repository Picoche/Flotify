import 'dart:convert';
import 'package:http/http.dart' as http;

String currentToken = '';
String clientId = 'aecff8cde9704cea81c659daf0ca631a';
String clientSecret = '30f132346d6c454697e9919bc45f3814';

Future<String> refreshToken() async {

  var response = await http.post(
    Uri.parse('https://accounts.spotify.com/api/token'),
    headers: {
      'Authorization': 'Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}',
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: {
      'grant_type': 'refresh_token',
      'refresh_token': currentToken,
    },
  );

  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    return jsonResponse['access_token'];
  } else {
    return generateToken();
  }
}

Future<String> generateToken() async {

  var response = await http.post(
    Uri.parse('https://accounts.spotify.com/api/token'),
    headers: {
      'Authorization': 'Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}',
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: {
      'grant_type': 'client_credentials',
    },
  );

  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    currentToken = jsonResponse['access_token'];
    return currentToken;
  } else {
    throw Exception('Failed to generate token');
  }
}