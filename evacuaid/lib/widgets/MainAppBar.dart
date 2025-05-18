import 'package:evacuaid/auth/firebase_auth_service.dart';
import 'package:flutter/material.dart';

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final _authService = FirebaseAuthService();
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset('assets/logos/logo.png', height: 20),
          IconButton(
            onPressed: () => {
              _authService.signOut(context)
            },
            icon: Icon(
              Icons.account_circle_rounded,
              size: 24,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(4.0),
        child: Container(color: Theme.of(context).colorScheme.outline, height: 1),
    ));
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
