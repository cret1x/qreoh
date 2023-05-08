import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:qreoh/screens/profile/profile_shop.dart';


class MyProfileSettings extends StatefulWidget {
  const MyProfileSettings({super.key});

  @override
  State<StatefulWidget> createState() => ProfilePageSettings();
}


class ProfilePageSettings extends State<MyProfileSettings> {

  File? imageFile;

  void save() {
    if (imageFile != null) {
      
    }
  }

  void cancel(){
    NewName = "";
    clearImage();
    Navigator.pop(context);
  }

  Future pickImageGallary() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
 
    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    }
  }

  Future pickImageCamera() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
 
    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
    }
  }

  void clearImage() {
    setState(() {
      imageFile = null;
    });
  }

  void selectPhoto() {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text('Выбор фото'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  pickImageGallary();
                },
                child: const Text('Галерея'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  pickImageCamera();
                },
                child: const Text('Камера'),
              ),
            ],
          );
        }
      );
  }


  String NewName = "";

  Widget textfield({@required hintText}) {
    return Material(
      elevation: 10,
      shadowColor: Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        obscureText: true,
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              letterSpacing: 2,
              color: Colors.black54,
              fontWeight: FontWeight.bold,
            ),
            fillColor: Colors.white30,
            filled: true,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none)),
        onChanged: (text){
          NewName: text;
        },
      ),
    );
  }

  @override
  Widget textbotton({@required hintText, required Function function}) {
    return Material(
      elevation: 10,
      shadowColor: Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        height: 55,
        width: 400,
        child: FloatingActionButton.extended(
          onPressed: () {},
          label: Text(hintText,
            style: const TextStyle(
                color: Colors.white
            ),
          ),
          backgroundColor: Colors.grey,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
          icon: const Icon(
            Icons.edit,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                    const ProfileShop()));
          },
          ),
        ]
      ),
      body: true ? null : Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 400,
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    textfield(
                      hintText: 'Username',
                    ),
                    Container(
                      height: 180,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          textbotton(
                            hintText: 'Save',
                            function: save,
                          ),
                          textbotton(
                            hintText: 'Cansel',
                            function: cancel,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          CustomPaint(
            painter: HeaderCurvedContainer(),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                child: Container(
                  height: 125,
                  width: 125,
                  margin: const EdgeInsets.only(top: 120, left: 40, right: 40),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 0.0),
                    borderRadius: const BorderRadius.all(Radius.elliptical(50, 50)),
                  ),
                  child: Text(''),
                  //image: DecorationImage(
                  //fit: BoxFit.cover,
                  //image: Image.network('images/profile.png'),
                  //),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 270, left: 110, top:90),
            child: CircleAvatar(
              backgroundColor: Colors.black54,
              child: IconButton(
                icon: const Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
                onPressed: () {
                  selectPhoto();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Color(0xff555555);
    Path path = Path()
      ..relativeLineTo(0, 150)
      ..quadraticBezierTo(size.width / 2, 225, size.width, 150)
      ..relativeLineTo(0, -150)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}