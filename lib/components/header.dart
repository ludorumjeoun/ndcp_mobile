import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ndcp_mobile/components/theme.dart';
import 'package:ndcp_mobile/services/auth/auth.dart';
import 'package:ndcp_mobile/services/frontend/router.dart';

class HeaderOptios {
  final bool canBack;
  final Widget? title;
  final List<Widget> actions;

  HeaderOptios({this.title, this.canBack = false, this.actions = const []});

  factory HeaderOptios.defaultOptions() {
    return HeaderOptios(canBack: false, actions: const []);
  }
}

class Header extends ConsumerStatefulWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;

  final String title;
  final HeaderOptios? options;

  Header(
    this.title, {
    this.options,
    Key? key,
  })  : preferredSize = const Size.fromHeight(56.0),
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
        actions: widget.options?.actions,
      );
    } else {
      // leading: logo and divider
      // title: title
      // actions: widget.actions
      return AppBar(
        leading: widget.options?.canBack == true
            ? IconButton(
                iconSize: 24,
                splashRadius: 24,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(16),
                icon: const Icon(Icons.arrow_back_ios_new),
                onPressed: () => ref.router(widget).pop(),
              )
            : Row(children: [
                Expanded(
                    child: SvgPicture.asset('assets/icons/app_header_logo.svg',
                        width: 88, height: 20, fit: BoxFit.fitHeight)),
                const SizedBox(
                  width: 1,
                  height: 20,
                  child: VerticalDivider(),
                ),
              ]),
        title: widget.options?.title ?? Row(children: [Text(widget.title)]),
        backgroundColor: AppColors.headerBackground,
        actions: widget.options?.actions,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        leadingWidth: widget.options?.canBack == true ? 56 : 116,
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
