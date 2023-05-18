import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qreoh/global_providers.dart';
import 'package:qreoh/screens/tasks/share/actions_list.dart';

import '../../../entities/shared_task.dart';
import '../attachments/attachment_list.dart';

class SharedTaskWidget extends ConsumerWidget {
  final SharedTask task;

  const SharedTaskWidget(this.task, {super.key});

  Widget build(BuildContext context, WidgetRef ref) {
    final friends = ref.read(friendsListStateProvider).friends;
    final receivers = task.receivers.map((e) {
      final s = friends.where((element) => element.uid == e.receiverId);
      if (s.isNotEmpty) {
        return s.first;
      }
    });
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.start,
            runSpacing: 6,
            children: [
              Text(
                task.name,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Visibility(
                visible: task.stringDate.isNotEmpty,
                child: const Divider(),
              ),
              Visibility(
                visible: task.stringDate.isNotEmpty,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Дедлайн",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(task.stringDate)
                  ],
                ),
              ),
              Visibility(
                visible: task.stringTimeLeft.isNotEmpty,
                child: const Divider(),
              ),
              Visibility(
                visible: task.stringTimeLeft.isNotEmpty,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Осталось",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(task.stringTimeLeft)
                  ],
                ),
              ),
              Visibility(
                visible: task.stringTimeRequired != null,
                child: const Divider(),
              ),
              Visibility(
                visible: task.stringTimeRequired != null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Необходимое время",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(task.stringTimeRequired ?? ""),
                  ],
                ),
              ),
              Visibility(
                visible: task.place != null,
                child: const Divider(),
              ),
              Visibility(
                visible: task.place != null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Место",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(task.place ?? ""),
                  ],
                ),
              ),
              Visibility(
                visible: task.description != null,
                child: const Divider(),
              ),
              Visibility(
                visible: task.description != null,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Описание",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(task.description ?? ""),
                    ],
                  ),
                ),
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Приложения",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AttachmentList(task.attachments),
                        ),
                      );
                    },
                    child: Text("Посмотреть"),
                  ),
                ],
              ),
              const Divider(),
              Row(
                children: const [
                  Text(
                    "Получатели",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              Wrap(
                direction: Axis.horizontal,
                runSpacing: 12,
                children: [
                  for (var receiver in receivers)
                    if (receiver != null)
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ActionsList(task.receivers
                                  .firstWhere((element) =>
                                      element.receiverId == receiver.uid)
                                  .actions, task.name),
                            ),
                          );
                        },
                        child: SizedBox(
                          height: 90,
                          width: 90,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 64,
                                width: 64,
                                child: CircleAvatar(
                                  backgroundImage: (receiver.profileImageUrl !=
                                          null)
                                      ? NetworkImage(receiver.profileImageUrl!)
                                      : null,
                                  radius: 32,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  receiver.login,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
