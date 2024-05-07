import 'dart:math';

String formatAmountFromInt(int number) {
  String stringNumber = number.toString();
  String numberCorrect = "";

  if (stringNumber.length == 4) {
    numberCorrect = stringNumber[0] + " " + stringNumber.substring(1, 4);
  } else if (stringNumber.length == 5) {
    numberCorrect =
        stringNumber.substring(0, 2) + " " + stringNumber.substring(2, 5);
  } else if (stringNumber.length == 6) {
    numberCorrect =
        stringNumber.substring(0, 3) + " " + stringNumber.substring(3, 6);
  } else if (stringNumber.length == 7) {
    numberCorrect = stringNumber[0] +
        " " +
        stringNumber.substring(1, 4) +
        " " +
        stringNumber.substring(4, 7);
  } else if (stringNumber.length == 8) {
    numberCorrect = stringNumber.substring(0, 2) +
        " " +
        stringNumber.substring(2, 5) +
        " " +
        stringNumber.substring(5, 8);
  }
  return numberCorrect + ",00";
}

String formatAmountFromDouble(double number) {
  number = (number * pow(10, 2)).round().toDouble() / pow(10, 2);
  int x = number.toInt();
  int? y =
      int.tryParse(number.toString().split('.')[1]); //parte dopo la virgola

  String stringX = x.toString();
  String numberCorrect = "";

  if (stringX.length == 4) {
    numberCorrect = stringX[0] + " " + stringX.substring(1, 4);
  } else if (stringX.length == 5) {
    numberCorrect = stringX.substring(0, 2) + " " + stringX.substring(2, 5);
  } else if (stringX.length == 6) {
    numberCorrect = stringX.substring(0, 3) + " " + stringX.substring(3, 6);
  } else if (stringX.length == 7) {
    numberCorrect = stringX[0] +
        " " +
        stringX.substring(1, 4) +
        " " +
        stringX.substring(4, 7);
  } else if (stringX.length == 8) {
    numberCorrect = stringX.substring(0, 2) +
        " " +
        stringX.substring(2, 5) +
        " " +
        stringX.substring(5, 8);
  } else {
    numberCorrect = stringX;
  }

  if (y == 0) {
    return numberCorrect + "," + '00';
  } else if (y! / 10 < 1) {
    y = y * 10;
    return numberCorrect + "," + y.toString();
  } else {
    return numberCorrect + "," + y.toString();
  }
}

double customDoubleParser(dynamic value) {
  if (value is int) {
    return value.toDouble();
  } else if (value is double) {
    return value;
  } else {
    throw ArgumentError('Il valore fornito non è né un int né un double.');
  }
}
