Future<dynamic> checkUrl(url) async {

  var rsp;
  print("message");
  print(url);
  print(url.contains("you"));
  if(url.contains("you")==true){

    if(url.contains("playlist")==true)  {


      return "YTPLAYLIST";
    }else{


      return "YT";
    }



  }else{


    if(url.toString().toUpperCase().contains("FB")==true){


      return "FB";
    }
    if(url.toString().toUpperCase().contains("INSTAGRAM")==true){


      return "INSTA";

    }
    return "URL";
  }



}