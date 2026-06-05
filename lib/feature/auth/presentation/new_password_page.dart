import 'package:flutter/material.dart';

class NewPasswordPage extends StatefulWidget {
  const NewPasswordPage({super.key});

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Security requirements state
  bool get _hasMinLength => _password.text.length >= 8;
  bool get _hasNumber => _password.text.contains(RegExp(r'[0-9]'));
  bool get _hasSpecialChar =>
      _password.text.contains(RegExp(r'[@#$%^&*!]'));

  bool get _isValid =>
      _hasMinLength && _hasNumber && _hasSpecialChar &&
          _password.text == _confirmPassword.text &&
          _confirmPassword.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _password.addListener(() => setState(() {}));
    _confirmPassword.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                        label: 'Minimo 8 caracteres',
                        met: _hasMinLength,
                      ),
                      const SizedBox(height: 8),
                      _buildRequirement(
                        label: 'Al menos un numero',
                        met: _hasNumber,
                      ),
                      const SizedBox(height: 8),
                      _buildRequirement(
                        label: 'Un carácter especial (@, #, \$)',
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
                    onPressed: _isValid
                        ? () {
                      // TODO: Navigate to success / login
                    }
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
}