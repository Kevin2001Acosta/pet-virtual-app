import 'package:flutter/material.dart';

// Diálogo de Error
void showErrorDialog({
  required BuildContext context,
  required String title,
  required String message,
  String buttonText = 'OK',
}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.warning_amber_rounded,
                color: Color.fromARGB(255, 229, 47, 47)),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                title,
                style: const TextStyle(fontFamily: 'Poppins'),
              ),
            ),
          ],
        ),
      ),
      content: Text(message, style: const TextStyle(fontFamily: 'Poppins')),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(buttonText,
              style: const TextStyle(
                  color: Color.fromARGB(255, 229, 47, 47),
                  fontFamily: 'Poppins')),
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    ),
  );
}

// Diálogo de Éxito
void showSuccessDialog({
  required BuildContext context,
  required String title,
  required String message,
  String buttonText = 'OK',
  VoidCallback? onPressed,
}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_rounded,
                color: Color.fromARGB(255, 46, 229, 47)),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                title,
                style: const TextStyle(fontFamily: 'Poppins'),
              ),
            ),
          ],
        ),
      ),
      content: Text(message, style: const TextStyle(fontFamily: 'Poppins')),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onPressed?.call();
          },
          child: Text(buttonText,
              style: const TextStyle(
                  color: Color.fromARGB(255, 46, 229, 47),
                  fontFamily: 'Poppins')),
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    ),
  );
}

// Diálogo de Información
void showInfoDialog({
  required BuildContext context,
  required String title,
  required String message,
  String buttonText = 'Entendido',
  String? secondaryButtonText, 
  VoidCallback? onPressed,
  VoidCallback? onSecondaryPressed, 
}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.info_rounded,
                color: Color.fromARGB(255, 47, 140, 229)),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                title,
                style: const TextStyle(fontFamily: 'Poppins'),
              ),
            ),
          ],
        ),
      ),
      content: Text(message, style: const TextStyle(fontFamily: 'Poppins')),
      actions: [
        if (secondaryButtonText != null)
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onSecondaryPressed?.call();
            },
            child: Text(
              secondaryButtonText,
              style: const TextStyle(
                color: Colors.red, 
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        // Botón principal
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onPressed?.call();
          },
          child: Text(
            buttonText,
            style: const TextStyle(
              color: Color.fromARGB(255, 47, 140, 229),
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    ),
  );
}



