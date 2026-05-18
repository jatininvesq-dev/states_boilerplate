import 'dart:math' as math;
import 'dart:typed_data';

import 'package:image/image.dart' as img;

/// Builds a fixed-size 128-dimensional embedding from a face photo.
class FaceEmbeddingService {
  static const int embeddingSize = 128;

  List<double> generateEmbeddingFromBytes(Uint8List imageBytes) {
    final decoded = img.decodeImage(imageBytes);
    if (decoded == null) {
      throw const FormatException('Could not decode face image');
    }
    return generateEmbeddingFromImage(decoded);
  }

  List<double> generateEmbeddingFromImage(img.Image image) {
    final resized = img.copyResize(
      image,
      width: 16,
      height: 8,
      interpolation: img.Interpolation.linear,
    );
    final gray = img.grayscale(resized);

    final features = <double>[];
    for (var y = 0; y < gray.height; y++) {
      for (var x = 0; x < gray.width; x++) {
        final pixel = gray.getPixel(x, y);
        features.add(img.getLuminance(pixel) / 255.0);
      }
    }

    return _normalize(features);
  }

  bool hasValidFaceRegion(img.Image image) {
    final width = image.width;
    final height = image.height;
    if (width < 40 || height < 40) return false;

    final crop = img.copyCrop(
      image,
      x: width ~/ 4,
      y: height ~/ 4,
      width: width ~/ 2,
      height: height ~/ 2,
    );

    final gray = img.grayscale(crop);
    final luminanceValues = <double>[];

    for (var y = 0; y < gray.height; y++) {
      for (var x = 0; x < gray.width; x++) {
        luminanceValues.add(img.getLuminance(gray.getPixel(x, y)) / 255.0);
      }
    }

    if (luminanceValues.isEmpty) return false;

    final mean =
        luminanceValues.reduce((a, b) => a + b) / luminanceValues.length;
    var variance = 0.0;
    for (final value in luminanceValues) {
      final diff = value - mean;
      variance += diff * diff;
    }
    variance /= luminanceValues.length;

    return variance > 0.008 && mean > 0.12 && mean < 0.92;
  }

  List<double> _normalize(List<double> vector) {
    var sumSquares = 0.0;
    for (final value in vector) {
      sumSquares += value * value;
    }
    final magnitude = math.sqrt(sumSquares);
    if (magnitude == 0) return vector;
    return vector.map((value) => value / magnitude).toList();
  }
}
