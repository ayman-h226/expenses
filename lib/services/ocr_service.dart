// services/ocr_service.dart

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'dart:io';

class OcrService {
  final TextRecognizer textRecognizer = TextRecognizer();

  Future<String> scanTextFromImage(File imageFile) async {
    try {
      final InputImage inputImage = InputImage.fromFile(imageFile);
      final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

      String scannedText = '';
      for (TextBlock block in recognizedText.blocks) {
        for (TextLine line in block.lines) {
          scannedText += line.text + '\n';
        }
      }
      return scannedText;
    } catch (e) {
      return 'Erreur lors de la reconnaissance de texte : $e';
    }
  }

  void dispose() {
    textRecognizer.close();
  }
}
