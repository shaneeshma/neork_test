import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:neork_test/models/DataModel.dart';

class Network {
  final String _url = "http://sas.neork.io/api";
  //if you are using android studio emulator, change localhost to 10.0.2.2


  authData(data, apiUrl) async {
    var fullUrl = _url + apiUrl;
    return await http.post(Uri.parse(fullUrl),
        body: jsonEncode(data),
        // headers: _setHeaders()
    );
  }


  Future<List<DataModel>> getDataList(apiUrl,token,userId) async {
    var fullUrl = apiUrl;
    print("***************");
    final res = await http.get(Uri.parse(fullUrl),headers: {
      "Content-type": "application/json",
      "Accept": "application/json",
      "accessToken" : "$token",
      "userId" : "$userId"
    });
    print("---------------------");

    print(res);
    List body = jsonDecode(res.body);

    return body.map((singleObject) => DataModel.fromJson(singleObject)).toList();
  }

}
