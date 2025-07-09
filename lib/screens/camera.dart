import 'dart:io';
import 'package:ecoscan/screens/specie_info.dart';
import 'package:ecoscan/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:blur/blur.dart';
import 'package:ecoscan/data/species.dart';

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
    try {
      _cameras = await availableCameras();
      if (_cameras == null || _cameras!.isEmpty) {
        setState(() {
          _controller = null;
        });
        return;
      }
      _controller = CameraController(
        _cameras![_cameraIndex],
        ResolutionPreset.high,
      );
      await _controller!.initialize();
      setState(() {});
    } catch (e) {
      setState(() {
        _controller = null;
      });
    }
  }

  void _toggleCamera() async {
    if (_cameras == null || _cameras!.length < 2) return;
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
    if (_controller == null) return;
    _flashOn = !_flashOn;
    await _controller?.setFlashMode(_flashOn ? FlashMode.torch : FlashMode.off);
    setState(() {});
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
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

    // Simula el reconocimiento, pero navega a SpecieInfoScreen con datos dummy
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => SpecieInfoScreen(
              species: Species(
                nombreComun: 'Mono capuchino',
                nombreCientifico: 'Cebus capucinus',
                peligroso: false,
                razon: '',
                peso: '1.7kg - 4.7kg',
                longitud: '35cm - 50cm',
                origen: 'Nativa',
                tipo: 'fauna',
                clasificacion: 'mamífero',
                descripcion:
                    'En Ciudad Guayana, el mono capuchino, conocido localmente como "mono maicero" o "mono chuco", es un primate pequeño y ágil con pelaje que varía entre tonos crema y canela, especialmente en la cara, cuello y hombros. Son omnívoros, adaptándose a una dieta diversa que incluye frutas, nueces, insectos y pequeños vertebrados. Suelen vivir en grupos sociales y son conocidos por su inteligencia y habilidad para usar herramientas.',
              ),
            ),
      ),
    );
    // Al regresar, vuelve a la cámara en modo preview
    setState(() {
      _state = CameraState.preview;
      _imageFile = null;
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
    double? size,
  }) {
    final width = MediaQuery.of(context).size.width;
    final btnSize = size ?? (width < 360 ? 40 : (width > 600 ? 72 : 56));
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(btnSize / 2),
        child: Container(
          width: btnSize,
          height: btnSize,
          decoration: BoxDecoration(
            color: colorsWhite.withOpacity(0.18),
            borderRadius: BorderRadius.circular(btnSize / 2),
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
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final isSmall = width < 360;
    final isLarge = width > 600;
    double topPad = isSmall ? 12 : (isLarge ? 36 : 24);
    double sidePad = isSmall ? 8 : (isLarge ? 32 : 16);
    double bottomPad = isSmall ? 12 : (isLarge ? 36 : 24);
    double iconSize = isSmall ? 20 : (isLarge ? 40 : 32);
    double sendBtnSize = isSmall ? 40 : (isLarge ? 72 : 56);
    double progressFontSize = isSmall ? 14 : (isLarge ? 22 : 18);
    double progressBox = isSmall ? 100 : (isLarge ? 220 : 160);

    Widget content;

    if (_state == CameraState.preview) {
      content = Stack(
        children: [
          if (_controller != null && _controller!.value.isInitialized)
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller!.value.previewSize?.height ?? 1,
                  height: _controller!.value.previewSize?.width ?? 1,
                  child: CameraPreview(_controller!),
                ),
              ),
            ),
          if (_controller == null || !_controller!.value.isInitialized)
            Center(
              child: Text(
                'Cámara no disponible',
                style: TextStyle(color: Colors.black54, fontSize: 18),
              ),
            ),
          // Flash button
          Positioned(
            top: topPad,
            left: sidePad,
            child: _glassButton(
              child: Icon(
                _flashOn ? Icons.flash_on : Icons.flash_off,
                color: colorsWhite,
                size: iconSize,
              ),
              onTap: _toggleFlash,
            ),
          ),
          // Gallery button
          Positioned(
            bottom: bottomPad + 8,
            left: sidePad + 8,
            child: _glassButton(
              child:
                  _imageFile != null
                      ? ClipOval(
                        child: Image.file(
                          File(_imageFile!.path),
                          width: iconSize + 8,
                          height: iconSize + 8,
                          fit: BoxFit.cover,
                        ),
                      )
                      : Icon(Icons.image, color: colorsWhite, size: iconSize),
              onTap: _pickFromGallery,
            ),
          ),
          // Take picture button
          Positioned(
            bottom: bottomPad,
            left: 0,
            right: 0,
            child: Center(
              child: _glassButton(
                child: Icon(
                  Icons.camera_alt,
                  color: colorsWhite,
                  size: iconSize + 8,
                ),
                onTap: _takePicture,
                size: iconSize + 32,
              ),
            ),
          ),
          // Switch camera button
          Positioned(
            bottom: bottomPad + 8,
            right: sidePad + 8,
            child: _glassButton(
              child: Icon(
                Icons.cameraswitch,
                color: colorsWhite,
                size: iconSize,
              ),
              onTap: _toggleCamera,
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
            top: topPad,
            left: sidePad,
            child: _glassButton(
              child: Icon(Icons.arrow_back, color: colorsWhite, size: iconSize),
              onTap: _retake,
            ),
          ),
          // Send button
          Positioned(
            bottom: bottomPad,
            right: sidePad,
            child: _glassButton(
              child: Icon(Icons.send, color: colorsWhite, size: iconSize),
              onTap: _sendImage,
              size: sendBtnSize,
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
                width: progressBox,
                height: progressBox,
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
                        strokeWidth: isSmall ? 4 : 6,
                      ),
                      SizedBox(height: 24),
                      Text(
                        "Reconociendo...",
                        style: TextStyle(
                          color: colorsWhite,
                          fontSize: progressFontSize,
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
