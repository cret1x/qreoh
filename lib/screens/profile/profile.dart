import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../global_providers.dart';

class ProfileWidget extends ConsumerStatefulWidget {
  const ProfileWidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends ConsumerState<ProfileWidget> {
  bool _isOnline = false;

  @override
  Widget build(BuildContext context) {
    _isOnline = ref.watch(networkStateProvider);
    return Stack(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: Image(
            image: AssetImage(
                Theme.of(context).colorScheme.brightness == Brightness.light
                    ? "graphics/background2.jpg"
                    : "graphics/background5.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        Center(
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                decoration:
                    BoxDecoration(color: Colors.grey.shade200.withOpacity(0.5)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Center(
                    child: Wrap(
                      children: [
                        Text(
                          'Logged as ${FirebaseAuth.instance.currentUser!.email}',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
    return DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
              Theme.of(context).colorScheme.brightness == Brightness.light
                  ? "graphics/background2.jpg"
                  : "graphics/background5.jpg"),
          fit: BoxFit.fill,
        ),
      ),
      child: Wrap(runSpacing: 12, children: [
        SizedBox(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Column(
                  children: [
                    const Text("Fuck me"),
                  ],
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
