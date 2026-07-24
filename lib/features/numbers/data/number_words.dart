String numberToWords(int number) {
  if (number < 0 || number > 100) {
    throw RangeError.range(number, 0, 100, 'number');
  }

  const ones = <String>[
    'Zero',
    'One',
    'Two',
    'Three',
    'Four',
    'Five',
    'Six',
    'Seven',
    'Eight',
    'Nine',
    'Ten',
    'Eleven',
    'Twelve',
    'Thirteen',
    'Fourteen',
    'Fifteen',
    'Sixteen',
    'Seventeen',
    'Eighteen',
    'Nineteen',
  ];

  const tens = <String>[
    '',
    '',
    'Twenty',
    'Thirty',
    'Forty',
    'Fifty',
    'Sixty',
    'Seventy',
    'Eighty',
    'Ninety',
  ];

  if (number < 20) {
    return ones[number];
  }

  if (number == 100) {
    return 'One hundred';
  }

  final tensDigit = number ~/ 10;
  final onesDigit = number % 10;

  if (onesDigit == 0) {
    return tens[tensDigit];
  }

  return '${tens[tensDigit]}-${ones[onesDigit].toLowerCase()}';
}
