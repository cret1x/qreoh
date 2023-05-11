import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qreoh/entities/customisation/custom_avatar.dart';
import 'package:qreoh/entities/customisation/custom_banner.dart';
import 'package:qreoh/entities/customisation/reward_item.dart';
import 'package:qreoh/entities/customisation/shop_item.dart';
import 'package:qreoh/global_providers.dart';
import 'dart:io';

import 'package:qreoh/screens/profile/profile_shop.dart';
import 'package:qreoh/states/user_state.dart';
import 'package:qreoh/strings.dart';
import 'package:transparent_image/transparent_image.dart';

class MyProfileSettings extends ConsumerStatefulWidget {
  const MyProfileSettings({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfilePageSettings();
}

class _ProfilePageSettings extends ConsumerState<MyProfileSettings> {
  UserState? _userState;
  File? _imageFile;
  String? _newLogin;
  bool _imageFileChanged = false;
  List<RewardItem> _rewardItems = [];
  CustomBanner? _selectedBanner;
  CustomAvatar? _selectedAvatar;
  final _loginController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _loginController.dispose();
  }

  Widget buyButton(RewardItem item) {
    if (_userState!.collection.contains(item.item)) {
      if (_selectedBanner?.id == item.id || _selectedAvatar?.id == item.id) {
        return const ElevatedButton(onPressed: null, child: Text("Выбрано"));
      }
      return ElevatedButton(
          onPressed: () {
            if (item.item is CustomBanner) {
              setState(() {
                _selectedBanner = item.item as CustomBanner;
              });
            } else {
              setState(() {
                _selectedAvatar = item.item as CustomAvatar;
              });
            }
          },
          child: const Text("Выбрать"));
    }
    if (_userState!.level >= item.level) {
      return ElevatedButton(
          onPressed: () {
            ref.read(userStateProvider.notifier).collectReward(item);
          },
          child: const Text("Получить"));
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
          image: DecorationImage(image: item.item.asset, fit: BoxFit.cover),
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
    return SizedBox(
      height: 200,
      child: ListView(
          scrollDirection: Axis.horizontal,
          children: _rewardItems
              .where((element) => element.item is CustomAvatar)
              .map((item) => rewardIcon(item))
              .toList()),
    );
  }

  bool checkForChanges() {
    return
        (_selectedBanner == null || _selectedBanner?.id == _userState!.banner.id) &&
        (_selectedAvatar == null || _selectedAvatar?.id == _userState!.avatar.id) &&
        !_imageFileChanged;
  }

  Widget getProfileImage() {
    if (_imageFile == null) {
      if (_userState?.profileImageUrl == null) {
        return Image.asset(
          Strings.defaultPfp,
          fit: BoxFit.cover,
        );
      }
      return FadeInImage.memoryNetwork(
        placeholder: kTransparentImage,
        image: _userState!.profileImageUrl!,
        fit: BoxFit.cover,
      );
    }
    return Image.file(
      _imageFile!,
      fit: BoxFit.cover,
    );
  }

  Widget bannerListWidget({required BuildContext context}) {
    return SizedBox(
      height: 200,
      child: ListView(
          scrollDirection: Axis.horizontal,
          children: _rewardItems
              .where((element) => element.item is CustomBanner)
              .map((item) => rewardIcon(item))
              .toList()),
    );
  }

  Future pickImageGallery() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
        _imageFileChanged = true;
        Navigator.pop(context);
      });
    }
  }

  Future pickImageCamera() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
        _imageFileChanged = true;
        Navigator.pop(context);
      });
    }
  }

  void clearImage() {
    setState(() {
      _imageFile = null;
    });
  }

  void selectPhoto() {
    showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
            ),
            title: const Text('Выбор фото'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  pickImageGallery();
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
    _selectedAvatar ??= _userState?.avatar;
    _selectedBanner ??= _userState?.banner;
    ref.listen(userStateProvider, (prev, next) {
      _selectedBanner = next?.banner;
      _selectedAvatar = next?.avatar;
      _newLogin ??= _userState?.login;
    });
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
          icon: const Icon(
            Icons.shopping_bag,
            size: 30,
          ),
          onPressed: () async {
            await Navigator.push(context,
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
                              image: _selectedBanner?.asset ?? _userState!.banner.asset,
                              fit: BoxFit.cover)),
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
                              image:
                                  _selectedAvatar?.asset ?? _userState!.avatar.asset,
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
                          InkWell(
                            onTap: selectPhoto,
                            child: Stack(
                              children: [
                                Container(
                                  height: 125,
                                  width: 125,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        width: 3.0),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: getProfileImage(),
                                ),
                                ClipRect(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    height: 125,
                                    width: 125,
                                    child: const Center(
                                      child: Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 32.0),
                              child: TextFormField(
                                initialValue: _userState?.login,
                                onChanged: (String? value) {
                                  setState(() {
                                    _newLogin = value ?? _newLogin;
                                  });
                                },
                                maxLength: 16,
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
                        onPressed: checkForChanges()
                            ? null
                            : () {
                            ref.read(userStateProvider.notifier).selectRewardItem(_selectedBanner, _selectedAvatar);

                                  if(  _newLogin != _userState!.login) {
                                  ref
                                      .read(userStateProvider.notifier)
                                      .updateLogin(_newLogin!);
                                }
                                if (_imageFile != null && _imageFileChanged) {
                                  ref
                                      .read(userStateProvider.notifier)
                                      .updateProfileImage(_imageFile!);
                                }
                              },
                        child: const Text("Сохранить"),
                      )
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}