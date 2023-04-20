import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ListUserPage extends StatefulWidget {
  final data;
  const ListUserPage({Key? key, this.data}) : super(key: key);
  @override
  ListUserPageState createState() => ListUserPageState();
}

class ListUserPageState extends State<ListUserPage> {
  String activeTime = '00:00:00';
  String strWish = '';
  String strName = '';
  String strPlace = '';
  late Timer timer;
  late DateTime loginTime;

  @override
  void initState() {
    super.initState();
    loginTime = DateTime.now();
    if (loginTime.hour < 12) {
      strWish = "Good morning ";
    } else if (loginTime.hour >= 12 && loginTime.hour < 18) {
      strWish = "Good afternoon ";
    } else if (loginTime.hour >= 18) {
      strWish = "Good evening ";
    }
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        Duration activeDuration = DateTime.now().difference(loginTime);
        activeTime = activeDuration.toString().split('.').first;
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  Future<List> fetchData() async {
    try {
      String accessToken = widget.data['access_token'];
      String userId = widget.data['user_id'].toString();
      var headers = <String, String>{
        'Content-Type': 'application/json',
        'accessToken': accessToken,
        'userId': userId,
      };
      final res = await http.get(Uri.parse('http://sas.neork.io/api/customers'),
          headers: headers);

      if (res.statusCode == 200) {
        var body = jsonDecode(res.body);
        strName = 'Test Name';
        strPlace = 'Test Place';
        List data = body['data'];
        return data;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${jsonDecode(res.body)['message']}'),
          ),
        );
      }
      return [];
    } catch (e) {
      print(e);
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedTime = DateFormat('h:mm a').format(DateTime.now());

    return Scaffold(
        body: FutureBuilder(
      future: fetchData(),
      builder: (context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          List models = snapshot.data!;
          return Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Container(
                  height: 200,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: EdgeInsets.all(
                                  5), //apply padding to all four sides
                              child: Text("${strWish} ${strName}")),
                          Padding(
                              padding: EdgeInsets.all(
                                  5), //apply padding to all four sides
                              child: Text("Location : ${strPlace}")),
                        ],
                      )),
                      Expanded(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: EdgeInsets.all(
                                  5), //apply padding to all four sides
                              child: Text("Your Login Time : $formattedTime ")),
                          Padding(
                              padding: EdgeInsets.all(
                                  5), //apply padding to all four sides
                              child: Text("Your Active Time: $activeTime  ")),
                        ],
                      )),
                      Expanded(
                          child: Container(
                              alignment: Alignment.bottomRight,
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('/images/image1.png'),
                                    fit: BoxFit.contain),
                              )))
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blueAccent),
                    "Please select your customer site to proceed your service"),
                SizedBox(
                  height: 20,
                ),
                ListView.builder(
                    itemCount: models.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) => Card(
                        color: (index % 2 == 0) ? Colors.white38 : Colors.grey,
                        child: ListTile(
                          title: Text(models[index]['name']),
                          subtitle: Text(models[index]['site_address']!),
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
