import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:e_payment/src/business_logic/add_fee.dart';
import 'package:e_payment/src/business_logic/auth/code_handling.dart';
import 'package:e_payment/src/business_logic/auth/forgot_password_provider.dart';
import 'package:e_payment/src/business_logic/auth/one_session_login.dart';
import 'package:e_payment/src/business_logic/auth/phone_auth_provider.dart';
import 'package:e_payment/src/business_logic/auth/renew_subscription.dart';
import 'package:e_payment/src/business_logic/auth/sign_in_provider.dart';
import 'package:e_payment/src/business_logic/auth/signup_provider.dart';
import 'package:e_payment/src/business_logic/date_picker_provider.dart';
import 'package:e_payment/src/business_logic/download_and_send_email_provider.dart';
import 'package:e_payment/src/business_logic/history_search_and_filter.dart';
import 'package:e_payment/src/business_logic/obscure_text_changer.dart';
import 'package:e_payment/src/business_logic/receipt_firestore.dart';
import 'package:e_payment/src/business_logic/loading_state.dart';
import 'package:e_payment/src/business_logic/final_receipt_details_to_photo.dart';
import 'package:e_payment/src/business_logic/image_provider.dart';
import 'package:e_payment/src/business_logic/original_photo_url.dart';
import 'package:e_payment/src/business_logic/recognize_photo_text.dart';
import 'package:e_payment/src/business_logic/retrieve_user_data.dart';
import 'package:e_payment/src/business_logic/save_pdf_file.dart';
import 'package:e_payment/src/business_logic/signature_provider.dart';
import 'package:e_payment/src/business_logic/siwtch_original_photo_final_receipt_photo.dart';
import 'package:e_payment/src/business_logic/upload_receipt_photo.dart';

List<SingleChildWidget> providers = [
  ChangeNotifierProvider<SignupProvider>(create: (_) => SignupProvider()),
  ChangeNotifierProvider<SignInProvider>(create: (_) => SignInProvider()),
  ChangeNotifierProvider<ResetPasswordProvider>(
      create: (_) => ResetPasswordProvider()),
  ChangeNotifierProvider<RetrieveUserDataProvider>(create: (_) => RetrieveUserDataProvider()),
  ChangeNotifierProvider<PhotoProvider>(create: (_) => PhotoProvider()),
  ChangeNotifierProvider<RecognizeText>(create: (_) => RecognizeText()),
  ChangeNotifierProvider<AddFee>(create: (_) => AddFee()),
  ChangeNotifierProvider<SignatureProvider>(create: (_) => SignatureProvider()),
  ChangeNotifierProvider<ReceiptDetailsToPhoto>(create: (_) => ReceiptDetailsToPhoto()),
  ChangeNotifierProvider<UploadReceiptPhoto>(create: (_) => UploadReceiptPhoto()),
  ChangeNotifierProvider<ReceiptFirestore>(create: (_) => ReceiptFirestore()),
  ChangeNotifierProvider<OriginalPhotoUrl>(create: (_) => OriginalPhotoUrl()),
  ChangeNotifierProvider<SwitchReceiptPhoto>(create: (_) => SwitchReceiptPhoto()),
  ChangeNotifierProvider<CodeHandling>(create: (_) => CodeHandling()),
  ChangeNotifierProvider<ConfirmationLoadingState>(create: (_) => ConfirmationLoadingState()),
  ChangeNotifierProvider<ConfirmingPhotoLoadingState>(create: (_) => ConfirmingPhotoLoadingState()),
  ChangeNotifierProvider<AddSignatureLoadingState>(create: (_) => AddSignatureLoadingState()),
  ChangeNotifierProvider<RenewSubscription>(create: (_) => RenewSubscription()),
  ChangeNotifierProvider<ObscureTextState>(create: (_) => ObscureTextState()),
  ChangeNotifierProvider<PhoneAuth>(create: (_) => PhoneAuth()),
  ChangeNotifierProvider<HistoryPageSearch>(create: (_) => HistoryPageSearch()),
  ChangeNotifierProvider<DatePickerProvider>(create: (_) => DatePickerProvider()),
  ChangeNotifierProvider<DownloadAndEmail>(create: (_) => DownloadAndEmail()),
  ChangeNotifierProvider<DownloadPdfLoadingState>(create: (_) => DownloadPdfLoadingState()),
  ChangeNotifierProvider<SendEmailLoadingState>(create: (_) => SendEmailLoadingState()),
  ChangeNotifierProvider<SaveFile>(create: (_) => SaveFile()),
  ChangeNotifierProvider<OneSessionLogin>(create: (_) => OneSessionLogin()),

];
