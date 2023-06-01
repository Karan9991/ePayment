import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:e_payment/src/presentation/screen/home_screen.dart';

import '../../business_logic/auth/phone_auth_provider.dart';
import '../../business_logic/navigate_to_screen.dart';
import '../widget/confirm_action_button.dart';
import '../widget/form_text_field.dart';
import '../widget/login_success_alert.dart';

class PhoneAuthScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    PhoneAuth phoneAuth = Provider.of<PhoneAuth>(context);

    return WillPopScope(
      onWillPop: ()async=>false,
      child: Scaffold(
        body: Center(
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        const Expanded(
                          flex: 1,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "Verify your phone number",
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w700,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FormTextField(
                                fieldTitle: "Phone number:",
                                fieldHintText: "Enter your phone number:",
                                obscureText: false,
                                onChanged: (uNum) {
                                  phoneAuth.getPhoneNum(uNum);
                                },
                                btnTitle:phoneAuth.isSendPressed?
                                const Text("Please wait 50 seconds before send again",
                                  style: TextStyle(fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color:Colors.black26,
                                  fontFamily: "Poppins",),)
                                    :
                                const Text("Send OTP", style: TextStyle(fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Color.fromRGBO(0, 0, 254, 1),
                                  fontFamily: "Poppins",),)
                                ,
                                sendOtpBtn: () async {
                                  phoneAuth.isSendPressed?null:
                                  await phoneAuth.sendOTPPressed(context);

                                },
                                // errorText: signupProvider.userSubscriptionStatus,
                                isPhoneNumField: true,
                              ),
                              phoneAuth.otpVisibility
                                  ? // phone number
                                  Column(
                                      children: [
                                        FormTextField(
                                          fieldTitle: "OTP:",
                                          fieldHintText: "Enter OTP",
                                          obscureText: false,
                                          onChanged: (otp) async {
                                           await phoneAuth.getOtpCode(otp);
                                          },
                                          // errorText: signupProvider.userSubscriptionStatus,
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        ConfirmActionButton(
                                          onPressed: () async {
                                            HapticFeedback.vibrate();

                                            await phoneAuth.verifyOTPCode(context,const HomeScreen(),false);
                                          },
                                          buttonText: const Text(
                                            'Proceed',
                                            style: TextStyle(
                                              fontFamily: "Poppins",
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                        const Expanded(
                          flex: 1,
                          child: Column(),
                        ),
                         // Align(
                         //  alignment: Alignment.bottomRight,
                         //  child: GestureDetector(
                         //    onTap: (){
                         //      HapticFeedback.vibrate();
                         //      NavigateToScreen().navToScreen(context, const HomeScreen());
                         //      showDialog(
                         //          context: context, builder: (context) {
                         //
                         //        return  const LoginSuccessWidget();
                         //      }
                         //      );
                         //    },
                         //    child: const Text(
                         //      "Skip To Home Page >>",
                         //      style: TextStyle(
                         //        fontSize: 15,
                         //        fontFamily: "Poppins",
                         //        color:Colors.red,
                         //        fontWeight: FontWeight.bold
                         //      ),
                         //    ),
                         //  ),)
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


