
import 'dart:convert';

User userFromjson(String str)=>User.Fromjson(json.decode(str));
String userTojson( User data)=>json.encode(data.Tojson());
class User{
  String id;
  String? name;
  String? photoUrl;
  bool? isOnline;
  String mobileNo;
  String? about;
  User({required this.id,
      this.name,
      this.photoUrl='https://th.bing.com/th/id/OIP.Ii15573m21uyos5SZQTdrAHaHa?pid=ImgDet&rs=1',
      this.isOnline,
      required this.mobileNo,
      this.about
  });
  factory User.Fromjson( Map<String,dynamic> json)=>User(
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
 User updateUser(User user,String? name,String? photoUrl,String? mobileNo,String? about,bool? isOnline,)=>User(
   id:user.id,
   name: (name==null)?user.name:name,
   photoUrl: (photoUrl==null)?user.photoUrl:photoUrl,
   isOnline: (isOnline==null)? user.isOnline:isOnline,
   mobileNo: (mobileNo==null)? user.mobileNo:mobileNo,
   about: (about==null)? user.about:about,

 );



}