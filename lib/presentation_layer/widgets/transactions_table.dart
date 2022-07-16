import 'package:baby_blockchain/presentation_layer/constants.dart';
import 'package:flutter/material.dart';

class OperationsTable extends StatefulWidget {
  const OperationsTable({
    Key? key,
    required this.receiverIDs,
    required this.robotIDs,
  }) : super(key: key);

  final List<String> robotIDs;
  final List<String> receiverIDs;

  @override
  State<OperationsTable> createState() => _OperationsTableState();
}

class _OperationsTableState extends State<OperationsTable> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 2,
              color: AccentColor.withOpacity(0.07),
              child: Column(mainAxisSize: MainAxisSize.max),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 2,
              color: PrimaryLightColor.withOpacity(0.07),
              child: Column(mainAxisSize: MainAxisSize.max),
            ),
          ],
        ),
        Column(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      alignment: Alignment.center,
                      child: const Text(
                        "Robot ID",
                        style: TextStyle(
                          fontSize: mediumFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 16),
                      alignment: Alignment.center,
                      child: const Text(
                        "Receiver ID",
                        style: TextStyle(
                          fontSize: mediumFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(
                  color: DarkColor,
                  thickness: 1,
                  height: 0,
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: widget.robotIDs.length,
                itemBuilder: (_, index) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Divider(
                        color: Colors.black38,
                        thickness: 1,
                        height: 0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 2,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 16),
                            alignment: Alignment.center,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 3),
                              child: Text(
                                widget.robotIDs[index],
                                style: TextStyle(
                                  fontSize:
                                      MediaQuery.of(context).size.width < 400
                                          ? 12
                                          : MediaQuery.of(context).size.width <
                                                  mobileScreenMaxWidth
                                              ? 14
                                              : 16,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width / 2,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 16),
                            alignment: Alignment.center,
                            child: Text(
                              widget.receiverIDs[index],
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width < 400
                                        ? 12
                                        : MediaQuery.of(context).size.width <
                                                mobileScreenMaxWidth
                                            ? 14
                                            : 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
