import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qreoh/entities/reward_item.dart';
import 'package:qreoh/entities/shop_item.dart';
import 'package:qreoh/global_providers.dart';
import 'dart:io';

import 'package:qreoh/screens/profile/profile_shop.dart';
import 'package:qreoh/states/user_state.dart';

class MyProfileSettings extends ConsumerStatefulWidget {
  const MyProfileSettings({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfilePageSettings();
}

class _ProfilePageSettings extends ConsumerState<MyProfileSettings> {
  UserState? _userState;
  File? imageFile;
  List<RewardItem> _rewardItems = [];
  final _loginController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ref.read(userStateProvider.notifier).getUser();
    ref.read(rewardsStateProvider.notifier).loadItems();
  }

  @override
  void dispose() {
    super.dispose();
    _loginController.dispose();
  }

  Widget buyButton(RewardItem item) {
    if (_userState!.collection.contains(item.id)) {
      if (_userState!.banner.assetName == item.image.assetName) {
        return const ElevatedButton(onPressed: null, child: Text("Выбрано"));
      }
      return ElevatedButton(
          onPressed: () {
            ref.read(userStateProvider.notifier).selectItemReward(item);
          },
          child: const Text("Выбрать"));
    }
    if (_userState!.level >= item.level) {
      return ElevatedButton(onPressed: () {
        ref.read(userStateProvider.notifier).collectReward(item);
      }, child: const Text("Получить"));
    } else {
      return ElevatedButton(onPressed: null, child: Text("Lvl ${item.level}"));
    }

  }

  Widget rewardIcon(RewardItem item) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: Theme.of(context).colorScheme.primary, width: 5),
          image: DecorationImage(image: item.image, fit: BoxFit.cover),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            buyButton(item),
          ],
        ),
      ),
    );
  }

  Widget avatarListWidget({required BuildContext context}) {
    return Container(
      height: 200,
      child: ListView(
          scrollDirection: Axis.horizontal,
          children: _rewardItems
              .where((element) => element.type == ShopItemType.avatar)
              .map((item) => rewardIcon(item))
              .toList()),
    );
  }

  Widget bannerListWidget({required BuildContext context}) {
    return Container(
      height: 200,
      child: ListView(
          scrollDirection: Axis.horizontal,
          children: _rewardItems
              .where((element) => element.type == ShopItemType.banner)
              .map((item) => rewardIcon(item))
              .toList()),
    );
  }

  void save() {
    if (imageFile != null) {}
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
        });
  }

  @override
  Widget build(BuildContext context) {
    _userState = ref.watch(userStateProvider);
    _rewardItems = ref.watch(rewardsStateProvider);
    _rewardItems.sort((RewardItem a, RewardItem b) {
      return a.level.compareTo(b.level);
    });
    if (_userState != null) {
      _loginController.text = _userState!.login;
    }
    return Scaffold(
        appBar: AppBar(actions: [
          IconButton(
            icon: const Icon(
              Icons.shopping_bag,
              size: 30,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ProfileShop()));
            },
          ),
        ]),
        body: _userState == null
            ? Center(
                child: Column(
                  children: const [CircularProgressIndicator()],
                ),
              )
            : Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 250,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: _userState!.banner, fit: BoxFit.cover)),
                      ),
                      ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                          child: Container(
                            height: 250,
                            decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.4)),
                            child: Center(
                              child: Image(
                                image: _userState!.avatar,
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
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    width: 3.0),
                                borderRadius: BorderRadius.circular(12),
                                image: const DecorationImage(
                                    image: AssetImage(
                                        "assets/images/banners/desert.jpg"),
                                    fit: BoxFit.cover),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 32.0),
                                child: TextFormField(
                                  controller: _loginController,
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary),
                                    ),
                                    labelText: "Имя пользователя",
                                    labelStyle: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            "Баннеры",
                            style: TextStyle(
                                letterSpacing: 2,
                                color: Theme.of(context).colorScheme.secondary,
                                fontWeight: FontWeight.bold,
                                fontSize: 24),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: bannerListWidget(context: context),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            "Аватары",
                            style: TextStyle(
                                letterSpacing: 2,
                                color: Theme.of(context).colorScheme.secondary,
                                fontWeight: FontWeight.bold,
                                fontSize: 24),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: avatarListWidget(context: context),
                        ),
                        ElevatedButton(
                            onPressed: () {}, child: const Text("Сохранить"))
                      ],
                    ),
                  ),
                ],
              )
        // Stack(
        //   alignment: Alignment.center,
        //   children: [
        //     Column(
        //       mainAxisAlignment: MainAxisAlignment.end,
        //       children: [
        //         Container(
        //           height: 400,
        //           width: double.infinity,
        //           margin: EdgeInsets.symmetric(horizontal: 10),
        //           child: Column(
        //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //             crossAxisAlignment: CrossAxisAlignment.end,
        //             children: [
        //               textfield(
        //                 hintText: 'Username',
        //               ),
        //               Container(
        //                 height: 180,
        //                 child: Column(
        //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //                   children: [
        //                     textbotton(
        //                       hintText: 'Save',
        //                       function: save,
        //                     ),
        //                     textbotton(
        //                       hintText: 'Cansel',
        //                       function: cancel,
        //                     ),
        //                   ],
        //                 ),
        //               )
        //             ],
        //           ),
        //         )
        //       ],
        //     ),
        //     CustomPaint(
        //       painter: HeaderCurvedContainer(),
        //       child: SizedBox(
        //         width: MediaQuery.of(context).size.width,
        //         height: MediaQuery.of(context).size.height,
        //       ),
        //     ),
        //     Column(
        //       crossAxisAlignment: CrossAxisAlignment.stretch,
        //       children: [
        //         Align(
        //           child: Container(
        //             height: 125,
        //             width: 125,
        //             margin: const EdgeInsets.only(top: 120, left: 40, right: 40),
        //             decoration: BoxDecoration(
        //               color: Colors.white,
        //               border: Border.all(color: Colors.black, width: 0.0),
        //               borderRadius: const BorderRadius.all(Radius.elliptical(50, 50)),
        //             ),
        //             child: Text(''),
        //             //image: DecorationImage(
        //             //fit: BoxFit.cover,
        //             //image: Image.network('images/profile.png'),
        //             //),
        //           ),
        //         ),
        //       ],
        //     ),
        //     Padding(
        //       padding: EdgeInsets.only(bottom: 270, left: 110, top:90),
        //       child: CircleAvatar(
        //         backgroundColor: Colors.black54,
        //         child: IconButton(
        //           icon: const Icon(
        //             Icons.edit,
        //             color: Colors.white,
        //           ),
        //           onPressed: () {
        //             selectPhoto();
        //           },
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
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
