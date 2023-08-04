import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';

import 'package:country_picker/country_picker.dart';
import 'package:provider/provider.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:weei/Helper/Const.dart';
import 'package:weei/Helper/Provider.dart';
import 'package:weei/Helper/Toast.dart';
import 'package:weei/Screens/Auth/Data/auth.dart';

class EnterNumber extends StatefulWidget {
  const EnterNumber({Key? key}) : super(key: key);

  @override
  _EnterNumberState createState() => _EnterNumberState();
}

class _EnterNumberState extends State<EnterNumber> {
  bool tap = false;
  bool googletap = false;
  TextEditingController numberController = TextEditingController();
  TextEditingController otpSentListener = TextEditingController();
   var emoji ="🇮🇳";
   var code ="91";
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {



    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Consumer<ProviderModel>(builder: (context, model, child) {
      final model = Provider.of<ProviderModel>(context, listen: false);
      var btTap = model.getLang();

      return Scaffold(
      key: _scaffoldKey,

      backgroundColor: bgClr,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0.1),
        child: AppBar(
          elevation: 0,
          backgroundColor: bgClr,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            h(37),
            Center(child: SvgPicture.asset("assets/svg/weei.svg")),
            h(MediaQuery.of(context).size.height * 0.1),
            SvgPicture.asset("assets/svg/login.svg"),
            h(MediaQuery.of(context).size.height * 0.01),
            textBox(model,btTap),
            h(MediaQuery.of(context).size.height * 0.02),
            Row(
              children: const [
                Expanded(
                  child: Divider(
                    endIndent: 25,
                    indent: 25,
                    color: Color(0xff2F2E41),
                    thickness: 1,
                  ),
                ),
                Text(
                  "OR",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'mon',
                      color: Color(0xff808080)),
                ),
                Expanded(
                  child: Divider(
                    endIndent: 25,
                    indent: 25,
                    color: Color(0xff2F2E41),
                    thickness: 1,
                  ),
                ),
              ],
            ),
            h(MediaQuery.of(context).size.height * 0.02),
            googleSignIn(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Text(
                "By continuing you agree to Weei’s Terms of Conditions and Privacy Policy",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff808080)),
              ),
            )
          ],
        ),
      ),
    );

    });
  }

  Widget textBox(model,btTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: liteBlack,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            w(10),
            // GestureDetector(
            //   onTap: (){
            //
            //     showCountryPicker(
            //       context: context,
            //       showPhoneCode: true, // optional. Shows phone code before the country name.
            //       onSelect: (Country country) {
            //
            //         setState(() {
            //           emoji=country.flagEmoji;
            //           code=country.phoneCode;
            //         });
            //         print('Select country: ${country.displayName}');
            //         print('Select country: ${country.flagEmoji}');
            //         print('Select country: ${country}');
            //       },
            //     );
            //   },
            //   child: Padding(
            //     padding:  EdgeInsets.symmetric(horizontal: 16),
            //     child: Text(emoji==null?"+91":emoji, style: TextStyle(fontSize: 20)),
            //   ),
            // ),
             GestureDetector(
               onTap: (){

                 showCountryPicker(
                   context: context,
                   showPhoneCode: true, // optional. Shows phone code before the country name.
                   onSelect: (Country country) {

                     setState(() {
                      // emoji=country.flagEmoji;
                       code=country.phoneCode;
                     });

                   },
                 );
               }
               ,
               child: Row(
                 children: [
                   Text("+"+code, style: size16_600W),
                   Icon(Icons.keyboard_arrow_down,color: Colors.white,size: 20,)
                 ],
               ),
             ),
            w(8),
            Expanded(
              child: TextFormField(
                keyboardType: TextInputType.number,
                controller: numberController,
                style: size16_600W,
               // inputFormatters: [LengthLimitingTextInputFormatter(10)],
                decoration: const InputDecoration(
                    focusedBorder: InputBorder.none,
                    isDense: true,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintStyle: size16_500,
                    hintText: "000 000 0000"),
              ),
            ),
            GestureDetector(
              onTap: () async {


                if(numberController.text.isEmpty){
                  showToastSuccess("Number empty !");
                 // customSnackBarError(context,"Number empty !",_scaffoldKey,);
                  return;
                }
                setState(() {
                  tap = true;
                });
                model.setLang("true");
                showToastSuccess("Sending OTP...");
                var rsp = await phoneSignIn(
                    phoneNumber: numberController.text.toString(),
                    contxt: context,
                    cod: code,
                  replace: false,
                  listener: model

                );

                print("rsp");
                print(rsp);

                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => EnterOTP(number:rsp  ,)),
                // );
              },
              child: Container(
                alignment: Alignment.center,
                height: 46,
                width: 70,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), color: themeClr),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: btTap == "true"
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2
                          ),
                        )
                      : const Icon(Icons.arrow_forward_ios,
                          color: Colors.white, size: 16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget googleSignIn() {
    return GestureDetector(
      onTap: ()async{

        setState(() {
          googletap=true;
        });
       var rsp = await  signInWithGoogle(context).onError((error, stackTrace) =>  setState(() {
         googletap=false;
       }) ).whenComplete(() =>   setState(() {googletap=false;}));
       // setState(() {
       //   googletap=false;
       // });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Container(
          height: 46,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: liteBlack,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               Icon(FontAwesomeIcons.google, size: 18, color: Colors.white),
              w(10),
               Text("Sign in with Google", style: size12_500W),
              w(10),


              googletap == true ?  SizedBox(
                height: 15,
                width: 15,
                child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2
                ),
              ):Container()
            ],
          ),
        ),
      ),
    );
  }


}
