import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vision_vault_mobile/features/plate_ocr/data/datasources/plate_remote_datasource.dart';
import 'package:vision_vault_mobile/features/plate_ocr/data/repositories/plate_repository_impl.dart';
import 'package:vision_vault_mobile/features/plate_ocr/presentation/bloc/plate_ocr_cubit.dart';
import 'package:vision_vault_mobile/features/plate_ocr/presentation/bloc/plate_ocr_state.dart';
import 'package:vision_vault_mobile/features/plate_ocr/presentation/pages/car_result.dart';
import 'dart:async';

class PlateReaderPage extends StatelessWidget {
  const PlateReaderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PlateOcrCubit(
        PlateRepositoryImpl(remoteDataSource: PlateRemoteDataSourceImpl()),
      ),
      child: const _PlateReaderView(),
    );
  }
}

class _PlateReaderView extends StatefulWidget {
  const _PlateReaderView();

  @override
  State<_PlateReaderView> createState() => _PlateReaderViewState();
}

class _PlateReaderViewState extends State<_PlateReaderView> {
  CameraController? _cameraController;
  late Future<void> _initializeControllerFuture;
  bool _isFlashOn = false;

  @override
  void initState() {
    super.initState();
    _initializeControllerFuture = _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        throw Exception('No cameras available.');
      }
      final firstCamera = cameras.first;

      final controller = CameraController(
        firstCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await controller.initialize();
      if (!mounted) return;

      setState(() {
        _cameraController = controller;
      });

      unawaited(_cameraController?.startImageStream((image) {
        context.read<PlateOcrCubit>().processCameraImage(image, _cameraController!);
      }));
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  void _toggleFlash() {
    if (_cameraController == null) return;
    setState(() {
      _isFlashOn = !_isFlashOn;
    });
    _cameraController!.setFlashMode(
      _isFlashOn ? FlashMode.torch : FlashMode.off,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Plate OCR Scanner'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(
              _isFlashOn ? Icons.flash_on : Icons.flash_off,
              color: Colors.white,
            ),
            onPressed: _toggleFlash,
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: BlocConsumer<PlateOcrCubit, PlateOcrState>(
        listener: (context, state) {
          if (state is PlateOcrSuccess) {
            _cameraController?.stopImageStream();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute<void>(
                builder: (context) => CarResult(address: state.plateText),
              ),
            );
          } else if (state is PlateOcrFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return FutureBuilder<void>(
            future: _initializeControllerFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  _cameraController != null) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    CameraPreview(_cameraController!),
                    _buildOverlay(context, state),
                  ],
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildOverlay(BuildContext context, PlateOcrState state) {
    final isProcessing = state is PlateOcrProcessing;
    
    return Stack(
      children: [
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            Colors.black.withValues(alpha: 0.6),
            BlendMode.srcOut,
          ),
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
              ),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ],
          ),
        ),
        Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: 150,
            decoration: BoxDecoration(
              border: Border.all(
                color: isProcessing 
                    ? Theme.of(context).colorScheme.primary 
                    : Colors.white.withValues(alpha: 0.5),
                width: 3,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: isProcessing
                ? Shimmer.fromColors(
                    baseColor: Colors.transparent,
                    highlightColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ),
        Positioned(
          bottom: 50,
          left: 0,
          right: 0,
          child: Center(
            child: Text(
              isProcessing ? 'Analyzing Frame...' : 'Position plate in the frame',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
