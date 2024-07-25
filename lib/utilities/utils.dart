import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String baseUrl = "https://luxchain-backend.vercel.app/api";
const int maxQuotes = 30;

String formatAmountFromInt(int number) {
  final formatter = NumberFormat.currency(symbol: '€', decimalDigits: 2, locale: 'it_IT');
  return formatter.format(number);
}

String formatAmountFromDouble(double number) {
  final formatter = NumberFormat.currency(symbol: '€', decimalDigits: 2, locale: 'it_IT');
  return formatter.format(number);
}
String formatRawAmountFromDouble(double number) {
  final formatter = NumberFormat.currency(symbol: '', decimalDigits: 2, locale: 'it_IT');
  return formatter.format(number);
}

double parseFormattedStringToDouble(String formattedString) {
  String cleanedString = formattedString.replaceAll('€', '').replaceAll(' ', '').trim();
  cleanedString = cleanedString.replaceAll('.', '');
  cleanedString = cleanedString.replaceAll(',', '.');
  double number = double.parse(cleanedString);
  return number;
}

int parseFormattedStringToInt(String formattedString) {
  String cleanedString = formattedString.replaceAll('€', '').replaceAll(' ', '').trim();
  cleanedString = cleanedString.replaceAll('.', '');
  int number = int.parse(cleanedString);
  return number;
}

double customDoubleParser(num value) {
  if (value is int) {
    return value.toDouble();
  } else if (value is double) {
    return value;
  } else {
    throw ArgumentError('Il valore fornito non è né un int né un double.');
  }
}

double customDoubleParserString(String value) {
  return double.parse(value);
}

Future<SharedPreferences> getUserData() async {
  SharedPreferences user = await SharedPreferences.getInstance();

  return user;
}
