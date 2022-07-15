import 'package:flutter/material.dart';

class NoOwnedRobotsBanner extends StatelessWidget {
  const NoOwnedRobotsBanner({Key? key}) : super(key: key);

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

class NoRobotsToTradeBanner extends StatelessWidget {
  const NoRobotsToTradeBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListTile(
        title: const Text(
          '🤯',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            'You should own at least one robot\nto be able to transfer ownership...',
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

class EmptyMempoolBanner extends StatelessWidget {
  const EmptyMempoolBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListTile(
        title: const Text(
          '😎',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            'Mempool is currently empty...',
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

class NoOperationsBanner extends StatelessWidget {
  const NoOperationsBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListTile(
        title: const Text(
          '🧐',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 50,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(
            'No operations so far...',
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
