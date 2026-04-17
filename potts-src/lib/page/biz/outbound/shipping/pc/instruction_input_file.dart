import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../common/config/config.dart';
import '../../../../../common/localization/default_localizations.dart';
import '../../../../../common/style/wms_style.dart';
import '../../../../../file/wms_common_file.dart';
import '../bloc/instruction_input_bloc.dart';
import '../bloc/instruction_input_model.dart';

/**
 * 内容：出荷指示入力-文件
 * 作者：赵士淞
 * 时间：2023/08/03
 */
class InstructionInputFile extends StatefulWidget {
  const InstructionInputFile({super.key});

  @override
  State<InstructionInputFile> createState() => _InstructionInputFileState();
}

class _InstructionInputFileState extends State<InstructionInputFile> {
  // 当前悬停下标
  int currentHoverIndex = Config.NUMBER_NEGATIVE;

  // 初始化文件列表
  List<Widget> _initFileList(fileItemList, importFileCallBack) {
    // 文件列表
    List<Widget> fileList = [];
    // 循环文件单个列表
    for (int i = 0; i < fileItemList.length; i++) {
      // 文件列表
      fileList.add(
        MouseRegion(
          onEnter: (event) {
            // 状态变更
            setState(() {
              // 当前悬停下标
              currentHoverIndex = fileItemList[i]['index'];
            });
          },
          onExit: (event) {
            // 状态变更
            setState(() {
              // 当前悬停下标
              currentHoverIndex = Config.NUMBER_NEGATIVE;
            });
          },
          child: GestureDetector(
            onTap: () {
              // 判断循环下标
              if (fileItemList[i]['index'] == Config.NUMBER_ZERO) {
                // 打开加载状态
                BotToast.showLoading();
                // 导入CSV文件
                WMSCommonFile().importCSVFile(importFileCallBack);
              }
            },
            child: Container(
              height: 48,
              padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
              margin: EdgeInsets.fromLTRB(13, 0, 13, 13),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color.fromRGBO(224, 224, 224, 1),
                ),
                borderRadius: BorderRadius.circular(4),
                color: currentHoverIndex == fileItemList[i]['index']
                    ? Color.fromRGBO(0, 122, 255, 0.6)
                    : Color.fromRGBO(255, 255, 255, 1),
              ),
              child: Row(
                children: [
                  Image.asset(
                    fileItemList[i]['icon'],
                    width: 24,
                    height: 27.43,
                    color: currentHoverIndex == fileItemList[i]['index']
                        ? Color.fromRGBO(255, 255, 255, 1)
                        : Color.fromRGBO(0, 122, 255, 1),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(8, 0, 0, 0),
                    child: Text(
                      fileItemList[i]['title'],
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: currentHoverIndex == fileItemList[i]['index']
                            ? Color.fromRGBO(255, 255, 255, 1)
                            : Color.fromRGBO(0, 122, 255, 1),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    // 文件列表
    return fileList;
  }

  // 导入文件回调函数
  void _importFileCallBack(List<List<Map<String, dynamic>>> content) {
    // 导入CSV文件事件
    context.read<InstructionInputBloc>().add(ImportCSVFileEvent(content));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InstructionInputBloc, InstructionInputModel>(
      builder: (context, state) {
        // 文件单个列表
        List _fileItemList = [
          {
            'index': Config.NUMBER_ZERO,
            'icon': WMSICons.INSTRUCTION_INPUT_FILE_CSV,
            'title':
                WMSLocalizations.i18n(context)!.instruction_input_csv_download,
          },
        ];

        return Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, 27),
          child: Row(
            children: _initFileList(_fileItemList, _importFileCallBack),
          ),
        );
      },
    );
  }
}
