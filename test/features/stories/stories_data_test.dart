import 'package:flutter_test/flutter_test.dart';
import 'package:little_hero/features/stories/data/story_item.dart';

void main() {
  test('contains six learning stories', () {
    expect(learningStories.length, 6);
  });

  test('every story has pages and a moral', () {
    for (final story in learningStories) {
      expect(story.pages, isNotEmpty);
      expect(story.moral, isNotEmpty);
    }
  });
}
