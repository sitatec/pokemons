import 'package:flutter_test/flutter_test.dart';
import 'package:podedex/domain/data_sources/utils/string_utils.dart';

void main() {
  test("It should capitalize the string", () {
    expect("sita".toCapitalized(), "Sita");
  });

  test("It should capitalize only the first word", () {
    expect("sita berete".toCapitalized(), "Sita berete");
  });

  test("It should return an empty string when the initial string is empty", () {
    expect("".toCapitalized(), "");
  });

  test(
      "It should return an empty string when the initial string contians only whit spaces",
      () {
    expect("   \n\t".toCapitalized(), "");
  });
}
