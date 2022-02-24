extension StringUtils on String {
  String toCapitalized() {
    if (isEmpty) return "";
    return "${this[0]}${substring(1)}";
  }
}
