import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qreoh/entities/customisation/custom_avatar.dart';
import 'package:qreoh/entities/customisation/custom_banner.dart';
import 'package:qreoh/entities/customisation/custom_item.dart';
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

  Widget selectButton(CustomItem item) {
    if (_selectedBanner?.id == item.id || _selectedAvatar?.id == item.id) {
      return ElevatedButton(
        style: ButtonStyle(
          elevation: MaterialStateProperty.all<double>(0),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          backgroundColor: MaterialStatePropertyAll<Color>(Colors.grey),
        ),
        onPressed: null,
        child: Text("Выбрано"),
      );
    }
    return ElevatedButton(
        style: ButtonStyle(
          elevation: MaterialStateProperty.all<double>(0),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        onPressed: () {
          if (item is CustomBanner) {
            setState(() {
              _selectedBanner = item;
            });
          } else {
            setState(() {
              _selectedAvatar = item as CustomAvatar;
            });
          }
        },
        child: const Text("Выбрать"));
  }

  Widget collectionItem(CustomItem item) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: Theme.of(context).colorScheme.secondary, width: 5),
          image: DecorationImage(image: item.asset, fit: BoxFit.cover),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            selectButton(item),
          ],
        ),
      ),
    );
  }

  Widget rewardItem(RewardItem item) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
          width: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: Theme.of(context).colorScheme.secondary, width: 5),
            image: DecorationImage(image: item.item.asset, fit: BoxFit.cover),
          ),
          child: (_userState!.level >= item.level)
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        ref
                            .read(userStateProvider.notifier)
                            .collectReward(item);
                      },
                      child: const Text("Получить"),
                    ),
                  ],
                )
              : Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Colors.black.withOpacity(0.7),
                  ),
                  child: Center(
                    child: Text(
                      "${item.level}",
                      style: const TextStyle(fontSize: 32, color: Colors.white),
                    ),
                  ),
                )),
    );
  }

  Widget rewardsList({required BuildContext context}) {
    return SizedBox(
      height: 200,
      child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          scrollDirection: Axis.horizontal,
          children: _rewardItems
              .where(
                  (element) => !_userState!.collection.contains(element.item))
              .map((item) => rewardItem(item))
              .toList()),
    );
  }

  bool checkForChanges() {
    return (_selectedBanner == null ||
            _selectedBanner?.id == _userState!.banner.id) &&
        (_selectedAvatar == null ||
            _selectedAvatar?.id == _userState!.avatar.id) &&
        (_newLogin == null || _userState!.login == _newLogin) &&
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

  Widget avatarsList({required BuildContext context}) {
    return SizedBox(
      height: 200,
      child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          scrollDirection: Axis.horizontal,
          children: _userState!.collection
              .where((element) => element.type == CustomItemType.avatar)
              .map((item) => collectionItem(item))
              .toList()),
    );
  }

  Widget bannerList({required BuildContext context}) {
    return SizedBox(
      height: 200,
      child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          scrollDirection: Axis.horizontal,
          children: _userState!.collection
              .where((element) => element.type == CustomItemType.banner)
              .map((item) => collectionItem(item))
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
          : Stack(
              children: [
                Stack(
                  children: [
                    Container(
                      height: 265,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: _selectedBanner?.asset ??
                                  _userState!.banner.asset,
                              fit: BoxFit.cover)),
                    ),
                    ClipRect(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                        child: Container(
                          height: 265,
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4)),
                          child: Center(
                            child: Image(
                              image: _selectedAvatar?.asset ??
                                  _userState!.avatar.asset,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Expanded(
                      child: ListView(
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap: selectPhoto,
                                        child: Stack(
                                          children: [
                                            Container(
                                              height: 100,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                border: const Border(
                                                  top: BorderSide(
                                                      color: Colors.grey,
                                                      width: 2),
                                                  left: BorderSide(
                                                      color: Colors.grey,
                                                      width: 2),
                                                  bottom: BorderSide(
                                                      color: Colors.grey,
                                                      width: 2),
                                                  right: BorderSide(
                                                      color: Colors.grey,
                                                      width: 2),
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: getProfileImage()),
                                            ),
                                            ClipRect(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                height: 100,
                                                width: 100,
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
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 32.0),
                                          child: TextFormField(
                                            initialValue: _userState?.login,
                                            onChanged: (String? value) {
                                              setState(() {
                                                _newLogin = value ?? _newLogin;
                                              });
                                            },
                                            maxLength: 16,
                                            decoration: InputDecoration(
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary),
                                              ),
                                              labelText: "Имя пользователя",
                                              labelStyle: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12, right: 12, top: 24),
                                  child: Text(
                                    "Мои персонажи",
                                    style: TextStyle(
                                      letterSpacing: 1,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: avatarsList(context: context),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12, right: 12, top: 24),
                                  child: Text(
                                    "Мои баннеры",
                                    style: TextStyle(
                                      letterSpacing: 1,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: bannerList(context: context),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12, right: 12, top: 24),
                                  child: Text(
                                    "Награды за уровень",
                                    style: TextStyle(
                                      letterSpacing: 1,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: rewardsList(context: context),
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 12),
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                            elevation: MaterialStateProperty
                                                .all<double>(0),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                          ),
                                          onPressed: checkForChanges()
                                              ? null
                                              : () {
                                                  ref
                                                      .read(userStateProvider
                                                          .notifier)
                                                      .selectRewardItem(
                                                          _selectedBanner,
                                                          _selectedAvatar);
                                                  print(_newLogin);
                                                  if (_newLogin !=
                                                      _userState!.login) {
                                                    ref
                                                        .read(userStateProvider
                                                            .notifier)
                                                        .updateLogin(
                                                            _newLogin!);
                                                  }
                                                  if (_imageFile != null &&
                                                      _imageFileChanged) {
                                                    ref
                                                        .read(userStateProvider
                                                            .notifier)
                                                        .updateProfileImage(
                                                            _imageFile!);
                                                  }
                                                },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12),
                                            child: const Text("Сохранить"),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
