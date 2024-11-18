import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(GameWidget(
    game: Jeu()));
}

class Jeu extends FlameGame {
  late SpriteComponent pickup;
  late SpriteComponent autre;
  late List<SpriteComponent> bananas;
  int score = 0;

  @override
  Future<void> onLoad() async {
    pickup = SpriteComponent()
      ..sprite = await loadSprite('pickup.png')
      ..size = Vector2(50, 80)
      ..position = Vector2(size.x / 2 - 50, size.y - 120);
    add(pickup);

    // autre = SpriteComponent()
    //   ..sprite = await loadSprite('player.png')
    //   ..size = Vector2(50, 50)
    //   ..position = Vector2(size.x / 2 - 50, size.y - 220);
    // add(autre);

    bananas = [];
    for (int i = 0; i < 5; i++) {
      await ajouterBanane();
    }
  }

  Future<void> ajouterBanane() async {
    final banana = SpriteComponent()
      ..sprite = await loadSprite('banana.png')
      ..size = Vector2(50, 50)
      ..position = Vector2(Random().nextDouble() * (size.x - 50), 0);
    bananas.add(banana);
    add(banana);
  }

  @override
  void update(double dt) {
    super.update(dt);
    for (var banana in bananas) {
      banana.position.y += 200 * dt; // Vitesse de chute
      if (banana.position.y > size.y) {
        banana.removeFromParent();
        bananas.remove(banana);
        ajouterBanane(); // Ajouter une nouvelle étoile
        break;
      }
      if (pickup.toRect().overlaps(banana.toRect())) {
        score++;
        banana.removeFromParent();
        bananas.remove(banana);
        ajouterBanane(); // Ajouter une nouvelle étoile
        break;
      }
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    const textStyle = TextStyle(color: Colors.white, fontSize: 24);
    final textSpan = TextSpan(
      text: 'Score: $score',
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, const Offset(10, 10));
  }

  void movePlayer(double dx) {
    pickup.position.x += dx;
    if (pickup.position.x < 0) pickup.position.x = 0;
    if (pickup.position.x > size.x - pickup.size.x) pickup.position.x = size.x - pickup.size.x;
  }

  @override
  void onTapDown(TapDownDetails details) {
    final touchPosition = details.localPosition;
    if (touchPosition.dx < size.x / 2) {
      movePlayer(-50); // Déplacer à gauche
    } else {
      movePlayer(50); // Déplacer à droite
    }
  }
}
