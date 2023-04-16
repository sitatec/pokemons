extension StringUtils on String {
  String toCapitalized() {
    if (trim().isEmpty) return "";
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}
