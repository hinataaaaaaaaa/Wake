import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'dart:convert';

String _tagvalue = "";

class NFCRead {
  nfcread() async {
    //NFCリーダーをアクティブ状態にする
    await NfcManager.instance.startSession(
      pollingOptions: {NfcPollingOption.iso14443, NfcPollingOption.iso15693},
      //NFCをスキャンできたらonDiscoveredを呼び出し処理開始
      onDiscovered: (NfcTag tag) async {
        final ndef = Ndef.from(tag);
        //NFC内のデータがNULLであれば処理を終了（読み込み失敗）
        if (ndef == null) {
          debugPrint("読み取り失敗");
          await NfcManager.instance.stopSession(errorMessage: 'error');
          return;
        } else {
          //NFC内のデータ読み取り
          final message = await ndef.read();
          //NFC内のレコード(最初に入っているデータ)を取り出す
          final tagValue = await String.fromCharCodes(message.records.first.payload);
          //debugPrint(utf8.encode(tagValue) as String?);
          //debugPrint(tagValue.runtimeType as String?);
          _tagvalue = tagValue;
        }
      },
      onError: (dynamic e) async {
        debugPrint('NFC error: $e');
        await NfcManager.instance.stopSession(errorMessage: 'error');
      },
    );
  }
}
