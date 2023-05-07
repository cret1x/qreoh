import 'package:flutter/material.dart';
import 'package:qreoh/kastom.dart';

class MyShop extends StatefulWidget {
  const MyShop({super.key});

  @override
  State<StatefulWidget> createState() => Shop();
}

class Shop extends State<MyShop> {

List<Baner> baners = [];
List<Avatar> avatars =[];

  Widget conteiner({required AssetImage im, required int cost,required BuildContext context}) {
    final double categoryHeight = MediaQuery.of(context).size.height * 0.29 - 50;
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 5, left:5),
      height: categoryHeight,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
      child: Padding(
        padding: const EdgeInsets.all(7.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 90,
              height: 115,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black, width: 0.0),
                borderRadius: const BorderRadius.all(Radius.elliptical(12, 10)),
                image: DecorationImage(image: im),
                ),
            ),
            OutlinedButton(
                onPressed: (){},
                child: Text(cost.toString()),)
          ],
        ),
      ),
    );
  }

  Widget textbottonAvatar({required BuildContext context}) {
    return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: FittedBox(
          fit: BoxFit.fill,
          alignment: Alignment.topCenter,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
          itemCount: avatars.length,
          itemBuilder: (context, index){
          return conteiner(im:avatars[index].image, context: context, cost: avatars[index].cost);
          }
       ),
        ),
        ),
    );
  }

  Widget textbottonBaner({required BuildContext context}) {
    return SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: FittedBox(
          fit: BoxFit.fill,
          alignment: Alignment.topCenter,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
          itemCount: avatars.length,
          itemBuilder: (context, index){
          return conteiner(im:baners[index].image, context: context, cost: baners[index].cost);
          }
       ),
        ),
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: const Color(0xff555555),
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
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 450,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    textbottonBaner(
                        context: context
                    ),
                    textbottonAvatar(
                        context: context
                    ),
                    Container(
                      height: 10,
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {},
                        child: const Center(
                          child: Text(
                            "Update",
                            style: TextStyle(
                              fontSize: 23,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          CustomPaint(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
            painter: HeaderCurvedContainer(),
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