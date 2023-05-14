import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qreoh/common_widgets/buttons.dart';
import 'package:qreoh/entities/achievement.dart';
import 'package:qreoh/global_providers.dart';
import 'package:qreoh/states/user_state.dart';
import 'package:qreoh/strings.dart';
import 'package:transparent_image/transparent_image.dart';

class ProfileWidget extends ConsumerStatefulWidget {
  final UserState profile;

  const ProfileWidget({super.key, required this.profile});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends ConsumerState<ProfileWidget> {
  List<Achievement> _achievements = [];

  int myAchievementComparison(Achievement a, Achievement b) {
    final propertyA = widget.profile.achievements.contains(a.id);
    final propertyB = widget.profile.achievements.contains(b.id);
    if (propertyA & !propertyB) {
      return -1;
    } else if (!propertyA & propertyB) {
      return 1;
    } else {
      return 0;
    }
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
                ? Theme.of(context).colorScheme.secondary
                : Colors.grey.shade300,
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
                Center(
                  child: Text(
                    achievement.name,
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.w400),
                    textAlign: TextAlign.center,
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
    _achievements.sort(myAchievementComparison);
    return SizedBox(
        height: 180,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          scrollDirection: Axis.horizontal,
          children: _achievements
              .map((achievement) => achievementWidget(achievement))
              .toList(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    _achievements = ref.watch(achievementsProvider);
    return Stack(
      children: [
        Stack(
          children: [
            Container(
              height: 265,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: widget.profile.banner.asset, fit: BoxFit.cover)),
            ),
            ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  height: 265,
                  decoration:
                      BoxDecoration(color: Colors.black.withOpacity(0.4)),
                  child: Center(
                    child: Image(
                      image: widget.profile.avatar.asset,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        ListView(
          children: [
            const SizedBox(
              height: 250,
            ),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 6,
                    blurRadius: 8, // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              border: const Border(
                                top: BorderSide(color: Colors.grey, width: 2),
                                left: BorderSide(color: Colors.grey, width: 2),
                                bottom:
                                    BorderSide(color: Colors.grey, width: 2),
                                right: BorderSide(color: Colors.grey, width: 2),
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: widget.profile.profileImageUrl != null
                                  ? DecoratedBox(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: FadeInImage.memoryNetwork(
                                        placeholder: kTransparentImage,
                                        image: widget.profile.profileImageUrl!,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : DecoratedBox(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Image.asset(
                                        Strings.defaultPfp,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16, top: 14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      widget.profile.login,
                                      style: TextStyle(
                                          letterSpacing: 2,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22),
                                    ),
                                    Text(
                                      "#${widget.profile.tag}",
                                      style: const TextStyle(
                                          letterSpacing: 2,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(right: 8, top: 12),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${widget.profile.level} ур.",
                                        style: const TextStyle(
                                            fontSize: 24,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(
                                        width: 18,
                                      ),
                                      SizedBox(
                                        width: 120,
                                        height: 15,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          child: LinearProgressIndicator(
                                            value: widget.profile.experience /
                                                Strings.xpToNewLevel,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .secondary),
                                            backgroundColor: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 36.0, left: 12, bottom: 6),
                      child: Text(
                        "Достижения (${widget.profile.achievements.length}/${_achievements.length})",
                        style: TextStyle(
                            letterSpacing: 1,
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 24),
                      ),
                    ),
                    achievementsList(),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 24, left: 12, bottom: 6),
                      child: Text(
                        "Статистика",
                        style: TextStyle(
                            letterSpacing: 1,
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 24),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Wrap(
                        runSpacing: 6,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Создано заданий"),
                              Text(
                                widget.profile.tasksCreated.toString(),
                              ),
                            ],
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Выполнено заданий"),
                              Text(
                                widget.profile.tasksCompleted.toString(),
                              ),
                            ],
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Процент выполненния заданий"),
                              Text(
                                "${widget.profile.tasksCreated <= 0 ? 0 : double.parse((widget.profile.tasksCompleted / widget.profile.tasksCreated * 100).toStringAsFixed(2))}%",
                              ),
                            ],
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Отправлено друзьям"),
                              Text(
                                widget.profile.tasksFriendsCreated.toString(),
                              ),
                            ],
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Получено заданий от друзей"),
                              Text(
                                widget.profile.tasksFromFriendsReceived
                                    .toString(),
                              ),
                            ],
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Выполнено заданий от друзей"),
                              Text(
                                widget.profile.tasksFriendsCompleted.toString(),
                              ),
                            ],
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                  "Процент выполнения заданий от друзей"),
                              Text(
                                "${widget.profile.tasksFromFriendsReceived <= 0 ? 0 : double.parse((widget.profile.tasksFriendsCompleted / widget.profile.tasksFromFriendsReceived * 100).toStringAsFixed(2))}%",
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (widget.profile.uid !=
                            FirebaseAuth.instance.currentUser!.uid &&
                        ref
                            .read(friendsListStateProvider)
                            .friends
                            .map((e) => e.uid)
                            .contains(widget.profile.uid))
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
            ),
          ],
        ),
      ],
    );
  }
}
