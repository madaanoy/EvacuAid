import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BackAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BackAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      title: IconButton(
        onPressed: () => {
          context.pop()
        },
        icon: Icon(
          Icons.arrow_back,
          size: 24,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(4.0),
        child: Container(color: Theme.of(context).colorScheme.outline, height: 1),
    ));
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
