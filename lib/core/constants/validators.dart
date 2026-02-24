class Validators {
  static String? validateName(String hint, String value) {
    if (value.isEmpty || value == null) {
      return "$hint is required";
    }

    return null;
  }
}
