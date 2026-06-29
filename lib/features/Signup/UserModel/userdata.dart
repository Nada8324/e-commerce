
class UserModel{
  String ?uId;
  String ?name;
  String? email;
  String? phone;
  
  UserModel({
    this.email,
    this.name,
    this.phone,
    this.uId,
   
  });
  UserModel.fromjson(Map<String,dynamic>json){
    name=json['name'];
    email=json['email'];
    phone=json['phone'];
    uId=json['uId'];

  }
  Map<String,dynamic> toMap()
  {
    return{
      'name':name,
      'email':email,
      'phone':phone,
      'uId':uId,
    };
  }
}