import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qreoh/entities/achievement.dart';
import 'package:qreoh/firebase_functions/user.dart';
import 'package:qreoh/global_providers.dart';
import 'package:qreoh/states/user_state.dart';


class ProfileWidget extends ConsumerStatefulWidget {
  const ProfileWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends ConsumerState<ProfileWidget> {
  late UserState _userState;
  List<Achievement> _allAchievements = [];

  @override
  void initState() {
    super.initState();
    ref.read(userStateProvider.notifier).getUser();
    ref.read(achievementsProvider.notifier).loadAchievements();
    _userState = ref.read(userStateProvider);
    _allAchievements = ref.read(achievementsProvider);
    print(_allAchievements);
  }

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
                    child: Text(_userState.achievements.contains(achievement.id)
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
            color: _userState.achievements.contains(achievement.id)
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
          children: _allAchievements
              .map((achievement) => achievementWidget(achievement))
              .toList(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomPaint(
          painter: HeaderCurvedContainer(),
          child: SizedBox(
            width: MediaQuery
                .of(context)
                .size
                .width,
          ),
        ),
        Container(
          height: 125,
          width: 125,
          margin: const EdgeInsets.only(top: 120, left: 40, right: 40),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black, width: 0.0),
            borderRadius: const BorderRadius.all(Radius.elliptical(50, 50)),
            image: DecorationImage(
                image: AssetImage("graphics/background3.jpg"),
                fit: BoxFit.cover),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 32),
            child: ListView(
              padding: const EdgeInsets.all(10),
              children: [
                Text(_userState.login,
                  style: TextStyle(
                      letterSpacing: 2,
                      color: Theme
                          .of(context)
                          .colorScheme
                          .secondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 24),),
                Text("#${_userState.tag}",
                  style: const TextStyle(
                      letterSpacing: 2,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),),
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
                Row(
                    children: [
                      const Text("Выполненные задания: "),
                      Text(_userState.totalTasksCount.toString()),
                    ]
                ),
              ],
            ),
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
