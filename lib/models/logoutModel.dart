
class logoutModel{
  bool ? status;
  String ? message;
  data ? dataa;
  logoutModel.fromjson(Map<String,dynamic>json){
    status=json['status'];
    message=json['message'];
    dataa=json['data']!=null?data.fromjson(json['data']):null;
  }

}
class data{
  int ?id;
  String ? token;
  data.fromjson(Map<String,dynamic>json){
    id=json['id'];
    token=json['token'];
  }
}