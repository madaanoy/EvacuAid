/* Authored by: Raymund Joseph M. Rosco
Company: Patent Pending
Project: EvacuAid
Feature: [EVA-58] [DEV] Estalbish Evacuation Screen
Description: Ticket [EVA-42]'[UI] Establish Evaciation Screen' must be coded. 
This is where you can add evacuation centers or kabarangay shelters.
*/

import 'package:evacuaid/widgets/custombutton.dart';
import 'package:flutter/material.dart';
import '../widgets/blgunavbar.dart';
import '../widgets/mainappbar.dart';

class BlguEvacCenterList extends StatelessWidget {
  const BlguEvacCenterList({super.key});

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
            Text(
              'Evacuation Centers ',
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
                    child: Text(
                      "Name",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(
                  width: 56.0,
                  child: Row(
                    children: [
                      Text(
                        "Zone",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Icon(Icons.arrow_drop_down,
                      size: 20,)
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 0, 0, 0),
                    child: Text(
                      "Manager",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Expanded(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      spacing: 8,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          child: Container(
                            alignment: Alignment.topCenter,
                            height: 36,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                      0,
                                      0,
                                      16.0,
                                      0,
                                    ),
                                    child: Text("Barangay Hall"),
                                  ),
                                ),
                                SizedBox(width: 56.0, child: Text("Z2")),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(16.0, 0, 0, 0),
                                    child: Text("Daanoy, M."),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            CustomButton(buttonText: "Add an Evacuation Center", route: "/centers/establish_evac", customFunction: () {},),
          ],
        ),
      ),
      bottomNavigationBar: const BlguNavbar(2),
    );
  }
}
