import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:password/ui/screens/settings_screen.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Homepage"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (context) => SettingsScreen(),
                ),
              );
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: const Center(
        child: Text(
          "HomePage",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
