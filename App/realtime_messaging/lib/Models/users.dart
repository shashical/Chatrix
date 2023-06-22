
import 'dart:convert';

Users userFromjson(String str)=>Users.Fromjson(json.decode(str));
String userTojson( Users data)=>json.encode(data.Tojson());
class Users{
  String id;
  String? name;
  String? photoUrl;
  bool? isOnline;
  String mobileNo;
  String? about;
  Users({required this.id,
      this.name,
      this.photoUrl='https://th.bing.com/th/id/OIP.Ii15573m21uyos5SZQTdrAHaHa?pid=ImgDet&rs=1',
      this.isOnline,
      required this.mobileNo,
      this.about
  });
  factory Users.Fromjson( Map<String,dynamic> json)=>Users(
    id: json["id"],
    name: json["name"],
    photoUrl: json["photoUrl"],
    isOnline: json["isOnline"],
    mobileNo: json["mobileNo"],
    about: json["about"],

  );
 Map<String,dynamic> Tojson()=>{
   "id":id,
   "name":name,
   "photoUrl":photoUrl,
   "isOnline":isOnline,
   "mobileNo":mobileNo,
   "about": about,


 };




}