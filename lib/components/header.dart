import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ndcp_mobile/services/auth/auth.dart';

class Header extends ConsumerStatefulWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;

  final String title;

  Header(
    this.title, {
    Key? key,
  })  : preferredSize = const Size.fromHeight(50.0),
        super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => HeaderState();
}

class HeaderState extends ConsumerState<Header> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title:
          Row(children: [Text(ref.watch(authProvider).workspace?.name ?? '')]),
      backgroundColor: const Color.fromARGB(255, 0x2F, 0x3A, 0x79),
      leading: Row(children: [
        Expanded(
            child: SvgPicture.asset('assets/icons/app_header_logo.svg',
                width: 88, height: 20, fit: BoxFit.fitHeight)),
        const SizedBox(
          width: 1,
          height: 20,
          child: VerticalDivider(),
        ),
      ]),
      actions: [
        IconButton(
            splashRadius: 20,
            onPressed: () => {
                  // notifications list
                },
            icon: SvgPicture.asset('assets/icons/app_header_notifications.svg',
                width: 24, height: 28, fit: BoxFit.fitHeight)),
        IconButton(
            splashRadius: 20,
            onPressed: () => {
                  // drawer
                  Scaffold.of(context).openEndDrawer()
                },
            icon: SvgPicture.asset('assets/icons/app_header_drawer.svg',
                width: 28, height: 28, fit: BoxFit.fitHeight)),
      ],
      leadingWidth: 116,
    );
  }
}
