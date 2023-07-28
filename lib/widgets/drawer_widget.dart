import 'package:flutter/material.dart';
import 'package:kcc_management_software/screens/attendance_screen.dart';
import 'package:kcc_management_software/screens/playerlist_screen.dart';
import 'package:kcc_management_software/widgets/text_widget.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Container(
            height: 50,
            width: 150,
            color: Colors.black,
          ),
          const SizedBox(
            height: 20,
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const PlayerListScreen()));
            },
            leading: const Icon(Icons.account_circle_outlined),
            title: TextRegular(
              text: 'Player List',
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const AttendanceScreen()));
            },
            leading: const Icon(Icons.calendar_month_outlined),
            title: TextRegular(
              text: 'Attendance',
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
