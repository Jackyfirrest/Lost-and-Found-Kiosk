import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:convert';

class IdentifyObjectScreen extends StatefulWidget {
  const IdentifyObjectScreen(
      {super.key,
      required this.identifyResult,
      required this.image,
      required this.location});

  final Future identifyResult;
  final String location;
  final XFile image;

  @override
  State<IdentifyObjectScreen> createState() => _IdentifyObjectScreenState();
}

class _IdentifyObjectScreenState extends State<IdentifyObjectScreen> {
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
                            final jsonresult = jsonDecode(snapshot.data);
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
                          onPressed: () {},
                          icon: Icon(
                            Icons.check,
                            size: 45,
                          ),
                          label: Text("確認")),
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
