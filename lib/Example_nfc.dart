import 'package:flutter/material.dart';
import 'package:flutter_wake/nfc/Read_nfc.dart';
import 'package:flutter_wake/nfc/Scan_nfc.dart';
import 'package:nfc_manager/nfc_manager.dart';

class NFC extends StatefulWidget {
  const NFC({Key? key}) : super(key: key);

  @override
  State<NFC> createState() => _NFCState();
}

class _NFCState extends State<NFC> {
  ValueNotifier<dynamic> result = ValueNotifier(null);
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('NFC検証')),
        body: SafeArea(
          child: FutureBuilder<bool>(
            future: NfcManager.instance.isAvailable(),
            builder: (context, ss) => ss.data != true
                ? Center(child: Text('利用可能状況: ${ss.data}'))
                : Flex(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    direction: Axis.vertical,
                    children: [
                      Flexible(
                        flex: 2,
                        child: Container(
                          margin: const EdgeInsets.all(4),
                          constraints: const BoxConstraints.expand(),
                          decoration: BoxDecoration(border: Border.all()),
                          child: SingleChildScrollView(
                            child: ValueListenableBuilder<dynamic>(
                              valueListenable: result,
                              builder: (context, value, _) =>
                                  Text('${value ?? ''}'),
                            ),
                          ),
                        ),
                      ), 
                      Flexible(
                        flex: 3,
                        child: GridView.count(
                          padding: const EdgeInsets.all(4),
                          crossAxisCount: 2,
                          childAspectRatio: 4,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4,
                          children: [
                            //文字列入力フィールド
                            // TextField(
                            //   controller: _textEditingController,
                            //   decoration: const InputDecoration(
                            //     hintText: '書き込む文字列を入力してください',
                            //   ),
                            // ),
                            //読み込みボタン
                            ElevatedButton(
                              onPressed: () {
                                NFCRead().nfcread();
                              }, 
                              // onPressed: _ndefRead,
                              child: const Text('NFCを読み込む'),
                            ),
                            //書き込みボタン
                            ElevatedButton(
                              // onPressed: _ndefWrite,
                              //書き込み処理をファイル別にした処理
                               onPressed: () {
                                 NFCScan().nfcscan("1234");
                               },
                              child: const Text('NFCに書き込む'),
                            ),
                            //削除ボタン
                            ElevatedButton(
                              onPressed: _ndefErase,
                              child: const Text('NFCからデータを削除する'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  // 読み込み
  void _ndefRead() {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      result.value = tag.data;
      NfcManager.instance.stopSession();
    });
  }

  // 書き込み
  void _ndefWrite() {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var ndef = Ndef.from(tag);
      //書き込み不可の場合セッションを停止
      if (ndef == null || !ndef.isWritable) {
        result.value = '書き込み失敗しました';
        NfcManager.instance.stopSession(errorMessage: result.value);
        return;
      }

      String text = _textEditingController.text;
      NdefRecord textRecord = NdefRecord.createText(text);
      NdefMessage message = NdefMessage([textRecord]);

      try {
        await ndef.write(message);
        //await ndef.writeLock();
        result.value = '書き込みました!"';
        NfcManager.instance.stopSession();
      } catch (e) {
        result.value = e;
        NfcManager.instance.stopSession(errorMessage: result.value.toString());
        return;
      }
    });
  }

  // 削除
  void _ndefErase() {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var ndef = Ndef.from(tag);
      if (ndef == null || !ndef.isWritable) {
        result.value = '書き込み失敗しました';
        NfcManager.instance.stopSession(errorMessage: result.value);
        return;
      }

      String text = '';
      NdefRecord textRecord = NdefRecord.createText(text);
      NdefMessage message = NdefMessage([textRecord]);

      try {
        await ndef.write(message);
        //await ndef.writeLock();
        result.value = '消去しました!"';
        NfcManager.instance.stopSession();
      } catch (e) {
        result.value = e;
        NfcManager.instance.stopSession(errorMessage: result.value.toString());
        return;
      }
    });
  }
}
