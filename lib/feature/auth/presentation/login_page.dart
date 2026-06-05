import 'package:ferova_clinic_flutter/feature/auth/presentation/register_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ferova_clinic_flutter/feature/auth/presentation/login_view_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController dni = TextEditingController();
  final TextEditingController password = TextEditingController();
  bool _obscurePassword = true;
  int _selectedIndex = 1;
  
  // Usar un mensaje único que se muestra una sola vez
  String? _pendingMessage;

  @override
  void initState() {
    super.initState();
    // Escuchar cambios en el ViewModel después de que se construya
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupMessageListener();
    });
  }
  
  void _setupMessageListener() {
    final viewModel = Provider.of<LoginViewModel>(context, listen: false);
    viewModel.messageStream.listen((message) {
      if (mounted) {
        _showMessage(message);
      }
    });
  }
  
  void _showMessage(String message) {
    // Determinar si es error o éxito basado en el contenido
    final isError = message.contains('incorrectos') || 
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
    dni.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LoginViewModel>(context);
    final state = viewModel.state;

    // Manejar navegación después de login exitoso
    if (state.user != null && state.token != null && _pendingMessage == null) {
      _pendingMessage = 'success';
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Limpiar estado después de la navegación
        final userDni = state.user!.dni;
        viewModel.clearSuccess();
        
        if (mounted) {
          // TODO: Navegar a HomePage cuando esté lista
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(builder: (_) => const HomePage()),
          // );
          
          _pendingMessage = null;
        }
      });
    }

    // Mostrar loading
    if (state.isLoading) {
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
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 24),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFC8E1FF),
                    border: Border.all(color: const Color(0xFFC8E1FF), width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Image.asset(
                    'assets/ferova_clinic.png',
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'FerovaClinic',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A3A5C),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Portal del Paciente',
                  style: TextStyle(fontSize: 14, color: Color(0xFF6B7D8F)),
                ),
                const SizedBox(height: 32),
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
                      const Text(
                        'DNI (8 dígitos)',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF6B7D8F),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: dni,
                        keyboardType: TextInputType.number,
                        maxLength: 8,
                        style: const TextStyle(
                          color: Color(0xFF9EAFC0),
                          fontSize: 15,
                        ),
                        decoration: InputDecoration(
                          hintText: '00000000',
                          hintStyle: const TextStyle(color: Color(0xFF9EAFC0)),
                          counterText: '',
                          filled: true,
                          fillColor: const Color(0xFFF0F5FA),
                          suffixIcon: const Icon(
                            Icons.badge_outlined,
                            color: Color(0xFF9EAFC0),
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
                      const Text(
                        'Contraseña',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF6B7D8F),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: password,
                        obscureText: _obscurePassword,
                        style: const TextStyle(
                          color: Color(0xFF9EAFC0),
                          fontSize: 15,
                        ),
                        decoration: InputDecoration(
                          hintText: '••••••••••••••',
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
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {},
                          child: const Text(
                            '¿Olvidaste tu contraseña?',
                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF1A7ABF),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: state.isLoading
                              ? null
                              : () => _login(viewModel),
                          icon: const Icon(Icons.login_rounded, size: 20),
                          label: const Text(
                            'Acceder al Sistema',
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '¿Primera vez aquí?  ',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7D8F),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RegisterPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Crea tu cuenta',
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF0D6EA8),
        unselectedItemColor: const Color(0xFF9EAFC0),
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.help_outline_rounded),
            label: 'Soporte',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lock_rounded),
            label: 'ACCESO',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.gavel_rounded),
            label: 'Leyes',
          ),
        ],
      ),
    );
  }

  void _login(LoginViewModel viewModel) async {
    // Limpiar mensajes pendientes anteriores
    _pendingMessage = null;
    ScaffoldMessenger.of(context).clearSnackBars();
    
    // Validaciones locales
    if (dni.text.length != 8) {
      _showMessage('DNI debe tener 8 dígitos');
      return;
    }

    if (password.text.isEmpty) {
      _showMessage('Ingrese su contraseña');
      return;
    }

    // Hacer el login - los mensajes vendrán a través del Stream
    await viewModel.login(dni: dni.text, password: password.text);
  }
}