import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

// 削除
class NFCErase {
  nfcerase() {
    ValueNotifier<dynamic> result = ValueNotifier(null);
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var ndef = Ndef.from(tag);
      if (ndef == null || !ndef.isWritable) {
        result.value = '消去に失敗しました';
        NfcManager.instance.stopSession();
        return;
      }

      String text = '';
      NdefRecord textRecord = NdefRecord.createText(text);
      NdefMessage message = NdefMessage([textRecord]);

      await ndef.write(message);
      //await ndef.writeLock();
      result.value = '消去しました!"';
      NfcManager.instance.stopSession();
      return;
    });
  }
}
