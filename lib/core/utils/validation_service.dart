class ValidationService {
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'validation.name_required';
    }
    if (value.length < 2) {
      return 'validation.name_min_length';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'validation.email_required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'validation.email_invalid';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'validation.password_required';
    }
    if (value.length < 6) {
      return 'validation.password_min_length';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'validation.password_must_contain_number';
    }
    return null;
  }

  static String? validatePositiveInt(String? value, {int max = 999}) {
    final parsed = int.tryParse(value?.trim() ?? '');
    if (parsed == null || parsed <= 0) {
      return 'validation.invalid_number';
    }
    if (parsed > max) {
      return 'validation.invalid_number';
    }
    return null;
  }
}
