import 'package:flutter/material.dart';
import 'package:qreoh/entities/user_entity.dart';
import 'package:image_picker/image_picker.dart';


class MyProfileSettings extends StatefulWidget {
  const MyProfileSettings({super.key});

  @override
  State<StatefulWidget> createState() => ProfilePageSettings();
}


class ProfilePageSettings extends State<MyProfileSettings> {

  void save() {
  }

void cancel(){
  NewName = "";
  Navigator.pop(context);
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
  Widget textbotton({@required hintText, required void function}) {
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
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 20,
          ),
          onPressed: ( ) {
            Navigator.pushNamed(context, "/shop");
          },
        ),
        elevation: 0.0,
        backgroundColor: Color(0xff555555),
        actions: <Widget>[
          IconButton(
          icon: const Icon(
            Icons.edit,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () {

          },
          ),
        ]
      ),
      body: Stack(
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
                            function: save(),
                          ),
                          textbotton(
                            hintText: 'Cansel',
                            function: cancel(),
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
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.done),
            label: 'ToDoList',
            activeIcon: null,
            backgroundColor: Color(0xff555555),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.perm_identity),
            label: 'Profile',
            activeIcon: null,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Friends',
            activeIcon: null,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
            activeIcon: null,
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