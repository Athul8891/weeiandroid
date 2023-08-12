import 'package:youtube_explode_dart/youtube_explode_dart.dart';

final yt = YoutubeExplode();

Future<dynamic> getSong(url,sessionType) async {
  var link ;
  if(sessionType=="VIDEO"){
    link = url;

  }

  if(sessionType=="AUDIO"){
    link = url;

  }

  if(sessionType=="YTVIDEO"){
    final manifest = await yt.videos.streamsClient.getManifest(url);
    link =manifest.muxed.withHighestBitrate().url.toString();
  }
  if(sessionType=="YTAUDIO"){
    final manifest = await yt.videos.streamsClient.getManifest(url);
    link = manifest.audioOnly.withHighestBitrate().url.toString();
  }

  if(sessionType=="INSTA_AUDIO"){
    link = url;

  }

  if(sessionType=="INSTA_VIDEO"){
    link = url;

  }

  if(sessionType=="FB_AUDIO"){
    link = url;

  }

  if(sessionType=="FB_VIDEO"){
    link = url;

  }
  return link;
}