import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qreoh/entities/shop_item.dart';
import 'package:qreoh/global_providers.dart';
import 'package:qreoh/kastom.dart';
import 'package:qreoh/states/user_state.dart';

class ProfileShop extends ConsumerStatefulWidget {
  const ProfileShop({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileShopState();
}

class _ProfileShopState extends ConsumerState<ProfileShop> {
  List<ShopItem> _shopItems = [];
  late UserState _userState;

  Widget buyButton(ShopItem item) {
    if (_userState.collection.contains(item.id)) {
      if (_userState.banner.assetName == item.image.assetName) {
        return const ElevatedButton(onPressed: null, child: Text("Выбрано"));
      }
      return ElevatedButton(onPressed: () {
        ref.read(userStateProvider.notifier).selectItem(item);
      }, child: const Text("Выбрать"));
    }
    return ElevatedButton(
        onPressed: () {
                ref.read(userStateProvider.notifier).buyItem(item);
              },
        child: Text("${item.price}\$"));
  }

  Widget shopItem(ShopItem item) {
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
      color: Colors.cyan,
      height: 200,
      child: ListView(
          scrollDirection: Axis.horizontal,
          children: _shopItems
              .where((element) => element.type == ShopItemType.avatar)
              .map((item) => shopItem(item))
              .toList()),
    );
  }

  Widget bannerListWidget({required BuildContext context}) {
    return Container(
      color: Colors.greenAccent,
      height: 200,
      child: ListView(
          scrollDirection: Axis.horizontal,
          children: _shopItems
              .where((element) => element.type == ShopItemType.banner)
              .map((item) => shopItem(item))
              .toList()),
    );
  }

  @override
  void initState() {
    super.initState();
    ref.read(shopStateProvider.notifier).loadItems();
  }

  @override
  Widget build(BuildContext context) {
    _shopItems = ref.watch(shopStateProvider);
    _shopItems.sort((ShopItem a, ShopItem b) {
      return a.price.compareTo(b.price);
    });
    _userState = ref.watch(userStateProvider);
    print(_shopItems);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Магазин"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Chip(
                label: Text("Баланс: ${_userState.balance}\$"),
                backgroundColor: Colors.lightGreen,
              ),
              bannerListWidget(context: context),
              avatarListWidget(context: context),
            ],
          ),
        ),
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
