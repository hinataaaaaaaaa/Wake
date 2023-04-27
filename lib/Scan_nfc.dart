import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:flutter_wake/Write_nfc.dart';

class NFCScan {
  
  String _generatedID = ""; // 生成されたIDを格納するためのローカル変数

  nfcscan(String generatedID) async {
    // 生成されたIDをローカル変数に保存
    _generatedID = generatedID;
    //デバイスが読み込み可能かどうか
    NfcManager.instance.isAvailable().then((bool isAvailable) {
      if (isAvailable) {
        debugPrint("このデバイスは読み込み可能です");
        debugPrint(_generatedID);
      } else {
        debugPrint("このデバイスは読み込み不可です");
        return;
      }
    });
    //NFCリーダーをアクティブ状態にする
    await NfcManager.instance.startSession(
      pollingOptions: {NfcPollingOption.iso14443, NfcPollingOption.iso15693},
      //NFCをスキャンできたらonDiscoveredを呼び出し処理開始
      onDiscovered: (NfcTag tag) async {
        final ndef = Ndef.from(tag);
        //NFC内のデータがNULLであれば処理を終了（読み込み失敗）
        if (ndef == null) {
          debugPrint("値がNULLです");
          await NfcManager.instance.stopSession(errorMessage: 'error');
          return;
        } else {
          //書き込み処理に移行
          final writeNFC = NFCWrite();
          writeNFC.nfcwrite(_generatedID);
        }
      },
      onError: (dynamic e) async {
        debugPrint('NFC error: $e');
        await NfcManager.instance.stopSession(errorMessage: 'error');
      },
    );
  }
}
