import 'package:flutter/material.dart';

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

  @override
  void dispose() {
    dni.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8EEF5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE8EEF5),
        elevation: 0
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 24),

                // Logo
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFC8E1FF),
                    border: Border.all(color: const Color(0xFFC8E1FF), width: 3), // Borde azul
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

                // Login Card
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
                      // DNI Field
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
                          hintStyle:
                          const TextStyle(color: Color(0xFF9EAFC0)),
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

                      // Password Field
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
                          hintStyle:
                          const TextStyle(color: Color(0xFF9EAFC0)),
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

                      // Forgot password
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

                      // Login Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {},
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
                            padding:
                            const EdgeInsets.symmetric(vertical: 14),
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

                // Register link
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
                      onTap: () {},
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

      // Bottom Navigation Bar
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
}