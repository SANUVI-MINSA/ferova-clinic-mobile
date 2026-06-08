import 'package:ferova_clinic_flutter/feature/auth/presentation/forgot_password/recovery_password/recovery_password_view_model.dart';
import 'package:ferova_clinic_flutter/feature/auth/presentation/forgot_password/verification_indentity_page/verification_identity_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/di/dependency_injection.dart';
import '../verification_indentity_page/verification_identity_view_model.dart';

class RecoveryPasswordPage extends StatefulWidget {
  const RecoveryPasswordPage({super.key});

  @override
  State<RecoveryPasswordPage> createState() => _RecoveryPasswordPageState();
}

class _RecoveryPasswordPageState extends State<RecoveryPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      if (!mounted) return;
      final viewModel = Provider.of<RecoveryPasswordViewModel>(context, listen: false);

      viewModel.messageStream.listen((message) {
        if (mounted) _showMessage(message);
      });

      viewModel.addListener(_onViewModelChanged);
    });
  }

  void _onViewModelChanged() {
    if (!mounted || _isNavigating) return;

    final viewModel = Provider.of<RecoveryPasswordViewModel>(context, listen: false);
    if (viewModel.state.successMessage != null) {
      _isNavigating = true;
      _navigateToVerification(viewModel);
    }
  }

  void _navigateToVerification(RecoveryPasswordViewModel viewModel) {
    final email = emailController.text.trim();
    viewModel.clearSuccess();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider(
          create: (context) => getIt<VerificationIdentityViewModel>(),
          child: VerificationIdentityPage(email: email),
        ),
      ),
    ).then((_) {
      _isNavigating = false;
    });
  }


  void _showMessage(String message) {
    // Determinar si es error o éxito basado en el contenido
    final isError = message.contains('Error') ||
        message.contains('error') ||
        message.contains('válido') ||
        message.contains('incorrecto');

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<RecoveryPasswordViewModel>(context);
    final state = viewModel.state;

    // Mostrar loading
    if (state.isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF6B21E8),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 100),

                // Title
                const Text(
                  '¿Olvidastes tu Contraseña?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A2E),
                  ),
                ),

                const SizedBox(height: 16),

                // Subtitle
                const Text(
                  'Ingresa tu correo para recibir un\ncódigo de recuperación',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF7B7B9A),
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 48),

                // Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE0E0EE), width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Label
                      const Text(
                        'Correo Electrónico',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF7B7B9A),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Email field
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(
                          color: Color(0xFF9E9EB8),
                          fontSize: 15,
                        ),
                        decoration: InputDecoration(
                          hintText: 'ejemplo@correo.com',
                          hintStyle: const TextStyle(color: Color(0xFFB0B0C8)),
                          prefixIcon: const Icon(
                            Icons.mail_outline_rounded,
                            color: Color(0xFF9E9EB8),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF5F5FB),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Send button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: state.isLoading
                              ? null
                              : () => _sendCode(viewModel),
                          icon: const Icon(Icons.send_rounded, size: 20),
                          label: const Text(
                            'Enviar Código',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6B21E8),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 36),

                // Back to login
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.login_rounded,
                        color: Color(0xFF6B21E8),
                        size: 22,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Volver al Inicio de Sesión',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B21E8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 48),

                // Security note
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.shield_outlined,
                      color: Color(0xFFB0B0C8),
                      size: 18,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Ferova protege tus datos personales',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFFB0B0C8),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _sendCode(RecoveryPasswordViewModel viewModel) async {
    ScaffoldMessenger.of(context).clearSnackBars();

    // Validación local rápida del email
    final email = emailController.text.trim();
    if (email.isEmpty) {
      _showMessage('Ingrese su correo electrónico');
      return;
    }

    if (!email.contains('@')) {
      _showMessage('Ingrese un correo electrónico válido');
      return;
    }

    // Actualizar el email en el ViewModel
    viewModel.updateEmail(email);

    // Enviar el código - los mensajes vendrán a través del Stream
    await viewModel.sendResetCode();
  }
}