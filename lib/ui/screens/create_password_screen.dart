import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:password/ui/screens/homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreatePasswordScreen extends StatefulWidget {
  const CreatePasswordScreen({super.key});

  @override
  State<CreatePasswordScreen> createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  int password = 0;
  String passKey = '';
  List<ValueNotifier<bool>> buttonStates =
      List.generate(12, (_) => ValueNotifier(false));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create a password"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 140.0),
        child: Column(
          children: [
            SvgPicture.asset("assets/icons/lock.svg"),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                4,
                (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 30,
                    ),
                    child: password > index
                        ? Container(
                            height: 24,
                            width: 24,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: Colors.green,
                            ),
                          )
                        : Container(
                            height: 24,
                            width: 24,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.black12),
                            ),
                          ),
                  );
                },
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 60),
                itemCount: 12,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 30,
                  crossAxisSpacing: 30,
                ),
                itemBuilder: (context, index) {
                  if (index == 9) {
                    return const SizedBox();
                  }

                  if (index == 10) {
                    return _buildDigitButton(index: 0, stateIndex: index);
                  }
                  if (index == 11) {
                    return InkWell(
                      onTap: () {
                        if (password > 0) {
                          password--;
                          passKey = passKey.substring(0, password);
                        }
                        setState(() {});
                      },
                      splashColor: const Color(0xffDDF6E1),
                      borderRadius: BorderRadius.circular(50),
                      child: const Icon(
                        Icons.backspace_outlined,
                        color: Color(0xff727782),
                      ),
                    );
                  }

                  return _buildDigitButton(index: index + 1, stateIndex: index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDigitButton({required int index, required int stateIndex}) {
    return InkWell(
      onTapDown: (details) {
        buttonStates[stateIndex].value = true;
      },
      onTapCancel: () {
        buttonStates[stateIndex].value = false;
      },
      onTapUp: (details) async {
        buttonStates[stateIndex].value = false;
        if (password < 4) {
          password++;
          passKey += index.toString();
          if (password == 4) {
            final shared = await SharedPreferences.getInstance();

            shared.setString("password", passKey);
            shared.setBool("isEnabled", true);
            Navigator.of(context).pushAndRemoveUntil(
              CupertinoPageRoute(
                builder: (context) => Homepage(),
              ),
              (route) => false,
            );
          }
        }
        setState(() {});
      },
      borderRadius: BorderRadius.circular(16),
      splashColor: const Color(0xffDDF6E1),
      child: ValueListenableBuilder<bool>(
        valueListenable: buttonStates[stateIndex],
        builder: (context, value, child) {
          return Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xfff2f2f2),
              ),
            ),
            child: Text(
              '$index',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: value ? Colors.green : const Color(0xff727782),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    for (var notifier in buttonStates) {
      notifier.dispose();
    }
    super.dispose();
  }
}
