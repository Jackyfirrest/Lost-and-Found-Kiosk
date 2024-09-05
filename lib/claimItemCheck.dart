import 'package:flutter/material.dart';
import 'functions/notion.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rpi_gpio/rpi_gpio.dart';

class ClaimItemCheckScreen extends StatefulWidget {
  const ClaimItemCheckScreen({super.key, required this.passcode});
  final String passcode;
  @override
  State<ClaimItemCheckScreen> createState() => _ClaimItemCheckScreenState();
}

class _ClaimItemCheckScreenState extends State<ClaimItemCheckScreen> {
  final _passcodeController = TextEditingController();
  late final Future claimInfo;
  bool isMatch = false;

  @override
  void initState() {
    super.initState();
    claimInfo = queryWithPasscode(widget.passcode);
    claimInfo.then((value) {
      setState(() {
        isMatch = true;
      });
    }, onError: (error) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
        child: Icon(
          Icons.home,
          size: 30,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      body: Padding(
        padding: const EdgeInsets.only(left: 80.0, top: 80),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("請確認以下資訊是否正確？",
                  style: GoogleFonts.notoSansTc(
                      textStyle: TextStyle(fontSize: 60))),
              Spacer(),
              FutureBuilder(
                  future: claimInfo,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Card(
                        child: Container(
                          padding: EdgeInsets.all(40),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('領取物品：${snapshot.data[0]}',
                                  style: GoogleFonts.notoSansTc(
                                      textStyle: TextStyle(
                                    fontSize: 30,
                                  ))),
                              Text('領取人：${snapshot.data[1]}',
                                  style: GoogleFonts.notoSansTc(
                                      textStyle: TextStyle(
                                    fontSize: 30,
                                  )))
                            ],
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    } else {
                      return CircularProgressIndicator();
                    }
                  }),
              Spacer(),
              Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 40.0, bottom: 80),
                      child: SizedBox(
                        height: 80,
                        width: 160,
                        child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.background),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: Icon(
                              Icons.cancel_outlined,
                              size: 45,
                            ),
                            label: Text(
                              "錯誤",
                              style: GoogleFonts.notoSansTc(),
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 80.0, bottom: 80),
                      child: SizedBox(
                        height: 80,
                        width: 160,
                        child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.background),
                            onPressed: isMatch
                                ? () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ClaimSuccessScreen()));
                                  }
                                : null,
                            icon: Icon(
                              Icons.check,
                              size: 45,
                            ),
                            label: Text(
                              "確認",
                              style: GoogleFonts.notoSansTc(),
                            )),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ClaimSuccessScreen extends StatefulWidget {
  const ClaimSuccessScreen({super.key});

  @override
  State<ClaimSuccessScreen> createState() => _ClaimSuccessScreenState();
}

class _ClaimSuccessScreenState extends State<ClaimSuccessScreen> {
  late final Future timer;
  late final _gpio;
  late final _lock;

  @override
  void initState() {
    super.initState();
    initialize_RpiGpio().then((gpio) {
      _gpio = gpio;
      _lock = gpio.output(37);
      _lock.value = true;
      Future.delayed(Duration(seconds: 3)).then((v) {
        _lock.value = false;
      });
    });
    timer = Future.delayed(Duration(seconds: 10)).then((v) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.ignore();
    _lock.value = false;
    _gpio.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.only(left: 80.0, top: 80),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Spacer(),
            Text("恭喜！請領取物品並關上門",
                style:
                    GoogleFonts.notoSansTc(textStyle: TextStyle(fontSize: 60))),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Icon(Icons.lock, size: 80),
            ),
            Spacer(),
          ])),
    );
  }
}
