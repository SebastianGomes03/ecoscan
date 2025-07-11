import 'dart:io';
import 'package:ecoscan/screens/specie_info.dart';
import 'package:ecoscan/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:blur/blur.dart';
import 'package:ecoscan/data/species.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart';

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
  late ProcesadorTFLiteOffline _procesadorTFLite;
  bool _modeloListo = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
    _initTFLite();
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

  Future<void> _initTFLite() async {
    _procesadorTFLite = ProcesadorTFLiteOffline();
    await _procesadorTFLite.inicializar();
    setState(() {
      _modeloListo = true;
    });
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

    if (_imageFile == null || !_modeloListo) return;

    try {
      // Procesar imagen localmente con TFLite
      final resultado = await _procesadorTFLite.procesarImagen(
        File(_imageFile!.path),
      );
      final label = resultado['especie'] ?? 'Desconocido';
      final speciesList = await loadSpecies();
      final especieReconocida = speciesList.firstWhere(
        (sp) => normalize(sp.nombreCientifico) == normalize(label),
        orElse:
            () => Species(
              nombreCientifico: 'Desconocido',
              nombreComun: 'Desconocido',
              peligroso: false,
              razon: '',
              peso: '',
              longitud: '',
              origen: '',
              tipo: '',
              clasificacion: '',
              descripcion: 'No se encontró información para esta especie.',
              imagen: '',
            ),
      );

      print('Especie reconocida: $label, confianza: ${resultado['confianza']}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Especie: $label\nConfianza: ${resultado['confianza'].toStringAsFixed(2)}%',
          ),
        ),
      );

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SpecieInfoScreen(species: especieReconocida),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }

    if (!mounted) return;
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

// --- ProcesadorTFLiteOffline ---
class ProcesadorTFLiteOffline {
  static const String _modelPath =
      'assets/model/best_combined_classifier.tflite';
  static const String _labelsPath = 'assets/model/labels.txt';
  Interpreter? _interpreter;
  List<String> _labels = [];
  bool _modeloCargado = false;
  int _inputSize = 224;
  int _numClasses = 19;

  bool get modeloCargado => _modeloCargado;
  List<String> get labels => _labels;
  int get inputSize => _inputSize;
  int get numClasses => _numClasses;

  Future<void> inicializar() async {
    try {
      await _cargarModelo();
      await _cargarEtiquetas();
      _modeloCargado = true;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _cargarModelo() async {
    _interpreter = await Interpreter.fromAsset(_modelPath);
    final inputTensor = _interpreter!.getInputTensor(0);
    final outputTensor = _interpreter!.getOutputTensor(0);
    _inputSize = inputTensor.shape[1];
    _numClasses = outputTensor.shape[1];
  }

  Future<void> _cargarEtiquetas() async {
    try {
      final String labelsString = await rootBundle.loadString(_labelsPath);
      _labels =
          labelsString
              .split('\n')
              .map((line) => line.trim())
              .where((line) => line.isNotEmpty)
              .toList();
    } catch (e) {
      _labels = List.generate(_numClasses, (index) => 'Class_index');
    }
  }

  Future<Map<String, dynamic>> procesarImagen(File imagen) async {
    if (!_modeloCargado || _interpreter == null) {
      throw Exception(
        'Procesador no inicializado. Llama a inicializar() primero.',
      );
    }
    final input = await _preprocesarImagen(imagen);
    final output = [List.filled(_numClasses, 0.0)];
    _interpreter!.run(input, output);
    print('Output tensor: ${output[0]}');
    return _procesarResultados(output[0]);
  }

  Future<List<List<List<List<double>>>>> _preprocesarImagen(File imagen) async {
    final bytes = await imagen.readAsBytes();
    final image = img.decodeImage(bytes);
    if (image == null) {
      throw Exception('No se pudo decodificar la imagen');
    }
    final resizedImage = img.copyResize(
      image,
      width: _inputSize,
      height: _inputSize,
    );
    final tensor = List.generate(
      1,
      (_) => List.generate(
        _inputSize,
        (y) => List.generate(
          _inputSize,
          (x) => List.generate(3, (c) {
            final pixel = resizedImage.getPixel(x, y);
            double value;
            switch (c) {
              case 0:
                value = (pixel.r / 127.5) - 1.0; // MobileNetV3 preprocess_input
                break;
              case 1:
                value = (pixel.g / 127.5) - 1.0;
                break;
              case 2:
                value = (pixel.b / 127.5) - 1.0;
                break;
              default:
                value = 0.0;
            }
            return value;
          }),
        ),
      ),
    );
    print('Primeros valores del tensor: ${tensor[0][0][0]}');
    final input =
        tensor
            .map(
              (batch) =>
                  batch
                      .map(
                        (row) =>
                            row
                                .map(
                                  (pixel) =>
                                      pixel.map((v) => v.toDouble()).toList(),
                                )
                                .toList(),
                      )
                      .toList(),
            )
            .toList();
    return input;
  }

  Map<String, dynamic> _procesarResultados(List<double> output) {
    int maxIndex = 0;
    double maxValue = output[0];
    for (int i = 1; i < output.length; i++) {
      if (output[i] > maxValue) {
        maxValue = output[i];
        maxIndex = i;
      }
    }
    final confianza = maxValue * 100.0;
    final especie =
        maxIndex < _labels.length ? _labels[maxIndex] : 'Desconocido';
    return {'especie': especie, 'confianza': confianza, 'indice': maxIndex};
  }

  void dispose() {
    _interpreter?.close();
    _interpreter = null;
    _modeloCargado = false;
    _labels.clear();
  }
}

String normalize(String s) => s
    .trim()
    .toLowerCase()
    .replaceAll(RegExp(r'[áàäâ]'), 'a')
    .replaceAll(RegExp(r'[éèëê]'), 'e')
    .replaceAll(RegExp(r'[íìïî]'), 'i')
    .replaceAll(RegExp(r'[óòöô]'), 'o')
    .replaceAll(RegExp(r'[úùüû]'), 'u');
