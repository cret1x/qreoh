import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qreoh/entities/achievement.dart';
import 'package:qreoh/firebase_functions/user.dart';
import 'package:qreoh/global_providers.dart';
import 'package:qreoh/states/user_state.dart';


class ProfileWidget extends ConsumerStatefulWidget {
  final UserState profile;
  final List<Achievement> achievements;
  const ProfileWidget({super.key, required this.profile, required this.achievements});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends ConsumerState<ProfileWidget> {

  void _showAchievementTip(Achievement achievement) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
          ),
          title: Text(achievement.name),
          content: Wrap(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Условия: ", style: TextStyle(
                      letterSpacing: 2,
                      color: Theme
                          .of(context)
                          .colorScheme
                          .secondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(achievement.condition),
                  ),
                  Text("Получено: ", style: TextStyle(
                      letterSpacing: 2,
                      color: Theme
                          .of(context)
                          .colorScheme
                          .secondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(widget.profile.achievements.contains(achievement.id)
                        ? "Да"
                        : "Нет"),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("ОК"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Widget achievementWidget(Achievement achievement) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          print(1111);
          _showAchievementTip(achievement);
        },
        child: Container(
          width: 120,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: widget.profile.achievements.contains(achievement.id)
                ? Colors.lightGreen
                : Colors.blueGrey,
            borderRadius: BorderRadius.circular(12),
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
                    border: Border.all(color: Colors.black, width: 3.0),
                    borderRadius:
                    const BorderRadius.all(Radius.elliptical(12, 10)),
                    image: DecorationImage(image: achievement.image),
                  ),
                ),
                Text(
                  achievement.name,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget achievementsList() {
    return SizedBox(
        height: 180,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: widget.achievements
              .map((achievement) => achievementWidget(achievement))
              .toList(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
             Container(
               height: 150,
               decoration: BoxDecoration(
                 image: DecorationImage(
                     image: widget.profile.banner,
                     fit: BoxFit.cover)
               ),
            ),
            ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4)
                  ),
                  child: Row(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 32),
                        height: 125,
                        width: 125,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Theme.of(context).colorScheme.primary, width: 3.0),
                          borderRadius: BorderRadius.circular(12),
                          image: const DecorationImage(
                              image: AssetImage("assets/images/banners/desert.jpg"),
                              fit: BoxFit.cover),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 32.0),
                        child: Text(widget.profile.login,
                          style: TextStyle(
                              letterSpacing: 2,
                              color: Theme
                                  .of(context)
                                  .colorScheme
                                  .secondary,
                              fontWeight: FontWeight.bold,
                              fontSize: 24),),
                      ),
                      Text("#${widget.profile.tag}",
                        style: const TextStyle(
                            letterSpacing: 2,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),),
                    ],
                  )
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(10),
            children: [
              Container(
                width: 300,
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Theme.of(context).colorScheme.primary, width: 1.0),
                ),
                child: const Image(image: AssetImage("graphics/avatars/av1.png"),),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  "Достижения",
                  style: TextStyle(
                      letterSpacing: 2,
                      color: Theme
                          .of(context)
                          .colorScheme
                          .secondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 24),
                ),
              ),
              achievementsList(),
              Text(
                "Статистика",
                style: TextStyle(
                    letterSpacing: 2,
                    color: Theme
                        .of(context)
                        .colorScheme
                        .secondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 24),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:[
                      Container(
                          padding: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            color: Colors.white12,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          width: 185,
                          height: 100,
                          child:Column(
                            children: const [
                              SizedBox(
                                height: 55,
                                child: Flexible(
                                  child: Text(
                                    "50",
                                    style: TextStyle(
                                        letterSpacing: 2,
                                        color: Colors.white,
                                        fontSize: 15),
                                  ),
                                ),
                              ),
                              Divider(color:Colors.white),
                              Text(
                                "50",
                                style: TextStyle(
                                    letterSpacing: 2,
                                    color: Colors.white,
                                    fontSize: 15),
                              ),
                            ],
                          )
                      ),
                      Container(
                          padding: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            color: Colors.white12,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          width: 185,
                          height: 100,
                          child:Column(
                            children: const [
                              SizedBox(
                                height: 55,
                                child: Flexible(
                                  child: Text(
                                    "Выполнено заданий",
                                    style: TextStyle(
                                        letterSpacing: 2,
                                        color: Colors.white,
                                        fontSize: 15),
                                  ),
                                ),
                              ),
                              Divider(color:Colors.white),
                              Text(
                                "50",
                                //widget.profile.totalTasksCount.toString(),
                                style: TextStyle(
                                    letterSpacing: 2,
                                    color: Colors.white,
                                    fontSize: 15),
                              ),
                            ],
                          )
                      ),
                    ],
                  ),
                  Text(""),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:[
                      Container(
                          padding: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            color: Colors.white12,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          width: 185,
                          height: 100,
                          child:Column(
                            children: const [
                              SizedBox(
                                height: 55,
                                child: Flexible(
                                  child: Text(
                                    "Процент выполненных заданий",
                                    style: TextStyle(
                                        letterSpacing: 2,
                                        color: Colors.white,
                                        fontSize: 15),
                                  ),
                                ),
                              ),
                              Divider(color:Colors.white),
                              Text(
                                "50",
                                style: TextStyle(
                                    letterSpacing: 2,
                                    color: Colors.white,
                                    fontSize: 15),
                              ),
                            ],
                          )
                      ),
                      Container(
                          padding: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            color: Colors.white12,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          width: 185,
                          height: 100,
                          child:Column(
                            children: const [
                              SizedBox(
                                height: 55,
                                child: Flexible(
                                  child: Text(
                                    "Созданные задания для друзей",
                                    style: TextStyle(
                                        letterSpacing: 2,
                                        color: Colors.white,
                                        fontSize: 15),
                                  ),
                                ),
                              ),
                              Divider(color:Colors.white),
                              Text(
                                "50",
                                style: TextStyle(
                                    letterSpacing: 2,
                                    color: Colors.white,
                                    fontSize: 15),
                              ),
                            ],
                          )
                      ),
                    ],
                  ),
                  Text(""),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:[
                      Container(
                          padding: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            color: Colors.white12,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          width: 185,
                          height: 100,
                          child:Column(
                            children: const [
                              SizedBox(
                                height: 55,
                                child: Flexible(
                                  child: Text(
                                    "Выполненные задания от друзей",
                                    style: TextStyle(
                                        letterSpacing: 2,
                                        color: Colors.white,
                                        fontSize: 15),
                                  ),
                                ),
                              ),
                              Divider(color:Colors.white),
                              Text(
                                "50",
                                //widget.profile.totalTasksCount.toString(),
                                style: TextStyle(
                                    letterSpacing: 2,
                                    color: Colors.white,
                                    fontSize: 15),
                              ),
                            ],
                          )
                      ),
                      Container(
                          padding: const EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                            color: Colors.white12,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          width: 185,
                          height: 100,
                          child:Column(
                            children: const [
                              SizedBox(
                                height: 55,
                                child: Flexible(
                                  child: Text(
                                    "Процент выполненных заданий от друзей",
                                    style: TextStyle(
                                        letterSpacing: 2,
                                        color: Colors.white,
                                        fontSize: 15),
                                  ),
                                ),
                              ),
                              Divider(color:Colors.white),
                              Text(
                                "50",
                                style: TextStyle(
                                    letterSpacing: 2,
                                    color: Colors.white,
                                    fontSize: 15),
                              ),
                            ],
                          )
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}

class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) async {
    Paint paint = Paint()
      ..color = Colors.blueGrey;
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
