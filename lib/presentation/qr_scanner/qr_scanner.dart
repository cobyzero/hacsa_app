import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/manual_entry_widget.dart';
import './widgets/recent_scans_widget.dart';
import './widgets/scanner_bottom_sheet_widget.dart';
import './widgets/scanner_overlay_widget.dart';

class QrScanner extends StatefulWidget {
  const QrScanner({super.key});

  @override
  State<QrScanner> createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> with WidgetsBindingObserver {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isInitialized = false;
  bool _isFlashOn = false;
  bool _isProcessing = false;
  bool _showRecentScans = false;
  bool _showManualEntry = false;
  String? _errorMessage;

  // Mock recent scans data
  final List<Map<String, dynamic>> _recentScans = [
    {
      "id": "ADH-2024-001",
      "productName": "Adhesivo Industrial Ultra Fuerte",
      "timestamp": DateTime.now().subtract(const Duration(hours: 2)),
      "status": "genuine",
      "image":
          "https://img.rocket.new/generatedImages/rocket_gen_img_13ae98442-1765118225986.png",
      "semanticLabel":
          "Industrial adhesive tube in metallic silver packaging with blue label"
    },
    {
      "id": "ADH-2024-002",
      "productName": "Pegamento Multiusos Premium",
      "timestamp": DateTime.now().subtract(const Duration(days: 1)),
      "status": "genuine",
      "image": "https://images.unsplash.com/photo-1628064843303-7bcec94646f6",
      "semanticLabel": "White glue bottle with red cap on wooden surface"
    },
    {
      "id": "ADH-2024-003",
      "productName": "Sellador de Silicona Profesional",
      "timestamp": DateTime.now().subtract(const Duration(days: 2)),
      "status": "genuine",
      "image":
          "https://img.rocket.new/generatedImages/rocket_gen_img_17448638b-1765215564789.png",
      "semanticLabel": "Professional silicone sealant tube in gray packaging"
    },
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = _cameraController;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    try {
      // Request camera permission
      final permissionStatus = await _requestCameraPermission();

      if (!permissionStatus) {
        setState(() {
          _errorMessage =
              'Permiso de cámara denegado. Por favor, habilita el acceso a la cámara en la configuración.';
        });
        return;
      }

      // Get available cameras
      _cameras = await availableCameras();

      if (_cameras == null || _cameras!.isEmpty) {
        setState(() {
          _errorMessage = 'No se encontró ninguna cámara en el dispositivo.';
        });
        return;
      }

      // Initialize camera controller with rear camera
      final camera = _cameras!.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => _cameras!.first,
      );

      _cameraController = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await _cameraController!.initialize();

      // Apply camera settings
      await _applyCameraSettings();

      if (mounted) {
        setState(() {
          _isInitialized = true;
          _errorMessage = null;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al inicializar la cámara: ${e.toString()}';
      });
    }
  }

  Future<bool> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  Future<void> _applyCameraSettings() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      await _cameraController!.setFocusMode(FocusMode.auto);
      await _cameraController!.setExposureMode(ExposureMode.auto);
      await _cameraController!.setFlashMode(FlashMode.off);
    } catch (e) {
      debugPrint('Error applying camera settings: $e');
    }
  }

  Future<void> _toggleFlash() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      HapticFeedback.lightImpact();

      if (_isFlashOn) {
        await _cameraController!.setFlashMode(FlashMode.off);
      } else {
        await _cameraController!.setFlashMode(FlashMode.torch);
      }

      setState(() {
        _isFlashOn = !_isFlashOn;
      });
    } catch (e) {
      debugPrint('Error toggling flash: $e');
    }
  }

  Future<void> _simulateScan() async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    HapticFeedback.mediumImpact();

    // Simulate scanning delay
    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      HapticFeedback.heavyImpact();

      // Navigate to authentication results (mock)
      _showAuthenticationResult();
    }
  }

  void _showAuthenticationResult() {
    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: CustomIconWidget(
                  iconName: 'verified',
                  color: theme.colorScheme.primary,
                  size: 24,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  'Producto Auténtico',
                  style: theme.textTheme.titleLarge,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'El código QR escaneado corresponde a un producto genuino de nuestra marca.',
                style: theme.textTheme.bodyMedium,
              ),
              SizedBox(height: 2.h),
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Código de Producto',
                      style: theme.textTheme.labelSmall,
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      'ADH-2024-${DateTime.now().millisecondsSinceEpoch % 1000}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _isProcessing = false;
                });
              },
              child: const Text('Cerrar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/product-catalog');
              },
              child: const Text('Ver Producto'),
            ),
          ],
        );
      },
    );
  }

  void _showPermissionDialog() {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'camera_alt',
              color: theme.colorScheme.primary,
              size: 24,
            ),
            SizedBox(width: 3.w),
            const Expanded(
              child: Text('Permiso de Cámara'),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Para verificar la autenticidad de los productos, necesitamos acceso a tu cámara.',
              style: theme.textTheme.bodyMedium,
            ),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'verified_user',
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'Protege tu compra verificando productos auténticos',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: const Text('Abrir Configuración'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomAppBar.detail(
        title: 'Escanear QR',
        onBackPressed: () => Navigator.pop(context),
        actions: [
          if (_isInitialized)
            IconButton(
              icon: CustomIconWidget(
                iconName: _isFlashOn ? 'flash_on' : 'flash_off',
                color: Colors.white,
                size: 24,
              ),
              onPressed: _toggleFlash,
              tooltip: _isFlashOn ? 'Apagar linterna' : 'Encender linterna',
            ),
        ],
      ),
      body: Stack(
        children: [
          // Camera preview or error state
          if (_isInitialized && _cameraController != null)
            SizedBox.expand(
              child: CameraPreview(_cameraController!),
            )
          else if (_errorMessage != null)
            Container(
              color: theme.colorScheme.surface,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(6.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomIconWidget(
                        iconName: 'camera_alt',
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.3),
                        size: 64,
                      ),
                      SizedBox(height: 3.h),
                      Text(
                        _errorMessage!,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge,
                      ),
                      SizedBox(height: 3.h),
                      ElevatedButton.icon(
                        onPressed: () {
                          if (_errorMessage!.contains('denegado')) {
                            _showPermissionDialog();
                          } else {
                            _initializeCamera();
                          }
                        },
                        icon: CustomIconWidget(
                          iconName: 'refresh',
                          color: theme.colorScheme.onPrimary,
                          size: 20,
                        ),
                        label: Text(
                          _errorMessage!.contains('denegado')
                              ? 'Abrir Configuración'
                              : 'Reintentar',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            Container(
              color: theme.colorScheme.surface,
              child: Center(
                child: CircularProgressIndicator(
                  color: theme.colorScheme.primary,
                ),
              ),
            ),

          // Scanner overlay
          if (_isInitialized)
            ScannerOverlayWidget(
              isProcessing: _isProcessing,
              onTap: _simulateScan,
            ),

          // Bottom sheet
          if (_isInitialized && !_showRecentScans && !_showManualEntry)
            ScannerBottomSheetWidget(
              onManualEntry: () {
                setState(() {
                  _showManualEntry = true;
                });
              },
              onShowRecentScans: () {
                setState(() {
                  _showRecentScans = true;
                });
              },
            ),

          // Recent scans overlay
          if (_showRecentScans)
            RecentScansWidget(
              recentScans: _recentScans,
              onClose: () {
                setState(() {
                  _showRecentScans = false;
                });
              },
              onScanTap: (scan) {
                setState(() {
                  _showRecentScans = false;
                });
                _showAuthenticationResult();
              },
            ),

          // Manual entry overlay
          if (_showManualEntry)
            ManualEntryWidget(
              onClose: () {
                setState(() {
                  _showManualEntry = false;
                });
              },
              onSubmit: (code) {
                setState(() {
                  _showManualEntry = false;
                });
                _showAuthenticationResult();
              },
            ),
        ],
      ),
    );
  }
}
