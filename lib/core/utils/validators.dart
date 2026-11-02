enum PasswordStrength {
  weak,
  medium,
  strong,
}

class PasswordCriteriaState {
  final bool hasMinLength;
  final bool hasUppercase;
  final bool hasLowercase;
  final bool hasDigit;
  final bool hasSpecialChar;

  const PasswordCriteriaState({
    required this.hasMinLength,
    required this.hasUppercase,
    required this.hasLowercase,
    required this.hasDigit,
    required this.hasSpecialChar,
  });

  int get metCount {
    var count = 0;
    if (hasMinLength) count++;
    if (hasUppercase) count++;
    if (hasLowercase) count++;
    if (hasDigit) count++;
    if (hasSpecialChar) count++;
    return count;
  }

  PasswordStrength get strength {
    final count = metCount;
    if (count <= 2) {
      return PasswordStrength.weak;
    } else if (count <= 4) {
      return PasswordStrength.medium;
    } else {
      return PasswordStrength.strong;
    }
  }

  String get strengthLabel {
    switch (strength) {
      case PasswordStrength.weak:
        return 'Weak';
      case PasswordStrength.medium:
        return 'Medium';
      case PasswordStrength.strong:
        return 'Strong';
    }
  }
}

class Validators {
  const Validators._();

  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static final RegExp _mobile10DigitsRegExp = RegExp(
    r'^[0-9]{10}$',
  );

  static final RegExp _mobileWithCountryCodeRegExp = RegExp(
    r'^\+[0-9]{11}$',
  );

  static final RegExp _lettersOnlyRegExp = RegExp(
    r'^[a-zA-Z\s]+$',
  );

  static final RegExp _hasUppercase = RegExp(r'[A-Z]');
  static final RegExp _hasLowercase = RegExp(r'[a-z]');
  static final RegExp _hasDigit = RegExp(r'[0-9]');
  static final RegExp _hasSpecialChar = RegExp(r'[^a-zA-Z0-9\s]');

  static bool hasMinLength(String value, [int min = 8]) => value.length >= min;
  static bool hasUppercase(String value) => _hasUppercase.hasMatch(value);
  static bool hasLowercase(String value) => _hasLowercase.hasMatch(value);
  static bool hasDigit(String value) => _hasDigit.hasMatch(value);
  static bool hasSpecialChar(String value) => _hasSpecialChar.hasMatch(value);

  static PasswordCriteriaState checkPasswordCriteria(String value) {
    return PasswordCriteriaState(
      hasMinLength: hasMinLength(value),
      hasUppercase: hasUppercase(value),
      hasLowercase: hasLowercase(value),
      hasDigit: hasDigit(value),
      hasSpecialChar: hasSpecialChar(value),
    );
  }

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    final trimmed = value.trim();
    final lettersOnly = trimmed.replaceAll(RegExp(r'\s+'), '');
    if (lettersOnly.length < 3 || !_lettersOnlyRegExp.hasMatch(trimmed)) {
      return 'Name must have at least 3 letters (letters only)';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final trimmed = value.trim();
    if (!_emailRegExp.hasMatch(trimmed)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? validateMobile(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Mobile number is required';
    }
    final trimmed = value.trim();
    if (trimmed.startsWith('+')) {
      if (!_mobileWithCountryCodeRegExp.hasMatch(trimmed)) {
        return 'Mobile number with country code must have 11 digits (e.g. +94700000327)';
      }
      return null;
    }
    if (!_mobile10DigitsRegExp.hasMatch(trimmed)) {
      return 'Mobile number must be 10 digits';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (!_hasUppercase.hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!_hasLowercase.hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!_hasDigit.hasMatch(value)) {
      return 'Password must contain at least one digit';
    }
    if (!_hasSpecialChar.hasMatch(value)) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? validateLoginIdentifier(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email or mobile number is required';
    }
    final trimmed = value.trim();
    final isEmail = _emailRegExp.hasMatch(trimmed);
    final isMobileNum = isMobile(trimmed);
    if (!isEmail && !isMobileNum) {
      return 'Enter a valid email or mobile number';
    }
    return null;
  }

  static bool isEmail(String value) => _emailRegExp.hasMatch(value.trim());
  static bool isMobile(String value) {
    final trimmed = value.trim();
    return _mobile10DigitsRegExp.hasMatch(trimmed) ||
        _mobileWithCountryCodeRegExp.hasMatch(trimmed);
  }
}

