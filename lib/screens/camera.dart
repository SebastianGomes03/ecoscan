import 'dart:io';
import 'package:ecoscan/screens/specie_info.dart';
import 'package:ecoscan/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:blur/blur.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

enum CameraState { preview, taken, loading }

class _CameraScreenState extends State<CameraScreen>
    with TickerProviderStateMixin {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  int _cameraIndex = 0;
  XFile? _imageFile;
  CameraState _state = CameraState.preview;
  bool _flashOn = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    _controller = CameraController(
      _cameras![_cameraIndex],
      ResolutionPreset.high,
    );
    await _controller!.initialize();
    setState(() {});
  }

  void _toggleCamera() async {
    _cameraIndex = (_cameraIndex + 1) % _cameras!.length;
    await _controller?.dispose();
    _controller = CameraController(
      _cameras![_cameraIndex],
      ResolutionPreset.high,
    );
    await _controller!.initialize();
    setState(() {});
  }

  void _toggleFlash() async {
    _flashOn = !_flashOn;
    await _controller?.setFlashMode(_flashOn ? FlashMode.torch : FlashMode.off);
    setState(() {});
  }

  Future<void> _takePicture() async {
    if (!_controller!.value.isInitialized) return;
    final image = await _controller!.takePicture();
    setState(() {
      _imageFile = image;
      _state = CameraState.taken;
    });
  }

  Future<void> _pickFromGallery() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imageFile = XFile(picked.path);
        _state = CameraState.taken;
      });
    }
  }

  void _sendImage() async {
    setState(() {
      _state = CameraState.loading;
    });

    // Simula un "reconocimiento" con un pequeño delay
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => SpecieInfoScreen(
              imageUrl: 'assets/images/mammal.png',
              name: 'Mono capuchino',
              scientificName: 'Cebus capucinus',
              description:
                  'En Ciudad Guayana, el mono capuchino, conocido localmente como "mono maicero" o "mono chuco", es un primate pequeño y ágil con pelaje que varía entre tonos crema y canela, especialmente en la cara, cuello y hombros. Son omnívoros, adaptándose a una dieta diversa que incluye frutas, nueces, insectos y pequeños vertebrados. Suelen vivir en grupos sociales y son conocidos por su inteligencia y habilidad para usar herramientas.',
              dataCards: [
                {'label': 'Peso', 'value': '1.7kg - 4.7kg'},
                {'label': 'Longitud', 'value': '35cm - 50cm'},
                {'label': 'Origen', 'value': 'Nativa'},
                {'label': 'Amenaza', 'value': 'No peligroso'},
              ],
            ),
      ),
    ).then((_) {
      // Al regresar, vuelve a la cámara en modo preview
      setState(() {
        _state = CameraState.preview;
        _imageFile = null;
      });
    });
  }

  void _retake() {
    setState(() {
      _imageFile = null;
      _state = CameraState.preview;
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Widget _glassButton({
    required Widget child,
    required VoidCallback onTap,
    double size = 56,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: colorsWhite.withOpacity(0.18),
            borderRadius: BorderRadius.circular(size / 2),
            border: Border.all(color: colorsWhite.withOpacity(0.3), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: colorsWhite.withOpacity(0.08),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Center(child: child),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content;

    if (_state == CameraState.preview) {
      content = Stack(
        children: [
          if (_controller != null && _controller!.value.isInitialized)
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller!.value.previewSize!.height,
                  height: _controller!.value.previewSize!.width,
                  child: CameraPreview(_controller!),
                ),
              ),
            ),
          // Flash button
          Positioned(
            top: 24,
            left: 16,
            child: _glassButton(
              child: Icon(
                _flashOn ? Icons.flash_on : Icons.flash_off,
                color: colorsWhite,
              ),
              onTap: _toggleFlash,
              size: 48,
            ),
          ),
          // Gallery button
          Positioned(
            bottom: 32,
            left: 24,
            child: _glassButton(
              child:
                  _imageFile != null
                      ? ClipOval(
                        child: Image.file(
                          File(_imageFile!.path),
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        ),
                      )
                      : Icon(Icons.image, color: colorsWhite),
              onTap: _pickFromGallery,
              size: 48,
            ),
          ),
          // Take picture button
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Center(
              child: _glassButton(
                child: Icon(Icons.camera_alt, color: colorsWhite, size: 32),
                onTap: _takePicture,
                size: 72,
              ),
            ),
          ),
          // Switch camera button
          Positioned(
            bottom: 32,
            right: 24,
            child: _glassButton(
              child: Icon(Icons.cameraswitch, color: colorsWhite),
              onTap: _toggleCamera,
              size: 48,
            ),
          ),
        ],
      );
    } else if (_state == CameraState.taken && _imageFile != null) {
      content = Stack(
        children: [
          Image.file(
            File(_imageFile!.path),
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          // Back button
          Positioned(
            top: 24,
            left: 16,
            child: _glassButton(
              child: Icon(Icons.arrow_back, color: colorsWhite),
              onTap: _retake,
              size: 48,
            ),
          ),
          // Send button
          Positioned(
            bottom: 32,
            right: 24,
            child: _glassButton(
              child: Icon(Icons.send, color: colorsWhite),
              onTap: _sendImage,
              size: 56,
            ),
          ),
        ],
      );
    } else if (_state == CameraState.loading && _imageFile != null) {
      content = Stack(
        children: [
          Blur(
            blur: 8,
            child: Image.file(
              File(_imageFile!.path),
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  color: colorsWhite.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: colorsWhite.withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(colorsWhite),
                        strokeWidth: 6,
                      ),
                      SizedBox(height: 24),
                      Text(
                        "Reconociendo...",
                        style: TextStyle(
                          color: colorsWhite,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      content = const Center(child: CircularProgressIndicator());
    }

    return Scaffold(backgroundColor: colorsWhite, body: content);
  }
}
