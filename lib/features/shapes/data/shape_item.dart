import 'package:flutter/material.dart';

enum LearningShapeType {
  circle,
  square,
  triangle,
  rectangle,
  oval,
  star,
  heart,
  diamond,
  pentagon,
  hexagon,
  octagon,
  crescent,
}

class LearningShape {
  final String name;
  final String exampleName;
  final String emoji;
  final LearningShapeType type;
  final Color color;

  const LearningShape({
    required this.name,
    required this.exampleName,
    required this.emoji,
    required this.type,
    required this.color,
  });
}

const List<LearningShape> learningShapes = [
  LearningShape(
    name: 'Circle',
    exampleName: 'Ball',
    emoji: '⚽',
    type: LearningShapeType.circle,
    color: Color(0xFFFF6B6B),
  ),
  LearningShape(
    name: 'Square',
    exampleName: 'Window',
    emoji: '🪟',
    type: LearningShapeType.square,
    color: Color(0xFF4D96FF),
  ),
  LearningShape(
    name: 'Triangle',
    exampleName: 'Pizza Slice',
    emoji: '🍕',
    type: LearningShapeType.triangle,
    color: Color(0xFFFFA94D),
  ),
  LearningShape(
    name: 'Rectangle',
    exampleName: 'Door',
    emoji: '🚪',
    type: LearningShapeType.rectangle,
    color: Color(0xFF51CF66),
  ),
  LearningShape(
    name: 'Oval',
    exampleName: 'Egg',
    emoji: '🥚',
    type: LearningShapeType.oval,
    color: Color(0xFFFFD43B),
  ),
  LearningShape(
    name: 'Star',
    exampleName: 'Star',
    emoji: '⭐',
    type: LearningShapeType.star,
    color: Color(0xFFFFC107),
  ),
  LearningShape(
    name: 'Heart',
    exampleName: 'Heart',
    emoji: '❤️',
    type: LearningShapeType.heart,
    color: Color(0xFFFF4D8D),
  ),
  LearningShape(
    name: 'Diamond',
    exampleName: 'Kite',
    emoji: '🪁',
    type: LearningShapeType.diamond,
    color: Color(0xFF9C6ADE),
  ),
  LearningShape(
    name: 'Pentagon',
    exampleName: 'Five-sided Shape',
    emoji: '5️⃣',
    type: LearningShapeType.pentagon,
    color: Color(0xFF20C997),
  ),
  LearningShape(
    name: 'Hexagon',
    exampleName: 'Honeycomb',
    emoji: '🍯',
    type: LearningShapeType.hexagon,
    color: Color(0xFFFF922B),
  ),
  LearningShape(
    name: 'Octagon',
    exampleName: 'Stop Sign',
    emoji: '🛑',
    type: LearningShapeType.octagon,
    color: Color(0xFFE03131),
  ),
  LearningShape(
    name: 'Crescent',
    exampleName: 'Moon',
    emoji: '🌙',
    type: LearningShapeType.crescent,
    color: Color(0xFF5F3DC4),
  ),
];
