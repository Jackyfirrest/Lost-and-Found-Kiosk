import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'functions/notion.dart';

class IdentifyObjectScreen extends StatefulWidget {
  const IdentifyObjectScreen(
      {super.key,
      required this.identifyResult,
      required this.image,
      required this.location});

  final Future identifyResult;
  final String location;
  final Uint8List image;

  @override
  State<IdentifyObjectScreen> createState() => _IdentifyObjectScreenState();
}

class _IdentifyObjectScreenState extends State<IdentifyObjectScreen> {
  var jsonresult;
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("請確認辨識結果", style: TextStyle(fontSize: 60)),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 40.0),
                child: DefaultTextStyle(
                  style: Theme.of(context).textTheme.bodyMedium!,
                  child: Card(
                    child: Container(
                      padding: const EdgeInsets.all(30),
                      margin: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: FutureBuilder(
                        future: widget.identifyResult,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            jsonresult = jsonDecode(snapshot.data);
                            final object = jsonresult['object'];
                            final descriptions = jsonresult['description'];
                            final color = jsonresult['color'];
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  object.toString().toUpperCase(),
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .headlineLarge!
                                          .fontSize,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  descriptions[0] +
                                      ', ' +
                                      descriptions[1] +
                                      ', ' +
                                      descriptions[2],
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .headlineMedium!
                                          .fontSize),
                                ),
                                Text(
                                  color[0] + ', ' + color[1],
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .headlineMedium!
                                          .fontSize),
                                ),
                              ],
                            );
                          } else {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircularProgressIndicator(),
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Text(
                                    '辨識中...',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .headlineMedium!
                                            .fontSize),
                                  ),
                                ),
                              ],
                            );
                          }
                        },
                      ),
                    ),
                  ),
                )),
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
                          label: Text("錯誤")),
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
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => EnterCellPhoneScreen(
                                      jsonScanResult: jsonresult,
                                      image: widget.image,
                                      location: widget.location,
                                    )));
                          },
                          icon: Icon(
                            Icons.check,
                            size: 45,
                          ),
                          label: Text("正確")),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class EnterCellPhoneScreen extends StatefulWidget {
  const EnterCellPhoneScreen(
      {super.key,
      required this.jsonScanResult,
      required this.image,
      required this.location});
  final jsonScanResult;
  final image;
  final String location;

  @override
  State<EnterCellPhoneScreen> createState() => _EnterCellPhoneScreenState();
}

class _EnterCellPhoneScreenState extends State<EnterCellPhoneScreen> {
  final _cellphoneNumberController = TextEditingController();
  bool isUploading = false;
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("請輸入手機號碼", style: TextStyle(fontSize: 60)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: TextField(
                    controller: _cellphoneNumberController,
                    decoration: InputDecoration(labelText: '輸入手機號碼'),
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
                              final oldText = _cellphoneNumberController.text;
                              if (oldText.isNotEmpty) {
                                _cellphoneNumberController.text =
                                    oldText.substring(0, oldText.length - 1);
                              }
                            },
                            child: Icon(Icons.arrow_back));
                      }
                      return OutlinedButton(
                          onPressed: () {
                            _cellphoneNumberController.text =
                                _cellphoneNumberController.text +
                                    index.toString();
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
                        setState(() {
                          isUploading = true;
                        });
                        uploadFoundObject(
                                widget.jsonScanResult,
                                widget.location,
                                _cellphoneNumberController.text)
                            .then((pageId) {
                          addPhotoToNotionPage(pageId, widget.image)
                              .then((value) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => DropSuccessScreen()));
                          });
                        });
                      },
                      icon: isUploading
                          ? Container()
                          : Icon(
                              Icons.check,
                              size: 45,
                            ),
                      label: isUploading
                          ? CircularProgressIndicator()
                          : Text("確認")),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class DropSuccessScreen extends StatefulWidget {
  const DropSuccessScreen({super.key});

  @override
  State<DropSuccessScreen> createState() => _DropSuccessScreenState();
}

class _DropSuccessScreenState extends State<DropSuccessScreen> {
  late final Future timer;
  @override
  void initState() {
    super.initState();
    timer = Future.delayed(Duration(seconds: 10)).then((v) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.ignore();
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
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("請將物品放入置物櫃中並關門", style: TextStyle(fontSize: 60)),
            Spacer(),
          ])),
    );
  }
}
