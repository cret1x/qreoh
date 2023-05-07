import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../global_providers.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qreoh/states/achievements.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  @override
  State<StatefulWidget> createState() => ProfilePage();
}

//я это ебала

class ProfilePage extends State<ProfileWidget> {
  Widget textfield({@required hintText}) {
    return Material(
      shadowColor: Colors.grey,
      shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
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
      ),
    );
  }

  Widget conteiner({@required hintText, required BuildContext context, required Achievement achiv}) {
    final double categoryHeight = MediaQuery.of(context).size.height * 0.25 - 50;
    return Container(
      width: 130,
      margin: const EdgeInsets.only(right: 5, left:5),
      height: categoryHeight,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: const BorderRadius.all(Radius.circular(12.0)),
          image: DecorationImage(
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.grey.withOpacity(0.2), BlendMode.dstATop),
            image: const NetworkImage("https://img.freepik.com/premium-vector/white-texture-round-striped-surface-white-soft-cover_547648-928.jpg"),
          )
      ),
      child: Padding(
        padding: const EdgeInsets.all(7.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black, width: 0.0),
                borderRadius: const BorderRadius.all(Radius.elliptical(12, 10)),
              ),
            ),
            TextButton(
                onPressed: (){
                  AchievementDialog(context, achiv);
                },
                child: Text(achiv.name,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
            ),
          ],
        ),
      ),
    );
  }

  AchievementDialog(BuildContext context, Achievement achiv) {
    Widget cancelButton = TextButton(
      child: Text("Остаться"),
      onPressed:  () {Navigator.pop(context);},
    );

    AlertDialog alert = AlertDialog(
      title: Text(achiv.name),
      content: Column(
        children: <Widget>[
          const Text("Условия"),
          Text(achiv.condition),
          const Text("Получено"),
          Text(achiv.toString())
        ],
      ),
      actions: [
        cancelButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget textbotton({@required hintText, required BuildContext context}) {
    return Container(
      height: 180,
      width: 10,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: achievements.length,
          itemBuilder: (context, index){
          return conteiner(hintText: "ghj", context: context, achiv: achievements[index]);
          }
       ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color(0xff555555),
        leading: IconButton(
          icon: const Icon(
            Icons.settings,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 255, left: 10, right: 10),
            height: 500,
            width: 400,
            child: ListView(
              padding: const EdgeInsets.all(10),
              children: [
                textfield(
                  hintText: 'Username',
                ),
                textfield(
                  hintText: 'Email',
                ),
                TextField(
                  decoration: InputDecoration(
                      hintText: "Достижения",
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
                ),
                textbotton(hintText: "jjk", context: context),
                TextField(
                  decoration: InputDecoration(
                      hintText: "Статистика",
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
                ),
                Container(
                  child:Column(
                    children: [
                      TextButton(
                          onPressed: (){},
                          child: Text("Cозданные задания"),
                      ),
                      TextButton(
                        onPressed: (){},
                        child: Text("100"),
                      ),
                      TextButton(
                        onPressed: (){},
                        child: Text("Выполненные задания"),
                      ),
                      TextButton(
                        onPressed: (){},
                        child: Text("100"),
                      ),
                      TextButton(
                        onPressed: (){},
                        child: Text("50%"),
                      ),
                      TextButton(
                        onPressed: (){},
                        child: Text("Cозданные задания от друзей"),
                      ),
                      TextButton(
                        onPressed: (){},
                        child: Text("50"),
                      ),
                      TextButton(
                        onPressed: (){},
                        child: Text("Выполненные задания от друзей"),
                      ),
                      TextButton(
                        onPressed: (){},
                        child: Text("50"),
                      ),
                      TextButton(
                        onPressed: (){},
                        child: Text("50%"),
                      ),
                    ],
                  )
                ),
              ],
            ),
          ),
          CustomPaint(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
            painter: HeaderCurvedContainer(),
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
                  child: Text('     '),
                  //image: DecorationImage(
                    //fit: BoxFit.cover,
                    //image: Image.network('images/profile.png'),
                  //),
                ),
              ),
            ],
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
    Paint paint = Paint()
      ..color = Color(0xff555555);
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

/*
class ProfileWidget extends ConsumerStatefulWidget {
  const ProfileWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends ConsumerState<ProfileWidget> {
  bool _isOnline = false;

  @override
  Widget build(BuildContext context) {
    _isOnline = ref.watch(networkStateProvider);
    return Stack(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: Image(
            image: AssetImage(
                Theme.of(context).colorScheme.brightness == Brightness.light
                    ? "graphics/background2.jpg"
                    : "graphics/background5.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        Center(
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                decoration:
                    BoxDecoration(color: Colors.grey.shade200.withOpacity(0.5)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Center(
                    child: Wrap(
                      children: [
                        Text(
                          'Logged as ${FirebaseAuth.instance.currentUser!.email}',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
              Theme.of(context).colorScheme.brightness == Brightness.light
                  ? "graphics/background2.jpg"
                  : "graphics/background5.jpg"),
          fit: BoxFit.fill,
        ),
      ),
      child: Wrap(runSpacing: 12, children: [
        SizedBox(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Column(
                  children: [
                    const Text("Fuck me"),
                  ],
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
*/
