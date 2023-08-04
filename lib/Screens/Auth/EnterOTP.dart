import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:weei/Helper/Const.dart';
import 'package:weei/Helper/Toast.dart';
import 'package:weei/Screens/Auth/Data/auth.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class EnterOTP extends StatefulWidget {
  final verificationId;
  final number;
  final code;
  EnterOTP({this.verificationId, this.number,this.code}) : super();

  @override
  _EnterOTPState createState() => _EnterOTPState();
}

class _EnterOTPState extends State<EnterOTP> {
  TextEditingController otpController = TextEditingController();
   var loading=false;
   var resendOtp=false;
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();
  var stopWatchTime =0;

  @override
  void initState() {
    this.countDown();
  }
  @override
  void dispose() {
    _stopWatchTimer.onStopTimer();


// Reset timer
    _stopWatchTimer.onResetTimer();
    _stopWatchTimer.dispose();
  }
  countDown(){
    _stopWatchTimer.onStartTimer();



    _stopWatchTimer.secondTime.listen((value) {

        if(value<59){
          setState(() {

              stopWatchTime=  (60-value);

          });
        }else{
          stopWatchTime =0;
          resendOtp=true;
          _stopWatchTimer.onStopTimer();


// Reset timer
          _stopWatchTimer.onResetTimer();
        }


    });
  }



  @override
  Widget build(BuildContext context) {



    return Scaffold(
      backgroundColor: bgClr,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0.1),
        child: AppBar(
          elevation: 0,
          backgroundColor: bgClr,
        ),
      ),
      body: Column(
        children: [
          h(37),
          Center(child: SvgPicture.asset("assets/svg/weei.svg")),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Text("Verification Code", style: size16_600W),
                  h(30),
                   Text(
                    "We have sent you 6 digit OTP to  \n+"+(widget.code.toString()+widget.number.toString()),
                    textAlign: TextAlign.center,
                    style: size14_500Grey,
                  ),
                  h(30),
                  otp(),
                  h(30),
                  loading == true ?  SizedBox(
                    height: 25,
                    width: 25,
                    child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3
                    ),
                  ):Container()
                ],
              ),
            ),
          ),
          resendOtp==true?Text("Didn’t receive the OTP?", style: size14_500Grey):Container(),
          h(5),
          resendOtp==true?GestureDetector(onTap: ()async{

            showToastSuccess("Resending OTP");
            var rsp = await phoneSignIn(
                phoneNumber: widget.number,
                contxt: context,
                cod: widget.code,
                replace: true

            );

          },child: Text("Resend Code", style: size14_600G)):Container(),
          h(15),
        ],
      ),
    );
  }



  otp() {
    return Padding(
      padding:  EdgeInsets.only(left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          PinCodeTextField(
            appContext: context,
            mainAxisAlignment: MainAxisAlignment.center,
            autovalidateMode: AutovalidateMode.always,
            backgroundColor: Colors.transparent,
            controller: otpController,
            length: 6,
            enablePinAutofill: true,
            blinkWhenObscuring: true,
            animationType: AnimationType.fade,
            textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontFamily: 'mon',
                fontWeight: FontWeight.w500),
            pinTheme: PinTheme(
              inactiveFillColor: liteBlack,
              fieldOuterPadding: const EdgeInsets.only(right: 8),
              activeFillColor: liteBlack,
              selectedFillColor: liteBlack,
              inactiveColor: Colors.black12,
              selectedColor: themeClr,
              activeColor: themeClr,
              borderWidth: 1,
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(10),
              fieldHeight: 50,
              fieldWidth: MediaQuery.of(context).size.width * 0.13,
            ),
            cursorColor: Colors.white,
            cursorHeight: 20,
            animationDuration: const Duration(milliseconds: 300),
            enableActiveFill: true,
            autoFocus: true,
            enabled: true,
            autoDisposeControllers: false,
            keyboardType: TextInputType.number,
            onCompleted: (v) async {

              setState(() {
                loading=true;
              });
             var rsp = await verfyOtp(widget.verificationId, otpController.text, context,
                  widget.number).onError((error, stackTrace) =>   setState(() {
               loading=false;
             })).whenComplete(() =>   setState(() {
               loading=false;
             }));

              setState(() {
                loading=false;
              });

              // var rsp=await phoneSignIn(phoneNumber:widget.number);
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => BottomNav()),
              // );
            },
            onChanged: (code) {},
            beforeTextPaste: (text) {
              print("Allowing to paste $text");
              return true;
            },
          ),
          resendOtp==false?Container(margin:EdgeInsets.only(right: 15),child: Text("00:"+(stopWatchTime.toString().length==1?"0"+stopWatchTime.toString():stopWatchTime.toString()), style: size13_600W)):Container(),
        ],
      ),
    );
  }
}
