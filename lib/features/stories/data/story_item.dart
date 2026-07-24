class StoryPageItem {
  final String emoji;
  final String text;

  const StoryPageItem({required this.emoji, required this.text});
}

class StoryItem {
  final String title;
  final String coverEmoji;
  final String subtitle;
  final String moral;
  final List<StoryPageItem> pages;

  const StoryItem({
    required this.title,
    required this.coverEmoji,
    required this.subtitle,
    required this.moral,
    required this.pages,
  });
}

const List<StoryItem> learningStories = [
  StoryItem(
    title: 'The Thirsty Crow',
    coverEmoji: '🐦‍⬛',
    subtitle: 'A clever crow finds water',
    moral: 'Where there is a will, there is a way.',
    pages: [
      StoryPageItem(
        emoji: '☀️🐦‍⬛',
        text: 'One hot day, a thirsty crow flew around looking for water.',
      ),
      StoryPageItem(
        emoji: '🐦‍⬛🏺',
        text: 'The crow found a pot with a little water at the bottom.',
      ),
      StoryPageItem(
        emoji: '😟🏺',
        text: 'The crow could not reach the water with its beak.',
      ),
      StoryPageItem(
        emoji: '🐦‍⬛🪨',
        text: 'The clever crow picked up small stones one by one.',
      ),
      StoryPageItem(
        emoji: '🪨🏺💧',
        text: 'It dropped the stones into the pot, and the water rose higher.',
      ),
      StoryPageItem(
        emoji: '🐦‍⬛💧😊',
        text: 'The crow drank the water and flew away happily.',
      ),
    ],
  ),
  StoryItem(
    title: 'The Lion and the Mouse',
    coverEmoji: '🦁🐭',
    subtitle: 'A small friend helps a lion',
    moral: 'Kindness is never wasted.',
    pages: [
      StoryPageItem(
        emoji: '🦁😴',
        text: 'A lion was sleeping peacefully under a tree.',
      ),
      StoryPageItem(
        emoji: '🐭🦁',
        text: 'A little mouse ran over the lion and woke him up.',
      ),
      StoryPageItem(
        emoji: '🦁🐭😨',
        text: 'The lion caught the mouse, but the mouse asked for mercy.',
      ),
      StoryPageItem(
        emoji: '🦁❤️🐭',
        text: 'The lion was kind and allowed the little mouse to go.',
      ),
      StoryPageItem(
        emoji: '🦁🪢',
        text: 'Later, the lion was trapped inside a hunter’s net.',
      ),
      StoryPageItem(
        emoji: '🐭🦷🪢',
        text: 'The mouse cut the net with its sharp teeth and saved the lion.',
      ),
    ],
  ),
  StoryItem(
    title: 'The Tortoise and the Hare',
    coverEmoji: '🐢🐇',
    subtitle: 'A slow racer never gives up',
    moral: 'Slow and steady wins the race.',
    pages: [
      StoryPageItem(
        emoji: '🐇😄🐢',
        text: 'A proud hare laughed at a tortoise for walking slowly.',
      ),
      StoryPageItem(
        emoji: '🏁🐢🐇',
        text: 'The tortoise challenged the hare to a race.',
      ),
      StoryPageItem(
        emoji: '🐇💨',
        text: 'The hare ran very fast and went far ahead.',
      ),
      StoryPageItem(
        emoji: '🐇🌳😴',
        text: 'The hare felt confident and stopped under a tree to sleep.',
      ),
      StoryPageItem(
        emoji: '🐢➡️🏁',
        text: 'The tortoise kept walking slowly without stopping.',
      ),
      StoryPageItem(
        emoji: '🐢🏆🐇',
        text: 'The tortoise crossed the finish line before the hare woke up.',
      ),
    ],
  ),
  StoryItem(
    title: 'The Honest Woodcutter',
    coverEmoji: '🪓🧔',
    subtitle: 'An honest man receives a reward',
    moral: 'Honesty is the best policy.',
    pages: [
      StoryPageItem(
        emoji: '🧔🪓🌳',
        text: 'A poor woodcutter worked near a river every day.',
      ),
      StoryPageItem(
        emoji: '🪓💦',
        text: 'One day, his iron axe fell into the deep river.',
      ),
      StoryPageItem(
        emoji: '🧔😢',
        text: 'The woodcutter became sad because he could not buy another axe.',
      ),
      StoryPageItem(
        emoji: '✨🥇🪓',
        text:
            'A kind helper showed him a golden axe, but he said it was not his.',
      ),
      StoryPageItem(
        emoji: '✨🥈🪓',
        text:
            'The helper showed him a silver axe, but he again told the truth.',
      ),
      StoryPageItem(
        emoji: '🧔🪓🎁',
        text:
            'The helper returned his iron axe and rewarded him for being honest.',
      ),
    ],
  ),
  StoryItem(
    title: 'The Boy Who Cried Wolf',
    coverEmoji: '👦🐺',
    subtitle: 'A lesson about telling the truth',
    moral: 'People may not believe a person who often lies.',
    pages: [
      StoryPageItem(
        emoji: '👦🐑',
        text: 'A young boy looked after sheep near his village.',
      ),
      StoryPageItem(
        emoji: '👦📣🐺',
        text: 'For fun, he shouted that a wolf was attacking the sheep.',
      ),
      StoryPageItem(
        emoji: '🏃‍♂️🏃‍♀️',
        text: 'The villagers ran to help, but there was no wolf.',
      ),
      StoryPageItem(
        emoji: '👦😂',
        text: 'The boy laughed and played the same trick again.',
      ),
      StoryPageItem(
        emoji: '🐺🐑',
        text: 'Later, a real wolf came near the sheep.',
      ),
      StoryPageItem(
        emoji: '👦📣😢',
        text: 'The boy called for help, but no one believed him.',
      ),
    ],
  ),
  StoryItem(
    title: 'The Ant and the Dove',
    coverEmoji: '🐜🕊️',
    subtitle: 'Two friends help each other',
    moral: 'A good deed is always returned.',
    pages: [
      StoryPageItem(
        emoji: '🐜💧',
        text: 'A little ant fell into a stream and struggled in the water.',
      ),
      StoryPageItem(
        emoji: '🕊️🍃',
        text: 'A dove saw the ant and dropped a leaf into the stream.',
      ),
      StoryPageItem(
        emoji: '🐜🍃',
        text: 'The ant climbed onto the leaf and reached the shore safely.',
      ),
      StoryPageItem(emoji: '🏹🕊️', text: 'Later, a hunter aimed at the dove.'),
      StoryPageItem(
        emoji: '🐜🦶',
        text: 'The ant bit the hunter’s foot before he could shoot.',
      ),
      StoryPageItem(
        emoji: '🕊️💨🐜',
        text: 'The dove flew away, and both friends were safe.',
      ),
    ],
  ),
];
