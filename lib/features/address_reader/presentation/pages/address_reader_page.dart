import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vision_vault_mobile/features/address_reader/data/repositories/address_repository_impl.dart';
import 'package:vision_vault_mobile/features/address_reader/presentation/bloc/address_reader_cubit.dart';
import 'package:vision_vault_mobile/features/address_reader/presentation/bloc/address_reader_state.dart';
import 'package:vision_vault_mobile/features/address_reader/presentation/pages/result_screen.dart';
import 'package:vision_vault_mobile/features/plate_ocr/data/datasources/plate_remote_datasource.dart';
import 'dart:async';

class AddressReaderPage extends StatelessWidget {
  const AddressReaderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddressReaderCubit(
        AddressRepositoryImpl(
          remoteDataSource: PlateRemoteDataSourceImpl(),
        ),
      ),
      child: const _AddressReaderView(),
    );
  }
}

class _AddressReaderView extends StatefulWidget {
  const _AddressReaderView();

  @override
  State<_AddressReaderView> createState() => _AddressReaderViewState();
}

class _AddressReaderViewState extends State<_AddressReaderView> {
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
        context.read<AddressReaderCubit>().processCameraImage(image, _cameraController!);
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
        title: const Text('Address OCR Scanner'),
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
      body: BlocConsumer<AddressReaderCubit, AddressReaderState>(
        listener: (context, state) {
          if (state is AddressReaderSuccess) {
            _cameraController?.stopImageStream();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ResultScreen(text: state.addressText),
              ),
            );
          } else if (state is AddressReaderFailure) {
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

  Widget _buildOverlay(BuildContext context, AddressReaderState state) {
    final isProcessing = state is AddressReaderProcessing;

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
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: 250,
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
            width: MediaQuery.of(context).size.width * 0.85,
            height: 250,
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
              isProcessing ? 'Analyzing Frame...' : 'Position address block in frame',
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
