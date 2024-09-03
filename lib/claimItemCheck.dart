import 'package:flutter/material.dart';

class ClaimItemCheckScreen extends StatefulWidget {
  const ClaimItemCheckScreen({super.key});

  @override
  State<ClaimItemCheckScreen> createState() => _ClaimItemCheckScreenState();
}

class _ClaimItemCheckScreenState extends State<ClaimItemCheckScreen> {
  final _passcodeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 80.0, top: 80),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("智慧失物招領", style: TextStyle(fontSize: 60)),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 80.0),
                  child: SizedBox(
                    height: 80,
                    width: 160,
                    child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.background),
                        onPressed: () {},
                        icon: Icon(Icons.check),
                        label: Text("確認")),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
