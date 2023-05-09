import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qreoh/common_widgets/buttons.dart';
import 'package:qreoh/global_providers.dart';
import 'package:qreoh/states/app_theme_state.dart';
import 'package:qreoh/strings.dart';

class SettingsWidget extends ConsumerStatefulWidget {
  const SettingsWidget({super.key});

  @override
  ConsumerState<SettingsWidget> createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends ConsumerState<SettingsWidget>
    with AutomaticKeepAliveClientMixin<SettingsWidget> {
  AppThemeState _appThemeState = AppThemeState.base();
  final List<String> _backgrounds = [
    "forest",
    "mountains",
    "sky",
    "flat",
  ];

  @override
  Widget build(BuildContext context) {
    _appThemeState = ref.watch(appThemeProvider);
    super.build(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  Strings.appTheme,
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Center(
                child: Wrap(
                  spacing: 5.0,
                  children: [
                    ChoiceChip(
                      label: const Text(Strings.themeSystem),
                      selected: _appThemeState.themeMode == ThemeMode.system,
                      onSelected: (bool selected) {
                        ref
                            .read(appThemeProvider.notifier)
                            .changeTheme(ThemeMode.system);
                      },
                    ),
                    ChoiceChip(
                      label: const Text(Strings.themeLight),
                      selected: _appThemeState.themeMode == ThemeMode.light,
                      onSelected: (bool selected) {
                        ref
                            .read(appThemeProvider.notifier)
                            .changeTheme(ThemeMode.light);
                      },
                    ),
                    ChoiceChip(
                      label: const Text(Strings.themeDark),
                      selected: _appThemeState.themeMode == ThemeMode.dark,
                      onSelected: (bool selected) {
                        ref
                            .read(appThemeProvider.notifier)
                            .changeTheme(ThemeMode.dark);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              Strings.appBackground,
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: _backgrounds
                .map((background) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          ref
                              .read(appThemeProvider.notifier)
                              .changeBackground(background);
                        },
                        child: Container(
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: _appThemeState.background == background
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.black,
                                width: 5),
                            image: DecorationImage(
                                image: AssetImage(
                                    "${Strings.backgroundsAssetFolder}$background/${Theme.of(context).brightness == Brightness.light ? 'light.jpg' : 'dark.jpg'}"),
                                fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ButtonDanger(
            buttonText: Strings.logOut,
            warningText: Strings.areYouSure,
            action: ref.read(authStateProvider.notifier).signOutUser,
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
