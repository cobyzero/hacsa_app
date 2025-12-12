import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';

/// Splash Screen for AdhesivePro
/// Provides branded app launch experience while initializing authentication status,
/// product catalog cache, and core services for the adhesives e-commerce platform
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  bool _isInitializing = true;
  String _initializationStatus = 'Iniciando...';
  bool _showRetry = false;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  /// Setup logo animations
  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutBack,
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _animationController.forward();
  }

  /// Initialize app services and determine navigation path
  Future<void> _initializeApp() async {
    try {
      // Check authentication status
      setState(() => _initializationStatus = 'Verificando autenticación...');
      await Future.delayed(const Duration(milliseconds: 800));
      final isAuthenticated = await _checkAuthenticationStatus();

      // Load cached product data
      setState(
          () => _initializationStatus = 'Cargando catálogo de productos...');
      await Future.delayed(const Duration(milliseconds: 800));
      await _loadProductCache();

      // Fetch promotional offers
      setState(
          () => _initializationStatus = 'Obteniendo ofertas promocionales...');
      await Future.delayed(const Duration(milliseconds: 800));
      await _fetchPromotionalOffers();

      // Wait for animation to complete
      await _animationController.forward();
      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;

      // Navigate based on authentication status
      if (isAuthenticated) {
        Navigator.pushReplacementNamed(context, '/product-catalog');
      } else {
        // Check if user has seen onboarding
        final hasSeenOnboarding = await _checkOnboardingStatus();
        if (hasSeenOnboarding) {
          Navigator.pushReplacementNamed(context, '/login-screen');
        } else {
          // For now, navigate to login as onboarding is not implemented
          Navigator.pushReplacementNamed(context, '/login-screen');
        }
      }
    } catch (e) {
      // Handle initialization errors
      if (mounted) {
        setState(() {
          _isInitializing = false;
          _showRetry = true;
          _initializationStatus = 'Error al inicializar la aplicación';
        });
      }
    }
  }

  /// Check user authentication status
  Future<bool> _checkAuthenticationStatus() async {
    // Simulate authentication check
    // In production, this would check SharedPreferences or secure storage
    await Future.delayed(const Duration(milliseconds: 500));
    return true; // Default to not authenticated
  }

  /// Load cached product data
  Future<void> _loadProductCache() async {
    // Simulate loading cached product data
    // In production, this would load from local database (sqflite)
    await Future.delayed(const Duration(milliseconds: 500));
  }

  /// Fetch promotional offers
  Future<void> _fetchPromotionalOffers() async {
    // Simulate fetching promotional offers
    // In production, this would make API call with timeout handling
    await Future.delayed(const Duration(milliseconds: 500));
  }

  /// Check if user has seen onboarding
  Future<bool> _checkOnboardingStatus() async {
    // Simulate checking onboarding status
    // In production, this would check SharedPreferences
    await Future.delayed(const Duration(milliseconds: 200));
    return true; // Default to has seen onboarding
  }

  /// Retry initialization
  void _retryInitialization() {
    setState(() {
      _isInitializing = true;
      _showRetry = false;
      _initializationStatus = 'Reintentando...';
    });
    _initializeApp();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Hide status bar on Android, use brand color on iOS
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.primaryContainer,
              theme.colorScheme.secondary,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // Animated logo
              FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: _buildLogo(theme),
                ),
              ),

              const SizedBox(height: 48),

              // App name
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  'Hacsa',
                  style: theme.textTheme.headlineLarge?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Tagline
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  'Productos Auténticos, Calidad Garantizada',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onPrimary.withValues(alpha: 0.9),
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const Spacer(flex: 1),

              // Loading indicator or retry button
              _showRetry
                  ? _buildRetryButton(theme)
                  : _buildLoadingIndicator(theme),

              const SizedBox(height: 24),

              // Initialization status
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  _initializationStatus,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const Spacer(flex: 1),

              // Version info
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Text(
                  'Versión 1.0.0',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onPrimary.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build logo widget
  Widget _buildLogo(ThemeData theme) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Center(
        child: CustomIconWidget(
          iconName: 'business',
          color: theme.colorScheme.primary,
          size: 64,
        ),
      ),
    );
  }

  /// Build loading indicator
  Widget _buildLoadingIndicator(ThemeData theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 40,
          height: 40,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              theme.colorScheme.onPrimary,
            ),
            strokeWidth: 3,
          ),
        ),
      ],
    );
  }

  /// Build retry button
  Widget _buildRetryButton(ThemeData theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomIconWidget(
          iconName: 'error_outline',
          color: theme.colorScheme.error,
          size: 48,
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: _retryInitialization,
          icon: CustomIconWidget(
            iconName: 'refresh',
            color: theme.colorScheme.onPrimary,
            size: 20,
          ),
          label: Text(
            'Reintentar',
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onPrimary,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.secondary,
            foregroundColor: theme.colorScheme.onSecondary,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}
