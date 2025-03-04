import 'package:flutter/material.dart';
import '../widgets/BlguNavbar.dart';
import '../widgets/MainAppBar.dart';

class BlguCreateEvacCenter extends StatelessWidget {
  const BlguCreateEvacCenter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Establish Evacuation Center',
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Text(
              'Pwede ka rin gumawa ng Kabarangay Shelter (bahay na pwedeng puntahan para mag-evacuate), ipaalam lang ito sa may ari ng bahay.',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xff212121),
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.italic,
              ),
            ),
            Text(
              'Name of Evacuation Center:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              'Ilagay ang pangalan ng gusali o may-ari nito.',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BlguNavbar(2),
    );
  }
}
