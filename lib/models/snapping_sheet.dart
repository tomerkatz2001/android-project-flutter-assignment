import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hello_me/models/avatar.dart';
import 'package:hello_me/models/ransom_words.dart';
import 'package:provider/provider.dart';
import 'package:snapping_sheet/snapping_sheet.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:ui' as ui;
import 'dart:io' as io;

import 'grabbing_bar.dart';
import 'auth.dart';

const double ENABLEED_POSITION = 0.3;
const double DISABLED_POSITION = 0.1;

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
  bool enabled = false;

  void changeState() {
    setState(() {
      print(snappingController.currentPosition);
      enabled = !enabled;
      snappingController.snapToPosition(
          enabled ? enabledPositions[0] : disabledPositions[0]);
      print(enabled);

    });
  }

  @override
  Widget build(BuildContext context) {
    return SnappingSheet(
      controller: snappingController,
      child: Provider.of<WordModel>(context, listen: true).buildSuggestions(),
      lockOverflowDrag: true,
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


class BelowSheet extends StatefulWidget {
  const BelowSheet({Key? key}) : super(key: key);

  @override
  _BelowSheetState createState() => _BelowSheetState();
}

class _BelowSheetState extends State<BelowSheet> {
  String email = "";
  String avatarPhoto = ""; //this is the download url of the avatar
  String _avater_img_path = "users/default/avatar.jpg"; //this is the path in firebase storage


  loadImage() async {
    if(_avater_img_path == "users/default/avatar.jpg"){
        var snapshot = await FirebaseFirestore.instance.collection('v1.0.0').doc("data").collection("users").doc(email).get();
        var data = snapshot.data();
        _avater_img_path = data==null?"users/default/avatar.jpg":data["avatar_path"];

    }
    Reference ref = FirebaseStorage.instance.ref(_avater_img_path);
    var url = await ref.getDownloadURL();
    setState(() {
      avatarPhoto = url;
    });
  }

  @override
  void initState() {
    super.initState();
    email = Provider.of<AuthRepository>(context, listen: false).user!.email!;
    loadImage();
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
                child: AvatarPhoto(photoURL: avatarPhoto).build(context),
              ),
              Expanded(
                flex: 7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        email,
                        style: const TextStyle(
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
                        onPressed: () => _changeAvatar(),
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


  void _changeAvatar() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if ( image == null){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'No image selected')),
      );
      return;
    }
    Reference ref = FirebaseStorage.instance.ref("users/$email").child("avatar.jpg");
    ref.putFile(io.File(image.path));

    await FirebaseFirestore.instance.collection('v1.0.0').doc("data").collection("users").doc(email).update(
        {"avatar_path":"users/$email/avatar.jpg"});

    _avater_img_path = "users/$email/avatar.jpg";

    String newPhoto= await FirebaseStorage.instance.ref(_avater_img_path).getDownloadURL();
    print(newPhoto);

    setState(() {
      avatarPhoto = newPhoto;
    });

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
