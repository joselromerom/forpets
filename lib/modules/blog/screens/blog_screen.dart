import 'package:flutter/material.dart';

class BlogScreen extends StatefulWidget {
  const BlogScreen({Key? key}) : super(key: key);

  @override
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.fromLTRB(0, 200, 0, 0),
        child: Column(
          children: [
            const Text('Blog Screen'),
            Image.asset("assets/images/dogConstruccion.png")
          ],
        ),
      );
}
