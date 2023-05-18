import 'package:flutter/material.dart';
import 'package:qreoh/firebase_functions/tasks.dart';
import 'package:qreoh/screens/tasks/share/shared_task.dart';

class SharedTaskListWidget extends StatelessWidget {
  final firebaseTaskManager = FirebaseTaskManager();

  SharedTaskListWidget({super.key});

  String _getDate(DateTime dt) {
    final str = dt.toString();
    return str.substring(0, str.length - 7);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Отправленные задачи"),
      ),
      body: FutureBuilder(
        future: firebaseTaskManager.getSharedTasks(),
        builder: (context, snapshot) => Column(
          children: [
            if (snapshot.hasData && snapshot.data != null)
              ListView.separated(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                shrinkWrap: true,
                itemBuilder: (context, index) => Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  SharedTaskWidget(snapshot.data![index]),),);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(snapshot.data![index].name),
                        Text(_getDate(snapshot.data![index].receivers[0].actions[0].date))
                      ],
                    ),
                  ),
                ),
                separatorBuilder: (context, index) => const Divider(),
                itemCount: snapshot.data!.length,
              )
          ],
        ),
      ),
    );
  }
}
