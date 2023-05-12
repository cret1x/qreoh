import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qreoh/entities/customisation/custom_avatar.dart';
import 'package:qreoh/entities/customisation/custom_banner.dart';
import 'package:qreoh/entities/customisation/shop_item.dart';
import 'package:qreoh/global_providers.dart';
import 'package:qreoh/states/user_state.dart';

class ProfileShop extends ConsumerStatefulWidget {
  const ProfileShop({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileShopState();
}

class _ProfileShopState extends ConsumerState<ProfileShop> {
  List<ShopItem> _shopItems = [];
  UserState? _userState;

  Widget buyButton(ShopItem item) {
    if (_userState!.collection.contains(item.item)) {
      if (_userState!.banner.id == item.id ||
          _userState!.avatar.id == item.id) {
        return ElevatedButton(
            onPressed: null,
            style: ButtonStyle(
              elevation: MaterialStateProperty.all<double>(0),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            child: Text("Выбрано"));
      }
      return ElevatedButton(
          onPressed: () {
            ref.read(userStateProvider.notifier).selectShopItem(item);
          },
          style: ButtonStyle(
            elevation: MaterialStateProperty.all<double>(0),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          child: const Text("Выбрать"));
    }
    return ElevatedButton(
      onPressed: _userState!.balance < item.price
          ? null
          : () {
              ref.read(userStateProvider.notifier).buyItem(item);
            },
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        backgroundColor: MaterialStatePropertyAll<Color>(Colors.grey),
      ),
      child: Text("${item.price}\$"),
    );
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
          padding: const EdgeInsets.symmetric(horizontal: 4),
          scrollDirection: Axis.horizontal,
          children: _shopItems
              .where((element) => element.item is CustomAvatar)
              .map((item) => shopItem(item))
              .toList()),
    );
  }

  Widget bannerListWidget({required BuildContext context}) {
    return SizedBox(
      height: 200,
      child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          scrollDirection: Axis.horizontal,
          children: _shopItems
              .where((element) => element.item is CustomBanner)
              .map((item) => shopItem(item))
              .toList()),
    );
  }

  @override
  Widget build(BuildContext context) {
    _shopItems = ref.watch(shopStateProvider);
    _shopItems.sort((ShopItem a, ShopItem b) {
      return a.price.compareTo(b.price);
    });
    _userState = ref.watch(userStateProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Магазин"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Wrap(
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.start,
          children: (_userState == null || _shopItems.isEmpty)
              ? [
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
                ]
              : [
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Chip(
                        label: Text("Баланс: ${_userState!.balance}\$"),
                        backgroundColor: Colors.lightGreen,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 12, right: 12, top: 12),
                    child: Text(
                      "Персонажи",
                      style: TextStyle(
                        letterSpacing: 1,
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  avatarListWidget(context: context),
            Padding(
              padding:
              const EdgeInsets.only(left: 12, right: 12, top: 24),
              child: Text(
                "Баннеры",
                style: TextStyle(
                  letterSpacing: 1,
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
                  bannerListWidget(context: context),
                ],
        ),
      ),
    );
  }
}
