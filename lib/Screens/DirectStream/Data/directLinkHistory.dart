

import 'dart:convert';

import 'package:weei/Helper/sharedPref.dart';

addLinkToDb(value)async{
 var mapList=[] ;
 var checkDb = await getSharedPrefrence(URLSTORAGE);
 if(checkDb!=null){
  mapList.add({'url' :value });
  var decodedMap = json.decode(checkDb);
  for (var i = 0; i < decodedMap.length; i++) {

   mapList.add({'url' :decodedMap[i]['url'] });
  }
  String encodedMap = json.encode(mapList);
  var addToDb = await setSharedPrefrence(URLSTORAGE,encodedMap);
 }else{
  mapList.add({'url' :value });
  String encodedMap = json.encode(mapList);
  var addToDb = await setSharedPrefrence(URLSTORAGE,encodedMap);
 }
}


removeUrlItem(index)async{
 var mapList=[] ;
 var checkDb = await getSharedPrefrence(URLSTORAGE);
 var decodedMap = json.decode(checkDb);
 for (var i = 0; i < decodedMap.length; i++) {

  mapList.add({'url' :decodedMap[i]['url'] });
 }

 mapList.removeAt(index);
 String encodedMap = json.encode(mapList);
 var addToDb = await setSharedPrefrence(URLSTORAGE,encodedMap);
}

getUrlList()async{
 var mapList=[] ;
 var checkDb = await getSharedPrefrence(URLSTORAGE);

 if(checkDb!=null){
  var decodedMap = json.decode(checkDb);
  for (var i = 0; i < decodedMap.length; i++) {

   mapList.add({'url' :decodedMap[i]['url'] });
  }
 }



 return mapList;

}