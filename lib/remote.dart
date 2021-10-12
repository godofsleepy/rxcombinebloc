import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:rxcombinebloc/game.dart';
import 'package:rxdart/subjects.dart';

class Remote {
  factory Remote() {
    return _instance;
  }

  Remote._internal();

  static final Remote _instance = Remote._internal();

  Stream<List<Game>> getListGame({int page = 1}) {
    BehaviorSubject<List<Game>> subject = BehaviorSubject<List<Game>>();

    // Create url des tination

    var url = Uri.parse(
        'https://api.rawg.io/api/games?key=915260f2cb5041538cdedbc5c3b37a18&page=$page');

    // Await the http get response, then decode the json-formatted response.
    http.get(url).asStream().listen((response) {
      if (response.statusCode == 200) {
        List<dynamic> parsed = json.decode(response.body)['results'];

        subject.add(parsed.map((json) => Game.fromMap(json)).toList());
        subject.close();
      } else {
        print('Request failed with status: ${response.statusCode}.');
        subject.addError("${response.statusCode}");
        subject.close();
      }
    }, onError: (e) {
      subject.addError(e);
      subject.close();
    });

    return subject.stream;
  }
}
