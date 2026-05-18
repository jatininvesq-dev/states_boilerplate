import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:provider/provider.dart';
import 'package:states_app/features/authentication/face/camera_permission_utils.dart';
import 'package:states_app/features/authentication/face/face_embedding_service.dart';
import 'package:states_app/features/authentication/provider/auth_provider.dart';

class FaceRegistrationDialog extends StatefulWidget {
  const FaceRegistrationDialog({super.key});

  @override
  State<FaceRegistrationDialog> createState() => _FaceRegistrationDialogState();
}

class _FaceRegistrationDialogState extends State<FaceRegistrationDialog> {
  CameraController? _cameraController;
  final FaceEmbeddingService _embeddingService = FaceEmbeddingService();

  bool _isInitializing = true;
  bool _isCapturing = false;
  String? _statusMessage;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    if (!CameraPermissionUtils.isSupportedPlatform) {
      if (!mounted) return;
      setState(() {
        _isInitializing = false;
        _errorMessage =
            'Face registration requires an Android or iOS device. '
            'Run the app on a phone or emulator, not Windows/Web.';
      });
      return;
    }

    try {
      final cameras = await availableCameras();
      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      final controller = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: Platform.isAndroid
            ? ImageFormatGroup.jpeg
            : ImageFormatGroup.bgra8888,
      );

      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }

      setState(() {
        _cameraController = controller;
        _isInitializing = false;
        _statusMessage = 'Center your face in the frame, then tap Capture';
      });
    } on CameraException catch (e) {
      if (!mounted) return;
      setState(() {
        _isInitializing = false;
        _errorMessage = _cameraErrorMessage(e);
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isInitializing = false;
        _errorMessage = 'Unable to open camera. Please try again.';
      });
    }
  }

  String _cameraErrorMessage(CameraException e) {
    switch (e.code) {
      case 'CameraAccessDenied':
      case 'CameraAccessDeniedWithoutPrompt':
        return 'Camera permission denied. Enable camera access in app settings.';
      case 'CameraAccessRestricted':
        return 'Camera access is restricted on this device.';
      default:
        return 'Unable to open camera: ${e.description ?? e.code}';
    }
  }

  Future<void> _captureAndRegister() async {
    final controller = _cameraController;
    if (controller == null || !controller.value.isInitialized || _isCapturing) {
      return;
    }

    setState(() {
      _isCapturing = true;
      _statusMessage = 'Capturing face...';
      _errorMessage = null;
    });

    try {
      final photo = await controller.takePicture();
      final bytes = await File(photo.path).readAsBytes();
      final decoded = img.decodeImage(bytes);

      if (decoded == null) {
        throw const FormatException('Could not process captured image');
      }

      if (!_embeddingService.hasValidFaceRegion(decoded)) {
        if (!mounted) return;
        setState(() {
          _isCapturing = false;
          _statusMessage = 'Center your face in the frame, then tap Capture';
          _errorMessage =
              'Could not detect a clear face. Ensure good lighting and look at the camera.';
        });
        return;
      }

      if (!mounted) return;
      setState(() {
        _statusMessage = 'Registering face...';
      });

      final embedding = _embeddingService.generateEmbeddingFromImage(decoded);
      final authProvider = context.read<AuthProvider>();
      final success = await authProvider.registerFace(embedding);

      if (!mounted) return;

      if (success) {
        Navigator.of(context).pop(true);
        return;
      }

      setState(() {
        _isCapturing = false;
        _statusMessage = 'Center your face in the frame, then tap Capture';
        _errorMessage = authProvider.errorMessage ??
            'Face registration failed. Please try again.';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isCapturing = false;
        _statusMessage = 'Center your face in the frame, then tap Capture';
        _errorMessage = 'Face capture failed. Please try again.';
      });
    }
  }

  Future<void> _retry() async {
    setState(() {
      _errorMessage = null;
      _isInitializing = true;
      _isCapturing = false;
      _statusMessage = null;
    });

    await _cameraController?.dispose();
    _cameraController = null;
    await _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canCapture =
        !_isInitializing && _cameraController != null && !_isCapturing;

    return PopScope(
      canPop: false,
      child: Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Register Your Face',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Complete face registration before creating your account.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 280,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _buildCameraPreview(),
                ),
              ),
              const SizedBox(height: 16),
              if (_statusMessage != null)
                Text(
                  _statusMessage!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 8),
                Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                ),
              ],
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: canCapture ? _captureAndRegister : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 64, 14, 150),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isCapturing
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Text('Capture Face'),
                ),
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: _isInitializing ? null : _retry,
                    child: const Text('Retry'),
                  ),
                ),
              ],
              if (_isInitializing)
                const Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCameraPreview() {
    if (_errorMessage != null && _cameraController == null) {
      return Container(
        color: Colors.black12,
        alignment: Alignment.center,
        child: const Icon(Icons.camera_alt_outlined, size: 48),
      );
    }

    if (_isInitializing || _cameraController == null) {
      return Container(
        color: Colors.black12,
        alignment: Alignment.center,
        child: const CircularProgressIndicator(),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        CameraPreview(_cameraController!),
        CustomPaint(painter: _FaceFramePainter()),
      ],
    );
  }
}

class _FaceFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white70
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final rect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: size.width * 0.65,
      height: size.height * 0.75,
    );
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(16));
    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
