import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weei/Helper/Const.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_pagination/firebase_pagination.dart';
import 'package:weei/Helper/Toast.dart';
import 'package:weei/Helper/navigate.dart';
import 'package:weei/Screens/Admob/BannerAds.dart';
import 'package:weei/Screens/Main_Screens/Chat/ChatRoom.dart';
import 'package:weei/Screens/Main_Screens/Chat/Data/createFriend.dart';
import 'package:weei/Screens/Main_Screens/Home/Data/checkOngoingSession.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:weei/Screens/Search/Data/addBot.dart';
import 'package:weei/Screens/Search/Data/addFreind.dart';
import 'package:weei/Screens/Search/Data/checkReq.dart';
import 'package:weei/Screens/Search/SearchChatRoom.dart';
import 'package:weei/Screens/Search/SearchSentWidget.dart';
import '../../../Helper/getBase64.dart';


class Search extends StatefulWidget {



  @override
  _SessionScreenState createState() => _SessionScreenState();
}

class _SessionScreenState extends State<Search> {
  TextEditingController numberController = TextEditingController();

  PaginateRefreshedChangeListener refreshChangeListener = PaginateRefreshedChangeListener();

  int a =2;
  final FirebaseAuth auth = FirebaseAuth.instance;


  // DatabaseReference reference =
  // FirebaseDatabase.instance.reference().child('channel');

  String dropdownvalue = 'All';
  var onSubmit = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();



  }
  @override
  Widget build(BuildContext context) {
    var ss = MediaQuery.of(context).size;

    return Scaffold(
      bottomNavigationBar: BannerAds(),
      appBar: AppBar(
        elevation: 0,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 18,
              )),
          title: Container(
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
                color: grey, borderRadius: BorderRadius.circular(7)),
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: TextField(

                controller: numberController,

                textInputAction: TextInputAction.search,
                style: TextStyle(color: Colors.white70),

                cursorColor: Colors.white,
                onChanged: (key)async{

                },
                onSubmitted: (key)async{

                  setState(() {
                    onSubmit=true;
                    dropdownvalue=numberController.text;
                  });

                },

                decoration: InputDecoration(
                    //suffixIcon: const Icon(Icons.search, color:Colors.white,size: 20,),

                    suffixIcon: IconButton(
                      icon:  onSubmit==true?Icon(Icons.clear, color:Colors.white,size: 20,):Icon(Icons.search, color:Colors.white,size: 20,),
                      onPressed: () {
                        /* Clear the search field */


                         if(onSubmit==true){
                           setState(() {
                             numberController.clear();
                             onSubmit=false;

                           });
                         }else{

                           setState(() {
                             onSubmit=true;
                             dropdownvalue=numberController.text;
                           });
                         }

                      },
                    ),
                    hintText: 'Search',
                    hintStyle: TextStyle(color: Colors.white70),
                    border: InputBorder.none),
              ),
            ),
          )
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25,vertical: 5),
        child:Scrollbar(
         // key: ValueKey(dropdownvalue),
          // child: ListView.separated(
          //   scrollDirection: Axis.vertical,
          //   separatorBuilder: (context, index) => h(10),
          //   shrinkWrap: true,
          //   itemCount: 50,
          //   itemBuilder: (context, index) {
          //     // final item = arrOrderDetail != null
          //     //     ? arrOrderDetail[index]
          //     //     : null;
          //
          //     return participantsList(index);
          //   },
          // ),
          // child: FirebaseAnimatedList(
          //   key: ValueKey(dropdownvalue),
          //
          //   query: FirebaseDatabase.instance
          //       .reference()
          //       .child('session').child("EZypBJHwk4MtztMyuvMjCxwNWIh1").limitToFirst(a),
          //
          //   itemBuilder: (BuildContext context, DataSnapshot snapshot,
          //       Animation<double> animation, int index) {
          //
          //     // Object? contact = snapshot.value;
          //     // contact['key'] = snapshot.key;
          //     return MusicList( snapshot.value,index);
          //   },
          // ),
          child: onSubmit==true?PaginateFirestore(

            // Use SliverAppBar in header to make it sticky
            // header: SliverToBoxAdapter(child: Text('HEADER')),
            // footer: SliverToBoxAdapter(child: Text('FOOTER')),
            // item builder type is compulsory.
            // separator: Padding(
            //   padding: EdgeInsets.symmetric(vertical: 8),
            //   child: Divider(color: Color(0xff404040), thickness: 1),
            // ),
            reverse: true,
            key: ValueKey(dropdownvalue),
            shrinkWrap: true,
            onEmpty: emptyList(),
            itemBuilderType:
            PaginateBuilderType.listView,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 10,
                childAspectRatio: 0.65),
            // Change types accordingly
            itemBuilder: (context, documentSnapshots, index) {
              final data = documentSnapshots[index].data() as Map?;
              return data!=null ?chatList(documentSnapshots[index].id,data,index):Container(  child: Center(child: Text("No Freinds Found!"),),);
            },
            // orderBy is compulsory to enable pagination
            query: FirebaseFirestore.instance.collection('Users').where('search',arrayContains: numberController.text.toString().trim()),
            // to fetch real-time data
            listeners: [
              refreshChangeListener,
            ],

            isLive: true,
          ):Container(),


        ),
      ),
    );
  }
  Widget emptyList() {
    return Container( height:150,child: Column(
      //    crossAxisAlignment: CrossAxisAlignment.center,
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [

        Text(onSubmit==true?"No Search results found.":"", style: size13_600W),
        SizedBox(height: 15,),






      ],),);

  }
  chatList(var docId,var item, int index) {
    return GestureDetector(
      onTap:item['uid']==auth.currentUser!.uid?null: (){
        // print("taaaaap");
        NavigatePage(context,SearchChatRoom(friendData:item ,));
      },
      child: Column(
        children: [
          ListTile(
            title:  Text(item['name'].toString(), style: size14_600WT,maxLines: 1,),
            subtitle:  Text(item['username'].toString(), style: size14_500Grey,maxLines: 1,),
            leading:  Container(
              height: 40,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 50,
                backgroundImage:
                MemoryImage(dataFromBase64String(item['profile'])),
                //  backgroundImage:MemoryImage( dataFromBase64String(tstIcon)),
              ),
              width: 40,
            ),

            //  trailing: CupertinoSwitch(value: true, onChanged: (v) {}),
            contentPadding: EdgeInsets.zero,
          ),

          div()
        ],
      )




    );
  }

  div() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Divider(color: Color(0xff404040), thickness: 1),
    );
  }


}
