import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'models/DataModel.dart';

class ListUserPage extends StatefulWidget {
  final data;
  const ListUserPage({Key? key, this.data}) : super(key: key);
  @override
  ListUserPageState createState() => ListUserPageState();
}

class ListUserPageState extends State<ListUserPage> {
  Future<List<DataModel>> fetchData() async {
    try {
      String accessToken = widget.data['access_token'];
      String userId = widget.data['user_id'].toString();
      print(accessToken);
      print(userId);

      // var fullUrl = Uri.parse('http://sas.neork.io/api/customers');
      // var header = <String, String>{
      //   'Accept': 'application/json',
      //   'Content-Type': 'application/x-www-form-urlencoded',
      //   'X-userId':userId,
      //   // 'Authorization': 'Bearer $accessToken',
      //
      //   'X-accessToken':accessToken
      // };
      // final response = await http.get(fullUrl, headers: header);

      var headers = {'userId': '${userId}', 'accessToken': '${accessToken}'};
      var request =
          http.Request('GET', Uri.parse('http://sas.neork.io/api/customers'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());
      } else {
        print(response.reasonPhrase);
      }
      print(userId);
      return [];
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
      future: fetchData(),
      builder: (context, AsyncSnapshot<List<DataModel>> snapshot) {
        if (snapshot.hasData) {
          List<DataModel> models = snapshot.data!;
          return Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Container(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          // Text("Good morning ${models[0].name}"),
                          Expanded(child: Text("Good morning ")),
                          Expanded(
                              child: Text(
                                  "Your Login Time : ${widget.data['login_date_time']}")),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(child: Text("Location")),
                          Expanded(child: Text("Your Active Time:")),
                        ],
                      ),
                    ],
                  ),
                ),
                ListView.builder(
                    itemCount: models.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) => Card(
                            child: ListTile(
                          title: Text(models[index].name!),
                          subtitle: Text(models[index].site_address!),
                        )))
              ],
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    ));
  }
}
