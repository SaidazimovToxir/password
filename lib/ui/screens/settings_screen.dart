import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:password/ui/screens/create_password_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isEnabled = false;
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      isEnabled = prefs.getBool("isEnabled") ?? false;
    });
    print(isEnabled);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SwitchListTile(
            title: const Text("Enable password"),
            value: isEnabled,
            onChanged: (value) async {
              if (value) {
                final result = await Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => CreatePasswordScreen(),
                  ),
                );
                if (result == true) {
                  setState(() {
                    isEnabled = value;
                  });
                  await prefs.setBool("isEnabled", true);
                }
              } else {
                setState(() {
                  isEnabled = value;
                });
                await prefs.setBool("isEnabled", false);
              }
            },
          )
        ],
      ),
    );
  }
}
