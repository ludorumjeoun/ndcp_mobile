import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ndcp_mobile/components/theme.dart';

class AppTable extends ConsumerStatefulWidget {
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => AppTableState();

  int totalCount = 50;
  List<Widget> header() {
    return [
      Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 5,
        children: [
          Text('현재'),
          // bold and bigger
          Text(
            '$totalCount',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Text('명의 환자'),
          // divider
          const SizedBox(
            width: 1,
            height: 20,
            child: VerticalDivider(),
          ),
          // grey color
          Text('NEUL 케어중', style: const TextStyle(color: Colors.grey)),
        ],
      ),
      Wrap(
        direction: Axis.vertical,
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.start,
        spacing: 5,
        children: const [Text('LIVE'), Text('NEWS Score')],
      ),
      Wrap(
        direction: Axis.vertical,
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.start,
        spacing: 5,
        children: const [Text('LIVE'), Text('NEWS Score')],
      ),
      Wrap(
        direction: Axis.vertical,
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.start,
        spacing: 5,
        children: const [Text('LIVE'), Text('NEWS Score')],
      ),
    ];
  }
}

class AppTableState extends ConsumerState<AppTable> {
  @override
  Widget build(BuildContext context) {
    final columns = widget.header().map((e) => DataColumn(label: e)).toList();
    return Stack(children: [
      // Add rounded container
      Container(
        // set height 48
        width: 1000,
        height: 48,
        decoration: BoxDecoration(
            color: Colors.blueGrey, borderRadius: BorderRadius.circular(20)),
      ),
      Container(
          // set height 48
          width: 1000,
          height: 48,
          decoration: BoxDecoration(
              color: Colors.blueGrey, borderRadius: BorderRadius.circular(20)),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(columns: columns, rows: const [
              DataRow(cells: [
                DataCell(Text('A')),
                DataCell(Text('A')),
                DataCell(Text('A')),
                DataCell(Text('A'))
              ])
            ]),
          )),
    ]);
  }
}
