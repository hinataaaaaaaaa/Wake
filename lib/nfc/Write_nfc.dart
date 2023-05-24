import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

// 書き込みクラス
class NFCWrite {
  nfcwrite(String id) {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      debugPrint(id);
      var ndef = Ndef.from(tag);
      //書き込み可能かどうか
      if (ndef == null || !ndef.isWritable) {
        debugPrint('書き込み失敗しました');
        NfcManager.instance.stopSession();
        return;
      }

      //レコードを生成
      NdefRecord textRecord = NdefRecord.createText(id);
      //レコード内にメッセージ生成
      NdefMessage message = NdefMessage([textRecord]);

      try {
        //NFCに書き込み
        await ndef.write(message);
        debugPrint('書き込みました!"');
      } catch (e) {
        print(e);
        NfcManager.instance.stopSession();
        return;
      }
    });
  }
}
