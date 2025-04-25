import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _obscurePassword = true;
  bool _isVendedor = false;
  bool _isComprador = false;
  bool _isMecanico = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ===== HEADER =====
              Container(
                height: 300,
                decoration: BoxDecoration(
                  color: const Color(0xFFFEB040),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: Stack(
                  children: [
                    // Texto de bienvenida
                    const Positioned(
                      left: 20,
                      bottom: 20,
                      child: Text(
                        'Hola.\n¡Bienvenido a WeCar!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // ► Imagen del coche (añade tu asset en pubspec.yaml)
                    Positioned(
                      top: 20,
                      right: 20,
                      child: Image.asset(
                        'assets/images/car.png',
                        width: 180,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),

              // ===== FORMULARIO =====
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 32,
                ),
                // Fondo blanco y esquinas superiores redondeadas para encajar con el header
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Regístrate',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Campo Nombre
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Nombre',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Campo E-mail
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'E-mail',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Campo Contraseña con toggle visibilidad
                    TextField(
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        hintText: 'Ingresa tu contraseña',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // "¿Olvidaste tu contraseña?"
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // Acción para recuperar contraseña
                        },
                        child: const Text('¿Olvidaste tu contraseña?'),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Checkboxes de roles
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: _isVendedor,
                              onChanged:
                                  (v) => setState(() => _isVendedor = v!),
                            ),
                            const Text('Vendedor'),
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: _isComprador,
                              onChanged:
                                  (v) => setState(() => _isComprador = v!),
                            ),
                            const Text('Comprador'),
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: _isMecanico,
                              onChanged:
                                  (v) => setState(() => _isMecanico = v!),
                            ),
                            const Text('Mecánico'),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Botón Acceder
                    ElevatedButton(
                      onPressed: () {
                        // Acción al presionar "Acceder"
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Acceder',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Link a inicio de sesión
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Ya tienes cuenta? '),
                        GestureDetector(
                          onTap: () {
                            // Navegar a pantalla de Inicio de Sesión
                          },
                          child: const Text(
                            'Inicia sesión',
                            style: TextStyle(
                              color: Color(0xFFFEB040),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
