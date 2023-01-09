import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ndcp_mobile/components/containers.dart';
import 'package:ndcp_mobile/components/forms/app_text_field.dart';
import 'package:ndcp_mobile/components/header.dart';
import 'package:ndcp_mobile/components/theme.dart';
import 'package:ndcp_mobile/services/auth/auth.dart';
import 'package:ndcp_mobile/services/auth/authorization.dart';
import 'package:ndcp_mobile/services/auth/workspace.dart';
import 'package:ndcp_mobile/services/backend/backend.dart';
import 'package:ndcp_mobile/services/backend/requests/login_request.dart';
import 'package:ndcp_mobile/services/fcm.dart';
import 'package:ndcp_mobile/components/forms/form.dart';
import 'package:ndcp_mobile/services/frontend/router.dart';

class FindWorkspaceModal extends ConsumerStatefulWidget {
  const FindWorkspaceModal({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      FindWorkspaceModalState();
}

class FindWorkspaceModalState extends ConsumerState<FindWorkspaceModal> {
  String workspaceId = '';
  Future<void> onSubmitted(Map<String, dynamic> fields) async {
    final workspace = await ref
        .read(backendProvider)
        .gatewayPublicAPI
        ?.findWorkspace(workspaceId)
        .then((value) => ref.router(widget).pop(value));
  }

  _form() {
    return NormalContainer(
      child: Column(
        children: [
          AppForm(
              dataset: FormDataSet(onSubmitted)
                  .addText(
                      label: '병원을 선택하세요',
                      id: 'workspace_id',
                      decoration: FormDataDecoration(
                          prefix:
                              const Icon(Icons.search, color: Colors.white)),
                      onChanged: (value) => workspaceId = value ?? '')
                  .addSubmit(label: '선택 완료'))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Input workspace id with text field
    // Button to submit
    // Box width is minimum size of screen width or height
    final boxWidth = min(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
    return Scaffold(
      appBar: Header('병원 선택',
          options: HeaderOptios(
            canBack: true,
            title: Container(
                height: 40,
                alignment: Alignment.centerLeft,
                child: AppTextField(
                  label: '대상 병원을 검색해주세요',
                  onChanged: (value) => workspaceId = value ?? '',
                )),
          )),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: SizedBox(
            width: boxWidth,
            height: 396,
            child: _form(),
          ),
        ),
      ),
    );
  }
}
