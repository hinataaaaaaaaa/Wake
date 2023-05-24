import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

class NFCScan {
  
  String _generatedID = ""; // 生成されたIDを格納するためのローカル変数

  nfcscan(String generatedID) async {
    // 生成されたIDをローカル変数に保存
    _generatedID = generatedID;
    //デバイスが読み込み可能かどうか
    NfcManager.instance.isAvailable().then((bool isAvailable) {
      if (isAvailable) {
        debugPrint("このデバイスは読み込み可能です");
        // debugPrint(_generatedID);
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
        //NFC内のデータがNULLまたは書き込みができない状態であれば処理を終了 
        if (ndef == null || !ndef.isWritable) {
          debugPrint('失敗しました');
          NfcManager.instance.stopSession();
          return;
        } else {
          //書き込み処理に移行
          //レコードを生成
          NdefRecord textRecord = NdefRecord.createText(generatedID);
          //レコード内にメッセージ生成
          NdefMessage message = NdefMessage([textRecord]);
          //NFCに書き込み
          await ndef.write(message);
          debugPrint('書き込みました!"');
        }
      },
      onError: (dynamic e) async {
        debugPrint('NFC error: $e');
        await NfcManager.instance.stopSession(errorMessage: 'error');
      },
    );
  }
}
