import 'package:flutter/material.dart';
import 'package:hello_me/models/ransom_words.dart';
import 'package:provider/provider.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'dart:ui' as ui;

import 'models/auth.dart';

const double ENABLEED_POSITION = 0.25;
const double DISABLED_POSITION = 0.05;

class SimpleSnappingSheet extends StatefulWidget {
  const SimpleSnappingSheet({Key? key}) : super(key: key);

  @override
  _SimpleSnappingSheetState createState() => _SimpleSnappingSheetState();
}

class _SimpleSnappingSheetState extends State<SimpleSnappingSheet> {
  final ScrollController listViewController = ScrollController();
  var snappingController = SnappingSheetController();

  List<SnappingPosition> enabledPositions = const [
    SnappingPosition.factor(
      grabbingContentOffset: GrabbingContentOffset.bottom,
      snappingCurve: Curves.easeInExpo,
      snappingDuration: Duration(seconds: 1),
      positionFactor: ENABLEED_POSITION,
    ),
    SnappingPosition.factor(
      grabbingContentOffset: GrabbingContentOffset.bottom,
      snappingCurve: Curves.easeInExpo,
      snappingDuration: Duration(seconds: 1),
      positionFactor: 1,
    ),
  ];
  List<SnappingPosition> disabledPositions = const [
    SnappingPosition.factor(
      grabbingContentOffset: GrabbingContentOffset.bottom,
      snappingCurve: Curves.easeInExpo,
      snappingDuration: Duration(seconds: 1),
      positionFactor: DISABLED_POSITION,
    ),
  ];
  bool enabled = true;

  void changeState() {
    setState(() {
      enabled = !enabled;
      snappingController.setSnappingSheetFactor(
          enabled ? ENABLEED_POSITION : DISABLED_POSITION);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SnappingSheet(
      controller: snappingController,
      child: Provider.of<WordModel>(context, listen: true).buildSuggestions(),
      lockOverflowDrag: false,
      snappingPositions: enabled ? enabledPositions : disabledPositions,
      grabbing: GrabbingWidget(changeState),
      grabbingHeight: 75,
      sheetAbove: enabled?SnappingSheetContent(
        draggable: false,
        child: AboveSheet(),
      ): null,
      sheetBelow: SnappingSheetContent(
        draggable: true,
        childScrollController: listViewController,
        child: BelowSheet(),
      ),
    );
  }
}

/// Widgets below are just helper widgets for this example

class GrabbingWidget extends StatelessWidget {
  final Function() changeState;
  String email = "";
  GrabbingWidget(this.changeState);

  @override
  Widget build(BuildContext context) {
    email = Provider.of<AuthRepository>(context, listen: false).user!.email!;
    return GestureDetector(
      onTap: () => changeState(),
      child: Container(
        alignment: Alignment.centerLeft,
        color: Colors.grey[400],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Text(
                "Welcome back, $email", //auth.email
                style: const TextStyle(fontSize: 14),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(Icons.keyboard_arrow_up),
            ),
          ],
        ),
      ),
    );
  }
}

class BelowSheet extends StatefulWidget {
  const BelowSheet({Key? key}) : super(key: key);

  @override
  _BelowSheetState createState() => _BelowSheetState();
}

class _BelowSheetState extends State<BelowSheet> {
  String email = "";
  String avatarPhoto = 'https://googleflutter.com/sample_image.jpg';
  var photo;
  @override
  void initState() {
    photo = Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image:
            DecorationImage(image: NetworkImage(avatarPhoto), fit: BoxFit.fill),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    email = Provider.of<AuthRepository>(context, listen: false).user!.email!;
    return Container(
      color: Colors.white,
      child: ListView(
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.all(10),
                child: photo,
              ),
              Expanded(
                flex: 7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        email,
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Container(
                      width: 140,
                      height: 30,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.lightBlue,
                        ),
                        onPressed: () {},
                        child: const Text(
                          "Change avatar",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AboveSheet extends StatelessWidget {
  const AboveSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ui.ImageFilter.blur(
          sigmaX: 3.0,
          sigmaY: 3.0,
        ),
        child: Container(
          color: Colors.transparent,
        ),
      ),
    );
  }
}
