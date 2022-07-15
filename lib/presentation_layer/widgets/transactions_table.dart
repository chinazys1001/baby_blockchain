import 'package:baby_blockchain/presentation_layer/constants.dart';
import 'package:flutter/material.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';

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
    return HorizontalDataTable(
      leftHandSideColumnWidth: MediaQuery.of(context).size.width / 2,
      rightHandSideColumnWidth: MediaQuery.of(context).size.width / 2,
      isFixedHeader: true,
      headerWidgets: _getTitleWidget(),
      leftSideItemBuilder: _generateRobotIDsColumnRow,
      rightSideItemBuilder: _generateReceiverIDsColumnRow,
      itemCount: widget.receiverIDs.length,
      rowSeparatorWidget: const Divider(
        color: DisabledColor,
        height: 1,
        thickness: 0.0,
      ),
      leftHandSideColBackgroundColor: BackgroundColor,
      rightHandSideColBackgroundColor: ShadowColor,
    );
  }

  List<Widget> _getTitleWidget() {
    return [
      _getTitleItemWidget('Robot ID', MediaQuery.of(context).size.width / 2),
      _getTitleItemWidget('Receiver ID', MediaQuery.of(context).size.width / 2),
    ];
  }

  Widget _getTitleItemWidget(String label, double width) {
    return SizedBox(
      width: width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 56,
            alignment: Alignment.center,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: mediumFontSize,
                color: AccentColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _generateRobotIDsColumnRow(BuildContext context, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 52,
          alignment: Alignment.center,
          child: Text(
            widget.robotIDs[index],
            style: const TextStyle(
              fontSize: smallFontSize,
              color: DarkColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _generateReceiverIDsColumnRow(BuildContext context, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 52,
          alignment: Alignment.center,
          child: Text(
            widget.receiverIDs[index],
            style: const TextStyle(
              fontSize: smallFontSize,
              color: DarkColor,
            ),
          ),
        ),
      ],
    );
  }
}
