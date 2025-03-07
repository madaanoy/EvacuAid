/* Authored by: Raymund Joseph M. Rosco
Company: Patent Pending
Project: EvacuAid
Feature: [EVA-58] [DEV] Estalbish Evacuation Screen
Description: Ticket [EVA-42]'[UI] Establish Evaciation Screen' must be coded. 
This is where you can add evacuation centers or kabarangay shelters.
*/

import 'package:evacuaid/widgets/CustomButton.dart';
import 'package:evacuaid/widgets/CustomTextInput.dart';
import 'package:flutter/material.dart';
import '../widgets/BlguNavbar.dart';
import '../widgets/MainAppBar.dart';
import '../widgets/CustomDropDown.dart';

class BlguCreateEvacCenter extends StatelessWidget {
  const BlguCreateEvacCenter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          spacing: 8,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Text(
                  'Add Evacuation Center',
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Text(
                  'Pwede rin ang Kabarangay Shelter o bahay na pwedeng puntahan para mag-evacuate.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff212121),
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Text(
                  'Name of Evacuation Center:',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  'Ilagay ang pangalan ng gusali o may-ari nito.',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                CustomTextInput(),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Text('Address:', style: Theme.of(context).textTheme.titleLarge),
                Text(
                  'Ilagay ang building o house number at zone number.',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                CustomTextInput(),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Text('BLGU:', style: Theme.of(context).textTheme.titleLarge),
                Text(
                  'Automatic base sa BLGU na gumagawa.',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                // TO-ALTER: Automatic based on LGU
                SizedBox(
                  height: 48,
                  child: TextField(
                    style: TextStyle(fontSize: 16, height: 3),
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                      isCollapsed: true,
                      hintText: 'Brgy. Sto. Domingo, Bombon, Cam. Sur',
                      hintStyle: TextStyle(
                        color:
                            Theme.of(context).colorScheme.onSurface,
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surfaceContainer,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                Text(
                  'Camp Manager:',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  'Pindutin ang pindutan sa baba at pumili sa lista. Maaari rin mag-rehistro ng bago.',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                // TO-ALTER: Automatic based on LGU
                CustomDropDown(),
              ],
            ),
            CustomButton(),
          ],
        ),
      ),
      bottomNavigationBar: const BlguNavbar(2),
    );
  }
}
