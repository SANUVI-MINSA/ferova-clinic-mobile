import 'package:ferova_clinic_flutter/feature/auth/presentation/forgot_password/verification_indentity_page/verification_identity_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../../../core/di/dependency_injection.dart';
import '../new_password/new_password_page.dart';
import '../new_password/new_password_view_model.dart';

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

  bool _isNavigating = false; // Control de navegación única

  @override
  void initState() {
    super.initState();
    _setupListeners();
  }

  void _setupListeners() {
    // Pequeño delay para asegurar que el Widget está montado
    Future.delayed(Duration.zero, () {
      if (!mounted) return;

      final viewModel = Provider.of<VerificationIdentityViewModel>(context, listen: false);

      // Escuchar mensajes
      viewModel.messageStream.listen((message) {
        if (mounted) {
          _showMessage(message);
        }
      });

      // Escuchar cambios en el estado para navegación
      viewModel.addListener(_onViewModelChanged);
    });
  }

  void _onViewModelChanged() {
    if (!mounted || _isNavigating) return;

    final viewModel = Provider.of<VerificationIdentityViewModel>(context, listen: false);
    final state = viewModel.state;

    if (state.isCodeValid) {
      _isNavigating = true;
      _navigateToNewPassword(viewModel);
    }
  }

  void _navigateToNewPassword(VerificationIdentityViewModel viewModel) {
    final email = widget.email;
    final code = _code;

    // Limpiar estado antes de navegar
    viewModel.clearSuccess();

    // Navegar y luego resetear flag
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider(
          create: (context) => getIt<NewPasswordViewModel>(),
          child: NewPasswordPage(
            email: email,
            verificationCode: code,
          ),
        ),
      ),
    ).then((_) {
      _isNavigating = false;
    });
  }

  void _showMessage(String message) {
    final isError = message.contains('inválido') ||
        message.contains('expirado') ||
        message.contains('Error') ||
        message.contains('error') ||
        message.contains('debe tener');

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
    // Remover listener
    final viewModel = Provider.of<VerificationIdentityViewModel>(context, listen: false);
    viewModel.removeListener(_onViewModelChanged);

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

  String get _code => _controllers.map((c) => c.text).join();

  bool get _isComplete => _controllers.every((c) => c.text.isNotEmpty);

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<VerificationIdentityViewModel>(context);
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
              Text(
                'Hemos enviado un código de 4 dígitos a tu correo\n${widget.email}',
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF7B7B9A),
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 48),

              // OTP Fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(4, (index) {
                  return SizedBox(
                    width: 70,
                    height: 70,
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
                  onPressed: (_isComplete && !state.isLoading && !_isNavigating)
                      ? () => _verifyCode(viewModel)
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
                    'Verificar Código',
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
                    '¿No recibiste el código?  ',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF7B7B9A),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _resendCode(viewModel),
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

  void _verifyCode(VerificationIdentityViewModel viewModel) async {
    if (_isNavigating) return;

    ScaffoldMessenger.of(context).clearSnackBars();
    await viewModel.verifyCode(widget.email, _code);
  }

  void _resendCode(VerificationIdentityViewModel viewModel) async {
    if (_isNavigating) return;

    ScaffoldMessenger.of(context).clearSnackBars();

    // Limpiar campos
    for (final controller in _controllers) {
      controller.clear();
    }
    _focusNodes[0].requestFocus();

    await viewModel.resendCode(widget.email);
  }
}