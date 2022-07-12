import 'package:flutter/material.dart';

class EmptyBunner extends StatelessWidget {
  const EmptyBunner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListTile(
        title: const Text(
          '🤔',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            'No robots yet...',
            style: TextStyle(
              fontSize: 24,
              color: Colors.black.withOpacity(0.67),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
