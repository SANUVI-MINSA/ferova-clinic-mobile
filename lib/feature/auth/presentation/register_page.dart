import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ferova_clinic_flutter/feature/auth/presentation/register_view_model.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nombre = TextEditingController();
  final TextEditingController _apellido = TextEditingController();
  final TextEditingController _dni = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _telefono = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;
  int _selectedRol = 1; // 0 = Administrador, 1 = Enfermero/a

  // Flags para controlar que los mensajes se muestren solo una vez
  bool _errorShown = false;
  bool _successShown = false;

  @override
  void dispose() {
    _nombre.dispose();
    _apellido.dispose();
    _dni.dispose();
    _email.dispose();
    _telefono.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<RegisterViewModel>(context);

    // Mostrar error si existe (solo una vez)
    if (viewModel.state.errorMessage != null && !_errorShown) {
      _errorShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(viewModel.state.errorMessage!),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
        viewModel.clearError();
        Future.delayed(const Duration(milliseconds: 500), () {
          _errorShown = false;
        });
      });
    }

    // Mostrar éxito y volver al login (solo una vez)
    if (viewModel.state.successMessage != null && !_successShown) {
      _successShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(viewModel.state.successMessage!),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
        viewModel.clearSuccess();
        Future.delayed(const Duration(milliseconds: 500), () {
          _successShown = false;
          if (mounted) {
            Navigator.pop(context); // Volver al login
          }
        });
      });
    }

    // Mostrar loading
    if (viewModel.state.isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFE8EEF5),
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF0D6EA8),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFE8EEF5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE8EEF5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF1A3A5C)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 16),

                // Title
                const Text(
                  'Crea tu cuenta\nprofesional',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A3A5C),
                    height: 1.25,
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Accede a nuestra plataforma de gestión\nclínica integral.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6B7D8F),
                  ),
                ),

                const SizedBox(height: 24),

                // Register Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Rol Profesional
                      const Text(
                        'Rol Profesional',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF6B7D8F),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          // Administrador
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedRol = 0),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                decoration: BoxDecoration(
                                  color: _selectedRol == 0
                                      ? const Color(0xFF0D6EA8)
                                      : const Color(0xFFEAF3FB),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.admin_panel_settings_outlined,
                                      color: _selectedRol == 0
                                          ? Colors.white
                                          : const Color(0xFF5A8FAF),
                                      size: 28,
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Administrador',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: _selectedRol == 0
                                            ? Colors.white
                                            : const Color(0xFF5A8FAF),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Enfermero/a
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _selectedRol = 1),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                decoration: BoxDecoration(
                                  color: _selectedRol == 1
                                      ? const Color(0xFF0D6EA8)
                                      : const Color(0xFFEAF3FB),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.medical_services_outlined,
                                      color: _selectedRol == 1
                                          ? Colors.white
                                          : const Color(0xFF5A8FAF),
                                      size: 28,
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'Enfermero/a',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: _selectedRol == 1
                                            ? Colors.white
                                            : const Color(0xFF5A8FAF),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      // Nombre Completo
                      _buildLabel('Nombre Completo'),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: _nombre,
                        hint: 'Ej: Maria Elena',
                        keyboardType: TextInputType.name,
                      ),

                      const SizedBox(height: 16),

                      // Apellido Completo
                      _buildLabel('Apellido Completo'),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: _apellido,
                        hint: 'Ej: Garcia Lopez',
                        keyboardType: TextInputType.name,
                      ),

                      const SizedBox(height: 16),

                      // DNI
                      _buildLabel('DNI (8 dígitos)'),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: _dni,
                        hint: '00000000',
                        keyboardType: TextInputType.number,
                        maxLength: 8,
                      ),

                      const SizedBox(height: 16),

                      // Teléfono
                      _buildLabel('Teléfono'),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: _telefono,
                        hint: '+51 987 347 182',
                        keyboardType: TextInputType.phone,
                      ),

                      const SizedBox(height: 16),

                      // Email
                      _buildLabel('Correo electrónico'),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: _email,
                        hint: 'ejemplo@correo.com',
                        keyboardType: TextInputType.emailAddress,
                      ),

                      const SizedBox(height: 16),

                      // Contraseña
                      _buildLabel('Contraseña'),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _password,
                        obscureText: _obscurePassword,
                        style: const TextStyle(
                          color: Color(0xFF9EAFC0),
                          fontSize: 15,
                        ),
                        decoration: InputDecoration(
                          hintText: '••••••••••••',
                          hintStyle: const TextStyle(color: Color(0xFF9EAFC0)),
                          filled: true,
                          fillColor: const Color(0xFFF0F5FA),
                          suffixIcon: GestureDetector(
                            onTap: () => setState(
                                    () => _obscurePassword = !_obscurePassword),
                            child: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: const Color(0xFF9EAFC0),
                            ),
                          ),
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

                      // Confirmar Contraseña
                      _buildLabel('Confirmar contraseña'),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _confirmPassword,
                        obscureText: _obscureConfirmPassword,
                        style: const TextStyle(
                          color: Color(0xFF9EAFC0),
                          fontSize: 15,
                        ),
                        decoration: InputDecoration(
                          hintText: '••••••••••••',
                          hintStyle: const TextStyle(color: Color(0xFF9EAFC0)),
                          filled: true,
                          fillColor: const Color(0xFFF0F5FA),
                          suffixIcon: GestureDetector(
                            onTap: () => setState(() =>
                            _obscureConfirmPassword =
                            !_obscureConfirmPassword),
                            child: Icon(
                              _obscureConfirmPassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: const Color(0xFF9EAFC0),
                            ),
                          ),
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

                      // Terms checkbox
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Checkbox(
                            value: _acceptTerms,
                            onChanged: (val) =>
                                setState(() => _acceptTerms = val ?? false),
                            activeColor: const Color(0xFF0D6EA8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            side: const BorderSide(
                              color: Color(0xFF9EAFC0),
                              width: 1.5,
                            ),
                            materialTapTargetSize:
                            MaterialTapTargetSize.shrinkWrap,
                          ),
                          const SizedBox(width: 4),
                          const Expanded(
                            child: Text(
                              'Acepto términos de confidencialidad clínica y privacidad',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF6B7D8F),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Register Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: (viewModel.state.isLoading || !_acceptTerms)
                              ? null
                              : () => _register(viewModel),
                          icon: const Icon(Icons.person_add_alt_1_rounded,
                              size: 20),
                          label: const Text(
                            'Registrar Perfil',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0D6EA8),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
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

                const SizedBox(height: 24),

                // Login link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '¿Ya tienes una cuenta?  ',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7D8F),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Inicia sesión',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF0D6EA8),
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          decorationColor: Color(0xFF0D6EA8),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        color: Color(0xFF6B7D8F),
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    int? maxLength,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLength: maxLength,
      style: const TextStyle(
        color: Color(0xFF9EAFC0),
        fontSize: 15,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF9EAFC0)),
        counterText: '',
        filled: true,
        fillColor: const Color(0xFFF0F5FA),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }

  void _register(RegisterViewModel viewModel) async {
    // Resetear flags
    _errorShown = false;
    _successShown = false;

    // Validaciones
    if (_nombre.text.isEmpty || _apellido.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nombre y apellido son requeridos'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_dni.text.length != 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('DNI debe tener 8 dígitos'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_telefono.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Teléfono es requerido'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_email.text.isEmpty || !_email.text.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Correo electrónico válido es requerido'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_password.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('La contraseña debe tener al menos 6 caracteres'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_password.text != _confirmPassword.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Las contraseñas no coinciden'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Determinar el rol
    final role = _selectedRol == 0 ? 'Admin' : 'Nurse';

    // Llamar al registro
    await viewModel.registerStaff(
      name: _nombre.text,
      lastname: _apellido.text,
      dni: _dni.text,
      email: _email.text,
      phone: _telefono.text,
      password: _password.text,
      role: role,
    );
  }
}