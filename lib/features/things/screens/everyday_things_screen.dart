import 'package:flutter/material.dart';

import '../../vocabulary/data/vocabulary_item.dart';
import '../../vocabulary/screens/vocabulary_lesson_screen.dart';

const List<VocabularyItem> everydayThings = [
  VocabularyItem(
    name: 'Table',
    emoji: '🪑',
    description: 'This is a table.',
    extraSentence: 'We put things on a table.',
  ),
  VocabularyItem(
    name: 'Chair',
    emoji: '🪑',
    description: 'This is a chair.',
    extraSentence: 'We sit on a chair.',
  ),
  VocabularyItem(
    name: 'Bed',
    emoji: '🛏️',
    description: 'This is a bed.',
    extraSentence: 'We sleep on a bed.',
  ),
  VocabularyItem(
    name: 'Sofa',
    emoji: '🛋️',
    description: 'This is a sofa.',
    extraSentence: 'We sit and relax on a sofa.',
  ),
  VocabularyItem(
    name: 'Door',
    emoji: '🚪',
    description: 'This is a door.',
    extraSentence: 'We open and close a door.',
  ),
  VocabularyItem(
    name: 'Window',
    emoji: '🪟',
    description: 'This is a window.',
    extraSentence: 'Light comes through a window.',
  ),
  VocabularyItem(
    name: 'Cupboard',
    emoji: '🗄️',
    description: 'This is a cupboard.',
    extraSentence: 'We keep things in a cupboard.',
  ),
  VocabularyItem(
    name: 'Lamp',
    emoji: '💡',
    description: 'This is a lamp.',
    extraSentence: 'A lamp gives us light.',
  ),
  VocabularyItem(
    name: 'Fan',
    emoji: '🌀',
    description: 'This is a fan.',
    extraSentence: 'A fan moves air.',
  ),
  VocabularyItem(
    name: 'Clock',
    emoji: '🕒',
    description: 'This is a clock.',
    extraSentence: 'A clock shows the time.',
  ),
  VocabularyItem(
    name: 'Television',
    emoji: '📺',
    description: 'This is a television.',
    extraSentence: 'We watch programs on television.',
  ),
  VocabularyItem(
    name: 'Phone',
    emoji: '📱',
    description: 'This is a phone.',
    extraSentence: 'We use a phone to talk.',
  ),
  VocabularyItem(
    name: 'Book',
    emoji: '📘',
    description: 'This is a book.',
    extraSentence: 'We read a book.',
  ),
  VocabularyItem(
    name: 'Pencil',
    emoji: '✏️',
    description: 'This is a pencil.',
    extraSentence: 'We write with a pencil.',
  ),
  VocabularyItem(
    name: 'School Bag',
    emoji: '🎒',
    description: 'This is a school bag.',
    extraSentence: 'We keep books in a school bag.',
  ),
  VocabularyItem(
    name: 'Cup',
    emoji: '☕',
    description: 'This is a cup.',
    extraSentence: 'We drink from a cup.',
  ),
  VocabularyItem(
    name: 'Plate',
    emoji: '🍽️',
    description: 'This is a plate.',
    extraSentence: 'We put food on a plate.',
  ),
  VocabularyItem(
    name: 'Spoon',
    emoji: '🥄',
    description: 'This is a spoon.',
    extraSentence: 'We eat with a spoon.',
  ),
  VocabularyItem(
    name: 'Ball',
    emoji: '⚽',
    description: 'This is a ball.',
    extraSentence: 'We play with a ball.',
  ),
  VocabularyItem(
    name: 'Bicycle',
    emoji: '🚲',
    description: 'This is a bicycle.',
    extraSentence: 'We ride a bicycle.',
  ),
];

class EverydayThingsScreen extends StatelessWidget {
  const EverydayThingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const VocabularyLessonScreen(
      title: 'Everyday Things',
      pickerTitle: 'Choose a Thing',
      completionMessage: 'Wonderful! You learned all the everyday things.',
      quizMessage: 'Everyday Things Quiz will be added in the next step!',
      headerEmoji: '🏠',
      primaryColor: Color(0xFF45B7D1),
      backgroundColor: Color(0xFFEEF9FF),
      items: everydayThings,
    );
  }
}
