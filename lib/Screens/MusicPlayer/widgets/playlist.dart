import 'package:flutter/material.dart';
import 'package:weei/Helper/Const.dart';
import 'package:just_audio/just_audio.dart';


class musicPlayList extends StatefulWidget {
  musicPlayList({Key? key, this.playList,required this.player,this.title}) : super(key: key);
  final playList;
  final title;
  final AudioPlayer player;


  @override
  _GroceryListState createState() => _GroceryListState();
}

class _GroceryListState extends State<musicPlayList> {
  @override
  void initState() {
  print("inxexxx");
  print(widget.title);
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Scrollbar(
        child: ListView.separated(
          scrollDirection: Axis.vertical,
          separatorBuilder: (context, index) => const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child:
            Divider(color: Color(0xff404040), thickness: 1),
          ),
          shrinkWrap: true,
          itemCount: widget.playList != null ? widget.playList.length : 0,
          itemBuilder: (context, index) {
            final item =
            widget. playList != null ? widget.playList[index] : null;

            return ListTile(
           //   tileColor:widget.title==item['fileName']?Colors.white:themeClr ,
              title:  Text(item['fileName']!=null?item['fileName'].toString():"", style: widget.title ==index?size14_500G:size14_500W),

              onTap: () {
                widget.player.seek(Duration.zero, index: index);
              },
            );
          },
        ),
      ),
    );
  }


}
