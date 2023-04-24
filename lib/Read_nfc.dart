import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';



class NFCRead {
  nfcread() async {
    NfcManager.instance.isAvailable().then((bool isAvailable) {
      if (isAvailable) {
        // 処理を書く;
      } else {
        // 処理を書く;
      }
    });
    await NfcManager.instance.startSession(
      pollingOptions: {NfcPollingOption.iso14443, NfcPollingOption.iso15693},
      onDiscovered: (NfcTag tag) async {
        final ndef = Ndef.from(tag);
        if (ndef == null) {
          debugPrint('Tag is not compatible with NDEF');
          await NfcManager.instance.stopSession(errorMessage: 'error');
          return;
        } else {
          final message = await ndef.read();
          final tagValue = String.fromCharCodes(message.records.first.payload);
          await NfcManager.instance.stopSession();
        }
      },
      onError: (dynamic e) async {
        debugPrint('NFC error: $e');
        await NfcManager.instance.stopSession(errorMessage: 'error');
      },
    );
  }
}
