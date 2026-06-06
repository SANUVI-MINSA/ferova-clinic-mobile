import 'package:ferova_clinic_flutter/feature/auth/presentation/forgot_password/new_password/new_password_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VerificationIdentityPage extends StatefulWidget {
  final String email;
  const VerificationIdentityPage({super.key, required this.email});

  @override
  State<VerificationIdentityPage> createState() =>
      _VerificationIdentityPageState();
}

class _VerificationIdentityPageState extends State<VerificationIdentityPage> {
  final List<TextEditingController> _controllers =
  List.generate(4, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onChanged(String value, int index) {
    if (value.length == 1 && index < 3) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    setState(() {});
  }

  bool get _isComplete =>
      _controllers.every((c) => c.text.isNotEmpty);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
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

              const SizedBox(height: 52),

              // Title
              const Text(
                'Verificar tu identidad',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A2E),
                ),
              ),

              const SizedBox(height: 14),

              // Subtitle
              const Text(
                'Hemos enviado un código de 4 dígitos a tu correo',
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF7B7B9A),
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 48),

              // OTP Fields - Estilo más rectangular como en la imagen
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(4, (index) {
                  return SizedBox(
                    width: 70,
                    height: 70,  // Altura reducida para hacerlos más rectangulares
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      obscureText: false,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A2E),
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: Colors.white,
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
                        contentPadding: EdgeInsets.zero,
                      ),
                      onChanged: (value) => _onChanged(value, index),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 40),

              // Verify button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  // Navegar a NewPasswordPage
                  onPressed: _isComplete
                      ? () {
                      final code =_controllers
                          .map((c) => c.text)
                          .join();
                      Navigator.push(
                          context,
                            MaterialPageRoute(builder: (_) => NewPasswordPage(
                              email: widget.email,
                              verificationCode: code,
                            ),
                          ),
                      );
                  }
                      : null,
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
                  child: const Text(
                    'Verificar Codigo',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // Resend code
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '¿No recibistes el código?  ',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF7B7B9A),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // TODO: Resend code logic
                    },
                    child: const Text(
                      'Reenviar',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B21E8),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}