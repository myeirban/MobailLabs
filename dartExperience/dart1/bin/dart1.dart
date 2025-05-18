Future<String> reverseString(String input) async {
  await Future.delayed(Duration(seconds: 1));
  return input.split('').reversed.join();
}

void main() async {
  String original = 'Dart';
  String reversed = await reverseString(original);
  print('Original: $original');
  print('Reversed: $reversed');
}
