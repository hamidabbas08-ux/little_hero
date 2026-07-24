import 'package:flutter/material.dart';

import '../../vocabulary/data/vocabulary_item.dart';
import '../../vocabulary/screens/vocabulary_lesson_screen.dart';

const List<VocabularyItem> animalItems = [
  VocabularyItem(
    name: 'Lion',
    emoji: '🦁',
    description: 'The lion is a strong wild animal.',
    extraSentence: 'A lion roars.',
  ),
  VocabularyItem(
    name: 'Tiger',
    emoji: '🐯',
    description: 'The tiger has black stripes.',
    extraSentence: 'A tiger growls.',
  ),
  VocabularyItem(
    name: 'Elephant',
    emoji: '🐘',
    description: 'The elephant is a very large animal.',
    extraSentence: 'An elephant has a long trunk.',
  ),
  VocabularyItem(
    name: 'Monkey',
    emoji: '🐒',
    description: 'The monkey likes to climb trees.',
    extraSentence: 'A monkey chatters.',
  ),
  VocabularyItem(
    name: 'Bear',
    emoji: '🐻',
    description: 'The bear is big and strong.',
    extraSentence: 'A bear growls.',
  ),
  VocabularyItem(
    name: 'Rabbit',
    emoji: '🐰',
    description: 'The rabbit has long ears.',
    extraSentence: 'A rabbit can hop.',
  ),
  VocabularyItem(
    name: 'Giraffe',
    emoji: '🦒',
    description: 'The giraffe has a very long neck.',
    extraSentence: 'A giraffe eats leaves.',
  ),
  VocabularyItem(
    name: 'Zebra',
    emoji: '🦓',
    description: 'The zebra has black and white stripes.',
    extraSentence: 'A zebra can run fast.',
  ),
  VocabularyItem(
    name: 'Cat',
    emoji: '🐱',
    description: 'The cat is a small pet animal.',
    extraSentence: 'A cat says meow.',
  ),
  VocabularyItem(
    name: 'Dog',
    emoji: '🐶',
    description: 'The dog is a friendly pet animal.',
    extraSentence: 'A dog says woof.',
  ),
  VocabularyItem(
    name: 'Cow',
    emoji: '🐄',
    description: 'The cow gives us milk.',
    extraSentence: 'A cow says moo.',
  ),
  VocabularyItem(
    name: 'Horse',
    emoji: '🐴',
    description: 'The horse can run very fast.',
    extraSentence: 'A horse neighs.',
  ),
  VocabularyItem(
    name: 'Sheep',
    emoji: '🐑',
    description: 'The sheep gives us wool.',
    extraSentence: 'A sheep says baa.',
  ),
  VocabularyItem(
    name: 'Goat',
    emoji: '🐐',
    description: 'The goat can climb rocky places.',
    extraSentence: 'A goat says bleat.',
  ),
  VocabularyItem(
    name: 'Duck',
    emoji: '🦆',
    description: 'The duck can swim in water.',
    extraSentence: 'A duck says quack.',
  ),
  VocabularyItem(
    name: 'Hen',
    emoji: '🐔',
    description: 'The hen is a farm bird.',
    extraSentence: 'A hen lays eggs.',
  ),
  VocabularyItem(
    name: 'Parrot',
    emoji: '🦜',
    description: 'The parrot is a colorful bird.',
    extraSentence: 'A parrot can copy sounds.',
  ),
  VocabularyItem(
    name: 'Fish',
    emoji: '🐟',
    description: 'The fish lives in water.',
    extraSentence: 'A fish swims with fins.',
  ),
  VocabularyItem(
    name: 'Dolphin',
    emoji: '🐬',
    description: 'The dolphin is a clever sea animal.',
    extraSentence: 'A dolphin can jump from the water.',
  ),
  VocabularyItem(
    name: 'Crocodile',
    emoji: '🐊',
    description: 'The crocodile is a large reptile.',
    extraSentence: 'A crocodile has strong teeth.',
  ),
];

class AnimalLessonScreen extends StatelessWidget {
  const AnimalLessonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const VocabularyLessonScreen(
      title: 'Animals',
      pickerTitle: 'Choose an Animal',
      completionMessage: 'Amazing! You learned all the animals.',
      quizMessage: 'Animals Quiz will be added in the next step!',
      headerEmoji: '🐾',
      primaryColor: Color(0xFFFF9B45),
      backgroundColor: Color(0xFFFFF8E8),
      items: animalItems,
    );
  }
}
