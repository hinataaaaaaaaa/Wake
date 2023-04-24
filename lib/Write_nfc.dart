import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

// 書き込み
class NFCWrite {
  
  nfcwrite(TextEditingController textEditingController) {
    ValueNotifier<dynamic> result = ValueNotifier(null);

    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var ndef = Ndef.from(tag);
      if (ndef == null || !ndef.isWritable) {
        result.value = '書き込み失敗しました';
        NfcManager.instance.stopSession(errorMessage: result.value);
        return;
      }
      
      String text = textEditingController.text;
      NdefRecord textRecord = NdefRecord.createText(text);
      NdefMessage message = NdefMessage([textRecord]);

      try {
        await ndef.write(message);
        result.value = '書き込みました!"';
        NfcManager.instance.stopSession();
      } catch (e) {
        result.value = e;
        NfcManager.instance.stopSession(errorMessage: result.value.toString());
        return;
      }
    });
  }
}