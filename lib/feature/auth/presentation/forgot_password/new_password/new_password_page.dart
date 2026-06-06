// new_password_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'new_password_view_model.dart';

class NewPasswordPage extends StatefulWidget {
  final String email;
  final String verificationCode;

  const NewPasswordPage({
    super.key,
    required this.email,
    required this.verificationCode,
  });

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Usar un mensaje único que se muestra una sola vez
  String? _pendingMessage;

  // Security requirements state
  bool get _hasMinLength => _password.text.length >= 8;
  bool get _hasNumber => _password.text.contains(RegExp(r'[0-9]'));
  bool get _hasSpecialChar =>
      _password.text.contains(RegExp(r'[@#$%^&*!]'));

  bool get _isPasswordValid =>
      _hasMinLength && _hasNumber && _hasSpecialChar;

  bool get _isValid =>
      _isPasswordValid &&
          _password.text == _confirmPassword.text &&
          _confirmPassword.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _password.addListener(() => setState(() {}));
    _confirmPassword.addListener(() => setState(() {}));

    // Escuchar cambios en el ViewModel después de que se construya
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupMessageListener();
    });
  }

  void _setupMessageListener() {
    final viewModel = Provider.of<NewPasswordViewModel>(context, listen: false);
    viewModel.messageStream.listen((message) {
      if (mounted) {
        _showMessage(message);
      }
    });
  }

  void _showMessage(String message) {
    // Determinar si es error o éxito basado en el contenido
    final isError = message.contains('debe tener') ||
        message.contains('Error') ||
        message.contains('error');

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
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<NewPasswordViewModel>(context);
    final state = viewModel.state;

    // Manejar navegación después de reset exitoso
    if (state.successMessage != null && _pendingMessage == null) {
      _pendingMessage = 'success';
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Limpiar estado después de la navegación
        viewModel.clearSuccess();

        if (mounted) {
          // Navegar al login y limpiar todas las pantallas anteriores
          Navigator.of(context).popUntil((route) => route.isFirst);
          _pendingMessage = null;
        }
      });
    }

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // Back button
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Color(0xFF7B7B9A),
                        size: 18,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Volver',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF7B7B9A),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 36),

                // Title
                const Text(
                  'Nueva Contraseña',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A2E),
                  ),
                ),

                const SizedBox(height: 10),

                // Subtitle
                const Text(
                  'Crea una contraseña segura para proteger tu\ncuenta',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF7B7B9A),
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 28),

                // Nueva Contraseña label
                const Text(
                  'Nueva Contraseña',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF1A1A2E),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _password,
                  obscureText: _obscurePassword,
                  style: const TextStyle(
                    color: Color(0xFF9E9EB8),
                    fontSize: 15,
                  ),
                  decoration: InputDecoration(
                    hintText: '••••••••••••••',
                    hintStyle: const TextStyle(color: Color(0xFFB0B0C8)),
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: GestureDetector(
                      onTap: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                      child: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: const Color(0xFF9E9EB8),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Color(0xFFD0D0E8),
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Color(0xFF6B21E8),
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Confirmar Contraseña label
                const Text(
                  'Confirmar Contraseña',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF1A1A2E),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _confirmPassword,
                  obscureText: _obscureConfirmPassword,
                  style: const TextStyle(
                    color: Color(0xFF9E9EB8),
                    fontSize: 15,
                  ),
                  decoration: InputDecoration(
                    hintText: '••••••••••••••',
                    hintStyle: const TextStyle(color: Color(0xFFB0B0C8)),
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon: GestureDetector(
                      onTap: () => setState(() =>
                      _obscureConfirmPassword = !_obscureConfirmPassword),
                      child: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: const Color(0xFF9E9EB8),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Color(0xFFD0D0E8),
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Color(0xFF6B21E8),
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Security requirements card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFFD0D0E8),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Requisitos de seguridad',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildRequirement(
                        label: 'Mínimo 8 caracteres',
                        met: _hasMinLength,
                      ),
                      const SizedBox(height: 8),
                      _buildRequirement(
                        label: 'Al menos un número',
                        met: _hasNumber,
                      ),
                      const SizedBox(height: 8),
                      _buildRequirement(
                        label: 'Un carácter especial (@, #, \$, %, &)',
                        met: _hasSpecialChar,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // Update button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: (_isValid && !state.isLoading)
                        ? () => _updatePassword(viewModel)
                        : null,
                    icon: const Icon(Icons.refresh_rounded, size: 20),
                    label: const Text(
                      'Actualizar Contraseña',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6B21E8),
                      disabledBackgroundColor: const Color(0xFFD0C4F5),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRequirement({required String label, required bool met}) {
    return Row(
      children: [
        Icon(
          met ? Icons.check_circle_rounded : Icons.circle_outlined,
          size: 18,
          color: met ? const Color(0xFF6B21E8) : const Color(0xFFB0B0C8),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: met ? const Color(0xFF1A1A2E) : const Color(0xFF7B7B9A),
            fontWeight: met ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  void _updatePassword(NewPasswordViewModel viewModel) async {
    // Limpiar mensajes pendientes anteriores
    _pendingMessage = null;
    ScaffoldMessenger.of(context).clearSnackBars();

    // Validaciones locales antes de llamar al ViewModel
    if (_password.text.isEmpty) {
      _showMessage('Ingrese una nueva contraseña');
      return;
    }

    if (_password.text.length < 8) {
      _showMessage('La contraseña debe tener al menos 8 caracteres');
      return;
    }

    if (!_hasNumber) {
      _showMessage('La contraseña debe contener al menos un número');
      return;
    }

    if (!_hasSpecialChar) {
      _showMessage('La contraseña debe contener al menos un carácter especial (@, #, \$, %, &)');
      return;
    }

    if (_password.text != _confirmPassword.text) {
      _showMessage('Las contraseñas no coinciden');
      return;
    }

    await viewModel.resetPassword(
      widget.email,
      widget.verificationCode,
      _password.text,
    );
  }
}