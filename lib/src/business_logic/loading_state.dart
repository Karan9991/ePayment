import 'package:flutter/cupertino.dart';

class LoadingState extends ChangeNotifier{
  bool isLoading=false;
  loading(){
    isLoading=true;
    notifyListeners();
  }
  notLoading(){
    isLoading=false;
    notifyListeners();
  }

}
class ConfirmationLoadingState extends LoadingState{}
class ConfirmingPhotoLoadingState extends LoadingState{}
class AddSignatureLoadingState extends LoadingState{}
class DownloadPdfLoadingState extends LoadingState{}
class SendEmailLoadingState extends LoadingState{}