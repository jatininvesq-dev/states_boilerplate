class OcrService {
  /*  Future<Either<ErrorDataModel, FetchedRecieptDataModel>> extractReceiptData(
    File file,
  ) async {
    final String path = file.path.toLowerCase();
    final bool isImage =
        path.endsWith('.jpg') ||
        path.endsWith('.jpeg') ||
        path.endsWith('.png') ||
        path.endsWith('.webp');
    final bool isPdf = path.endsWith('.pdf');
    final bool isDoc = path.endsWith('.doc') || path.endsWith('.docx');

    if (!isImage && !isPdf && !isDoc) {
      return Left(
        ErrorDataModel(
          message:
              'Unsupported file type. Allowed: jpg, jpeg, png, webp, pdf, doc, docx.',
        ),
      );
    }

    if (isPdf) return _extractFromPdf(file);
    if (isDoc) return _extractFromDoc(file);

    if (kIsWeb || !(Platform.isAndroid || Platform.isIOS)) {
      return Left(
        ErrorDataModel(
          message:
              'Local OCR is available only on Android/iOS. Please enable "with API" on this platform.',
        ),
      );
    }

    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
    try {
      final inputImage = InputImage.fromFilePath(file.path);
      final RecognizedText recognizedText = await textRecognizer.processImage(
        inputImage,
      );
      return Right(_mapRecognizedText(recognizedText.text));
    } on MissingPluginException {
      return Left(
        ErrorDataModel(
          message:
              'OCR plugin is not initialized on this build. Please restart app or use "with API".',
        ),
      );
    } catch (e) {
      return Left(ErrorDataModel(message: 'OCR failed: ${e.toString()}'));
    } finally {
      try {
        await textRecognizer.close();
      } catch (_) {
        // Ignore close failures for unsupported/plugin-missing builds.
      }
    }
  }

  Future<Either<ErrorDataModel, FetchedRecieptDataModel>> _extractFromPdf(
    File file,
  ) async {
    try {
      final PDFDoc pdfDoc = await PDFDoc.fromPath(file.path);
      final String text = (await pdfDoc.text).trim();
      if (text.isNotEmpty) return Right(_mapRecognizedText(text));

      // Fallback to doc_text_extractor for scanned/complex PDFs.
      final extractor = TextExtractor();
      final dynamic result = await extractor.extractText(file.path, isUrl: false);
      final String extracted = _textFromExtractorResult(result);
      if (extracted.isEmpty) {
        return Left(ErrorDataModel(message: 'No readable text found in PDF document.'));
      }
      return Right(_mapRecognizedText(extracted));
    } catch (e) {
      return Left(ErrorDataModel(message: 'PDF extraction failed: ${e.toString()}'));
    }
  }

  Future<Either<ErrorDataModel, FetchedRecieptDataModel>> _extractFromDoc(
    File file,
  ) async {
    try {
      final extractor = TextExtractor();
      final dynamic result = await extractor.extractText(file.path, isUrl: false);
      final String extracted = _textFromExtractorResult(result);
      if (extracted.isEmpty) {
        return Left(
          ErrorDataModel(
            message: 'No readable text found in document file.',
          ),
        );
      }
      return Right(_mapRecognizedText(extracted));
    } catch (e) {
      return Left(
        ErrorDataModel(message: 'Document extraction failed: ${e.toString()}'),
      );
    }
  }

  String _textFromExtractorResult(dynamic result) {
    if (result is Map) {
      final dynamic text = result['text'];
      if (text is String) return text.trim();
    }
    if (result is String) return result.trim();
    return '';
  }

  FetchedRecieptDataModel _mapRecognizedText(String rawText) {
    final String cleaned = rawText.trim();
    final lines = cleaned
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final String? date = _findFirstMatch(cleaned, [
      RegExp(r'\b\d{4}[-/]\d{1,2}[-/]\d{1,2}\b'),
      RegExp(r'\b\d{1,2}[-/]\d{1,2}[-/]\d{2,4}\b'),
    ]);

    final String? currency = _findFirstMatch(cleaned, [
      RegExp(r'\b(AED|USD|EUR|GBP|INR|SAR|QAR|OMR|KWD)\b', caseSensitive: false),
    ])?.toUpperCase();

    final double? total = _extractAmountByLabel(cleaned, 'total') ??
        _extractLastAmount(cleaned);
    final double? vat = _extractAmountByLabel(cleaned, 'vat') ??
        _extractAmountByLabel(cleaned, 'tax');
    final double? subtotal = _extractAmountByLabel(cleaned, 'subtotal');

    return FetchedRecieptDataModel(
      name: lines.isNotEmpty ? lines.first : null,
      description: lines.length > 1 ? lines[1] : null,
      date: date,
      currency: currency,
      total: total,
      vat: vat,
      subtotal: subtotal?.toInt(),
    );
  }

  String? _findFirstMatch(String text, List<RegExp> patterns) {
    for (final pattern in patterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        return match.group(0);
      }
    }
    return null;
  }

  double? _extractAmountByLabel(String text, String label) {
    final regex = RegExp(
      '$label\\s*[:\\-]?\\s*(?:[A-Za-z]{3}\\s*)?([0-9]+(?:\\.[0-9]{1,2})?)',
      caseSensitive: false,
    );
    final match = regex.firstMatch(text);
    if (match == null) return null;
    return double.tryParse(match.group(1) ?? '');
  }

  double? _extractLastAmount(String text) {
    final regex = RegExp(r'([0-9]+(?:\.[0-9]{1,2})?)');
    final matches = regex.allMatches(text).toList();
    if (matches.isEmpty) return null;
    return double.tryParse(matches.last.group(1) ?? '');
  }

*/
}
