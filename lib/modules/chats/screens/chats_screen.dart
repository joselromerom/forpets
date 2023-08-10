import 'package:flutter/material.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.fromLTRB(0, 200, 0, 0),
        child: Column(
          children: [
            const Text('Chats Screen'),
            Image.asset("assets/images/dogConstruccion.png")
          ],
        ),
      );
}
