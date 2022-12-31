import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ndcp_mobile/components/theme.dart';
import 'package:ndcp_mobile/services/auth/auth.dart';

class Header extends ConsumerStatefulWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;

  final String title;
  final List<Widget> actions;

  Header(
    this.title, {
    this.actions = const [],
    Key? key,
  })  : preferredSize = const Size.fromHeight(50.0),
        super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => HeaderState();
}

class HeaderState extends ConsumerState<Header> {
  _beforeSignedAppBar() {
    if (widget.title.isEmpty) {
      // leading: nothing
      // title: logo
      // actions: widget.actions
      return AppBar(
        title: Row(children: [
          Expanded(
              child: SvgPicture.asset('assets/icons/app_header_logo.svg',
                  width: 88, height: 20, fit: BoxFit.fitHeight)),
        ]),
        backgroundColor: AppColors.headerBackground,
        leading: null,
        actions: widget.actions,
      );
    } else {
      // leading: logo and divider
      // title: title
      // actions: widget.actions
      return AppBar(
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
        title: Row(children: [Text(widget.title)]),
        backgroundColor: AppColors.headerBackground,
        actions: widget.actions,
        leadingWidth: 116,
      );
    }
  }

  _signedAppBar() {
    // leading: logo and divider
    // title: workspace name
    // actions: notifications and open drawer
    return AppBar(
      title:
          Row(children: [Text(ref.watch(authProvider).workspace?.name ?? '')]),
      backgroundColor: AppColors.headerBackground,
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

  @override
  Widget build(BuildContext context) {
    return ref.watch(authProvider).isSignedIn
        ? _signedAppBar()
        : _beforeSignedAppBar();
  }
}
