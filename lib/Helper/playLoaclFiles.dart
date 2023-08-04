//
//
//
// putData()async{
//   databaseReference.child("session").child(uid).remove();
//   var i =0;
//   // var playlist = await yt.playlists.get(widget.url);
//   setState(() {
//     adding=true;
//     tap=true;
//     playlistLength =1;
//   });
//
//
//
//   var rsp = await    databaseReference.child("session").child(uid).child(i.toString()).update({
//     'docId': widget.item['url'],
//     'fileName':   widget.item['mediaName'],
//     'fileThumb':  widget.item['mediaThumb'],
//
//     'fileUrl':   widget.item['url'],
//     'fileType':  widget.type,
//
//   }).whenComplete((){
//     print("comppp");
//     setState(() {
//       i=i+1;
//       addedNum =i;
//     });
//
//     checkAndCreateSession(context,"session/"+uid,widget.private,widget.type);
//   });
//
//
//
// }