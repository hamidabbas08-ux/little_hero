import 'package:flutter_test/flutter_test.dart';
import 'package:little_hero/features/animals/screens/animal_lesson_screen.dart';
import 'package:little_hero/features/things/screens/everyday_things_screen.dart';

void main() {
  test('contains twenty animals', () {
    expect(animalItems.length, 20);
    expect(animalItems.first.name, 'Lion');
    expect(animalItems.last.name, 'Crocodile');
  });

  test('contains twenty everyday things', () {
    expect(everydayThings.length, 20);
    expect(everydayThings.first.name, 'Table');
    expect(everydayThings.last.name, 'Bicycle');
  });
}
