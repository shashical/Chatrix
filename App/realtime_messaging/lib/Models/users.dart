
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
 Users updateUser(Users user,String? name,String? photoUrl,String? mobileNo,String? about,bool? isOnline,)=>Users(
   id:user.id,
   name: (name==null)?user.name:name,
   photoUrl: (photoUrl==null)?user.photoUrl:photoUrl,
   isOnline: (isOnline==null)? user.isOnline:isOnline,
   mobileNo: (mobileNo==null)? user.mobileNo:mobileNo,
   about: (about==null)? user.about:about,

 );



}