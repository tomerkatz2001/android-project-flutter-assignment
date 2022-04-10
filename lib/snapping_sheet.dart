import 'package:flutter/material.dart';
import 'package:snapping_sheet/snapping_sheet.dart';

const double ENABLEED_POSITION = 0.2;
const double DISABLED_POSITION = 0.1;

class SimpleSnappingSheet extends StatefulWidget {
  final Widget background;
  const SimpleSnappingSheet({Key? key, required this.background}) : super(key: key);

  @override
  _SimpleSnappingSheetState createState() => _SimpleSnappingSheetState(background);
}

class _SimpleSnappingSheetState extends State<SimpleSnappingSheet> {

  final ScrollController listViewController = ScrollController();
  var snappingController = SnappingSheetController();

  List<SnappingPosition> enabledPositions = [
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
      positionFactor: 0.5,
    ),
  ];
  List<SnappingPosition> disabledPositions = [
    SnappingPosition.factor(
      grabbingContentOffset: GrabbingContentOffset.bottom,
      snappingCurve: Curves.easeInExpo,
      snappingDuration: Duration(seconds: 1),
      positionFactor: DISABLED_POSITION,
    ),
  ];
  bool enabled = true;
  var _background ;
  _SimpleSnappingSheetState(this._background);

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
      child: _background,
      lockOverflowDrag: false,
      snappingPositions: enabled ? enabledPositions : disabledPositions,
      grabbing: GrabbingWidget(changeState),
      grabbingHeight: 75,
      sheetAbove: null,
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

  GrabbingWidget(this.changeState);

  @override
  Widget build(BuildContext context) {
    return //Consumer<AuthRepository>(builder: (context, auth, child) {
      GestureDetector(
        onTap: () => changeState(),
        child: Container(
          alignment: Alignment.centerLeft,
          color: Colors.grey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Text(
                  "Welcome back,", //auth.email
                  style: TextStyle(fontSize: 14),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Icon(Icons.keyboard_arrow_up),
              ),
            ],
          ),
        ),
      );
    //}
  }
}

class BelowSheet extends StatefulWidget {
  const BelowSheet({Key? key}) : super(key: key);

  @override
  _BelowSheetState createState() => _BelowSheetState();
}

class _BelowSheetState extends State<BelowSheet> {

  String avatarPhoto = 'https://googleflutter.com/sample_image.jpg';
  var photo;
  @override
  void initState() {
    photo = Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
            image: NetworkImage(avatarPhoto),
            fit: BoxFit.fill),
      ),
    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
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
                    const Padding(
                      padding: EdgeInsets.all(10),
                      child: const Text("Welcome back, "),
                    ),
                    Container(
                      width: 130,
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
