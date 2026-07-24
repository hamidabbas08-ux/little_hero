import 'package:flutter_test/flutter_test.dart';
import 'package:little_hero/features/numbers/data/number_words.dart';

void main() {
  test('generates important number names correctly', () {
    expect(numberToWords(1), 'One');
    expect(numberToWords(19), 'Nineteen');
    expect(numberToWords(20), 'Twenty');
    expect(numberToWords(21), 'Twenty-one');
    expect(numberToWords(40), 'Forty');
    expect(numberToWords(49), 'Forty-nine');
    expect(numberToWords(50), 'Fifty');
    expect(numberToWords(51), 'Fifty-one');
    expect(numberToWords(59), 'Fifty-nine');
    expect(numberToWords(60), 'Sixty');
    expect(numberToWords(80), 'Eighty');
    expect(numberToWords(99), 'Ninety-nine');
    expect(numberToWords(100), 'One hundred');
  });

  test('generates every number from 1 to 100', () {
    for (var number = 1; number <= 100; number++) {
      final words = numberToWords(number);

      expect(words, isNotEmpty, reason: 'Number $number must have a name.');
    }
  });
}
