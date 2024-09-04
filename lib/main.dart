import 'package:flutter/material.dart';
import 'claimItemCheck.dart';
import 'package:camera/camera.dart';
import 'identifyObject.dart';
import 'functions/gemini.dart';
import 'functions/mjpeg.dart';
import 'package:process_run/shell.dart';

final shell = Shell();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await shell.run("sudo motion -c /home/ben-rpi/Desktop/local_stream.conf");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lost and Found Kiosk App',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 99, 173, 68)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Lost and Found Kiosk'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _locationController =
      TextEditingController.fromValue(const TextEditingValue(text: 'G07-公館'));
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
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
        padding: const EdgeInsets.all(80.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("智慧失物招領", style: TextStyle(fontSize: 60)),
              Spacer(
                flex: 1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(
                    flex: 1,
                  ),
                  ElevatedButton.icon(
                    icon: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Icon(
                        Icons.store,
                        size: 60,
                      ),
                    ),
                    label: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Text(
                        "拾獲失物",
                        style: TextStyle(fontSize: 60),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ScanObjectScreen(
                              location: _locationController.text)));
                    },
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.background),
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return ClaimPasscodeScreen();
                        }));
                      },
                      icon: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Icon(
                          Icons.shopping_bag,
                          size: 60,
                        ),
                      ),
                      label: Padding(
                        padding: const EdgeInsets.all(30),
                        child: Text("領取失物", style: TextStyle(fontSize: 60)),
                      )),
                  Spacer(
                    flex: 1,
                  )
                ],
              ),
              Spacer(
                flex: 1,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: TextField(
                  controller: _locationController,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              width: 2, color: Theme.of(context).primaryColor)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              width: 2, color: Theme.of(context).focusColor)),
                      labelText: 'Location'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ClaimPasscodeScreen extends StatefulWidget {
  const ClaimPasscodeScreen({super.key});

  @override
  State<ClaimPasscodeScreen> createState() => _ClaimPasscodeScreenState();
}

class _ClaimPasscodeScreenState extends State<ClaimPasscodeScreen> {
  final _passcodeController = TextEditingController();
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
              Text("請輸入領取驗證碼", style: TextStyle(fontSize: 60)),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: TextField(
                      controller: _passcodeController,
                      decoration: InputDecoration(labelText: '輸入領取驗證碼'),
                    ),
                  ),
                  Container(
                    height: 540,
                    width: 420,
                    padding: EdgeInsets.all(80),
                    child: GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 3,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      children: List.generate(11, (index) {
                        index = index + 1;
                        if (index == 10) index = 0;
                        if (index == 11) {
                          return OutlinedButton(
                              onPressed: () {
                                final oldText = _passcodeController.text;
                                if (oldText.isNotEmpty) {
                                  _passcodeController.text =
                                      oldText.substring(0, oldText.length - 1);
                                }
                              },
                              child: Icon(Icons.arrow_back));
                        }
                        return OutlinedButton(
                            onPressed: () {
                              _passcodeController.text =
                                  _passcodeController.text + index.toString();
                            },
                            child: Text(index.toString()));
                      }),
                    ),
                  )
                ],
              ),
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
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return ClaimItemCheckScreen(
                              passcode: _passcodeController.text,
                            );
                          }));
                        },
                        icon: Icon(
                          Icons.check,
                          size: 45,
                        ),
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

class ScanObjectScreen extends StatefulWidget {
  const ScanObjectScreen({super.key, required this.location});
  final String location;

  @override
  State<ScanObjectScreen> createState() => _ScanObjectScreenState();
}

class _ScanObjectScreenState extends State<ScanObjectScreen> {
  final _mjpegController = MjpegPreprocessorWithFrameGrabber();
  @override
  void initState() {
    super.initState();
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
              Text("請將物品放入掃描室中", style: TextStyle(fontSize: 60)),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40.0),
                child: Container(
                  //width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.height * 0.5,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        width: 0, color: Theme.of(context).primaryColor),
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Mjpeg(
                        stream: 'http://localhost:8081',
                        isLive: true,
                        preprocessor: _mjpegController,
                      )),
                ),
              ),
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
                        onPressed: () {
                          final imageU8List = _mjpegController.u8list;
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => IdentifyObjectScreen(
                                  identifyResult:
                                      identifyWithGemini(imageU8List),
                                  location: widget.location,
                                  image: imageU8List)));
                        },
                        icon: Icon(
                          Icons.camera_alt,
                          size: 45,
                        ),
                        label: Text("掃描")),
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
