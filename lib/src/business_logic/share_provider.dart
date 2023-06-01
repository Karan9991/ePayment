import 'dart:io';
import 'package:share_plus/share_plus.dart';


class ShareReceipt {
  File file;
  ShareReceipt({required this.file});
  share() async{
    await Share.shareFiles([file.path]);
  }
}