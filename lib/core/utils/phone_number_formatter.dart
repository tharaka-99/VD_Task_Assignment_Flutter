import 'package:flutter/services.dart';

class PhoneNumberTextInputFormatter extends TextInputFormatter {
  const PhoneNumberTextInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;
    if (text.isEmpty) {
      return newValue;
    }

    final startsWithPlus = text.startsWith('+');
    final buffer = StringBuffer();
    if (startsWithPlus) {
      buffer.write('+');
    }

    for (int i = (startsWithPlus ? 1 : 0); i < text.length; i++) {
      final char = text[i];
      if (char.codeUnitAt(0) >= 48 && char.codeUnitAt(0) <= 57) {
        buffer.write(char);
      }
    }

    final filtered = buffer.toString();
    // With country code '+': 12 chars (+ and 11 digits, e.g. +94700000327)
    // Without '+': 10 chars (10 digits, e.g. 0771234567)
    final maxLen = startsWithPlus ? 12 : 10;
    final truncated =
        filtered.length > maxLen ? filtered.substring(0, maxLen) : filtered;

    int validCharsBeforeCursor = 0;
    final selectionIndex = newValue.selection.end;
    if (startsWithPlus && selectionIndex > 0) {
      validCharsBeforeCursor++;
    }
    for (int i = (startsWithPlus ? 1 : 0);
        i < selectionIndex && i < text.length;
        i++) {
      final char = text[i];
      if (char.codeUnitAt(0) >= 48 && char.codeUnitAt(0) <= 57) {
        validCharsBeforeCursor++;
      }
    }
    if (validCharsBeforeCursor > truncated.length) {
      validCharsBeforeCursor = truncated.length;
    }

    return TextEditingValue(
      text: truncated,
      selection: TextSelection.collapsed(offset: validCharsBeforeCursor),
    );
  }
}

