import 'dart:convert';

class Game {
  String name;
  String backgroundImage;

  Game({
    required this.name,
    required this.backgroundImage,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'background_image': backgroundImage,
    };
  }

  factory Game.fromMap(Map<String, dynamic> map) {
    return Game(
      name: map['name'],
      backgroundImage: map['background_image'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Game.fromJson(String source) => Game.fromMap(json.decode(source));
}
