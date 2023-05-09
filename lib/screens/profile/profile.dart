import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qreoh/common_widgets/buttons.dart';
import 'package:qreoh/entities/achievement.dart';
import 'package:qreoh/firebase_functions/user.dart';
import 'package:qreoh/global_providers.dart';
import 'package:qreoh/states/user_state.dart';
import 'package:qreoh/strings.dart';
import 'package:transparent_image/transparent_image.dart';

class ProfileWidget extends ConsumerStatefulWidget {
  final UserState profile;
  final List<Achievement> achievements;

  const ProfileWidget(
      {super.key, required this.profile, required this.achievements});

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
                  Text(
                    "Условия: ",
                    style: TextStyle(
                        letterSpacing: 2,
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(achievement.condition),
                  ),
                  Text(
                    "Получено: ",
                    style: TextStyle(
                        letterSpacing: 2,
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                        widget.profile.achievements.contains(achievement.id)
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
              height: 250,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: widget.profile.banner, fit: BoxFit.cover)),
            ),
            ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  height: 250,
                  decoration:
                      BoxDecoration(color: Colors.black.withOpacity(0.4)),
                  child: Center(
                    child: Image(
                      image: widget.profile.avatar,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(10),
            children: [
              Row(
                children: [
                  Container(
                    height: 125,
                    width: 125,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 3.0),
                      borderRadius: BorderRadius.circular(12),
                      image: const DecorationImage(
                          image: AssetImage(Strings.defaultPfp),
                          fit: BoxFit.cover),
                    ),
                    child: widget.profile.profileImage != null ? DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: widget.profile.profileImage!,
                        fit: BoxFit.cover,
                      ),
                    ) : null,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 32.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              widget.profile.login,
                              style: TextStyle(
                                  letterSpacing: 2,
                                  color: Theme.of(context).colorScheme.secondary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24),
                            ),
                            Text(
                              "#${widget.profile.tag}",
                              style: const TextStyle(
                                  letterSpacing: 2,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ],
                        ),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.blueGrey,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Chip(label: Text("${widget.profile.level}")),
                                SizedBox(
                                  width: 100,
                                  height: 10,
                                  child: LinearProgressIndicator(
                                    value: widget.profile.experience / (widget.profile.level * 100),
                                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.lightGreenAccent),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )

                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  "Достижения",
                  style: TextStyle(
                      letterSpacing: 2,
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 24),
                ),
              ),
              achievementsList(),
              Text(
                "Статистика",
                style: TextStyle(
                    letterSpacing: 2,
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                    fontSize: 24),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.grey.withOpacity(0.3)
                                      : Colors.black.withOpacity(0.3),
                                  spreadRadius: 3,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            width: 185,
                            height: 100,
                            child: Column(
                              children: const [
                                SizedBox(
                                  height: 55,
                                  child: Text(
                                    "Создано заданий",
                                    style: TextStyle(
                                        letterSpacing: 2, fontSize: 15),
                                  ),
                                ),
                                Divider(),
                                Text(
                                  "50",
                                  style:
                                      TextStyle(letterSpacing: 2, fontSize: 15),
                                ),
                              ],
                            )),
                        Container(
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.grey.withOpacity(0.3)
                                      : Colors.black.withOpacity(0.3),
                                  spreadRadius: 3,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            width: 185,
                            height: 100,
                            child: Column(
                              children: const [
                                SizedBox(
                                  height: 55,
                                  child: Text(
                                    "Выполнено заданий",
                                    style: TextStyle(
                                        letterSpacing: 2, fontSize: 15),
                                  ),
                                ),
                                Divider(),
                                Text(
                                  "50",
                                  //widget.profile.totalTasksCount.toString(),
                                  style:
                                      TextStyle(letterSpacing: 2, fontSize: 15),
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.grey.withOpacity(0.3)
                                      : Colors.black.withOpacity(0.3),
                                  spreadRadius: 3,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            width: 185,
                            height: 100,
                            child: Column(
                              children: const [
                                SizedBox(
                                  height: 55,
                                  child: Text(
                                    "Процент выполненных заданий",
                                    style: TextStyle(
                                        letterSpacing: 2, fontSize: 15),
                                  ),
                                ),
                                Divider(),
                                Text(
                                  "50",
                                  style:
                                      TextStyle(letterSpacing: 2, fontSize: 15),
                                ),
                              ],
                            )),
                        Container(
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.grey.withOpacity(0.3)
                                      : Colors.black.withOpacity(0.3),
                                  spreadRadius: 3,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            width: 185,
                            height: 100,
                            child: Column(
                              children: const [
                                SizedBox(
                                  height: 55,
                                  child: Text(
                                    "Созданные задания для друзей",
                                    style: TextStyle(
                                        letterSpacing: 2, fontSize: 15),
                                  ),
                                ),
                                Divider(),
                                Text(
                                  "50",
                                  style:
                                      TextStyle(letterSpacing: 2, fontSize: 15),
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.grey.withOpacity(0.3)
                                      : Colors.black.withOpacity(0.3),
                                  spreadRadius: 3,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            width: 185,
                            height: 100,
                            child: Column(
                              children: const [
                                SizedBox(
                                  height: 55,
                                  child: Text(
                                    "Выполненные задания от друзей",
                                    style: TextStyle(
                                        letterSpacing: 2, fontSize: 15),
                                  ),
                                ),
                                Divider(),
                                Text(
                                  "50",
                                  //widget.profile.totalTasksCount.toString(),
                                  style:
                                      TextStyle(letterSpacing: 2, fontSize: 15),
                                ),
                              ],
                            )),
                        Container(
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? Colors.grey.withOpacity(0.3)
                                      : Colors.black.withOpacity(0.3),
                                  spreadRadius: 3,
                                  blurRadius: 5,
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            width: 185,
                            height: 100,
                            child: Column(
                              children: const [
                                SizedBox(
                                  height: 55,
                                  child: Text(
                                    "Процент выполненных заданий от друзей",
                                    style: TextStyle(
                                        letterSpacing: 2, fontSize: 15),
                                  ),
                                ),
                                Divider(),
                                Text(
                                  "50",
                                  style:
                                      TextStyle(letterSpacing: 2, fontSize: 15),
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                ],
              ),
              if (widget.profile.uid != FirebaseAuth.instance.currentUser!.uid)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ButtonDanger(
                      buttonText: "Удалить друга",
                      warningText: "Вы уверены?",
                      action: () {
                        ref
                            .read(friendsListStateProvider.notifier)
                            .deleteFriend(widget.profile);
                        Navigator.pop(context);
                      }),
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
    Paint paint = Paint()..color = Colors.blueGrey;
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
