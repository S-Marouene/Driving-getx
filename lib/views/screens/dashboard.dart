import 'package:driving_getx/views/widgets/nav-drawer.dart';
import 'package:flutter/material.dart';

Widget Dashboard(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Bienvenu'),
    ),
    drawer: const NavDrawer(),
    body: Text("test dashboard screnn"),
  );
}
