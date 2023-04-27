import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

// 削除
class NFCErase {
  
  nfcerase() {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var ndef = Ndef.from(tag);
      if (ndef == null || !ndef.isWritable) {
        print('消去に失敗しました');
        NfcManager.instance.stopSession();
        return;
      }

      //NFC内のデータを空文字で上書き
      String text = '';
      NdefRecord textRecord = NdefRecord.createText(text);
      NdefMessage message = NdefMessage([textRecord]);

      //消去(書き込み)
      await ndef.write(message);
      print('消去しました!"');
      NfcManager.instance.stopSession();
      return;
    });
  }
}
