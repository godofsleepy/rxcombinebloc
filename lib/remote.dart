import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rxcombinebloc/game.dart';

class Remote {
  factory Remote() {
    return _instance;
  }

  Remote._internal();

  static final Remote _instance = Remote._internal();

  Future<List<Game>> getListGame({int page = 1}) async {
    // Create url destination
    try {
      var url = Uri.parse(
          'https://api.rawg.io/api/games?key=915260f2cb5041538cdedbc5c3b37a18&page=$page');

      // Await the http get response, then decode the json-formatted response.
      var response = await http.get(url);

      // Check response code
      if (response.statusCode == 200) {
        List<dynamic> parsed = json.decode(response.body)['results'];

        return parsed.map((json) => Game.fromMap(json)).toList();
      } else {
        print('Request failed with status: ${response.statusCode}.');
        return [];
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}
