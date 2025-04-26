import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:car2go_mobile_app/auth/data/auth_service.dart';
import 'package:car2go_mobile_app/auth/presentation/screen/login.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize;

  const CustomAppBar({super.key}) : preferredSize = const Size.fromHeight(kToolbarHeight);

  Future<void> _handleLogout(BuildContext context) async {
    await AuthService.logout();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Container(
        height: preferredSize.height + MediaQuery.of(context).padding.top,
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: SizedBox(
                width: 80,
                height: 80,
                child: Image.asset('assets/images/logo.png'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'logout') {
                    _handleLogout(context);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'logout',
                    child: Text('Cerrar sesión'),
                  ),
                ],
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200, width: 3),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/profile.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
