import 'package:intl/intl.dart';

var formatter = NumberFormat("# ###0,00", "it_IT");

double customDoubleParser(dynamic value) {
  if (value is int) {
    return value.toDouble();
  } else if (value is double) {
    return value;
  } else {
    throw ArgumentError('Il valore fornito non è né un int né un double.');
  }
}