import 'package:flutter/services.dart';

class RfidInputFormatter extends TextInputFormatter {
  // formato: 3 dígitos + '-' + 15 dígitos  => total 19 caracteres incluindo '-'
  static const int firstDigits = 3;
  static const int tailDigits = 15;
  static final int maxDigits = firstDigits + tailDigits;

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    // removendo tudo que não é dígito
    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    var truncated = digitsOnly;
    if (truncated.length > maxDigits) truncated = truncated.substring(0, maxDigits);

    StringBuffer buffer = StringBuffer();
    for (int i = 0; i < truncated.length; i++) {
      if (i == firstDigits) buffer.write('-');
      buffer.write(truncated[i]);
    }
    final formatted = buffer.toString();
    // calcular novo selection
    int selectionIndex = formatted.length;
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
