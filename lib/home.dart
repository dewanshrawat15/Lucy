import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {

  final name, email, displayPicURL;

  HomeScreen({this.name, this.email, this.displayPicURL});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Future getRecords() async{
    List<Map> records = List();
    Map recMap;
    var collectionOfRecords = Firestore.instance.collection("records").where("email", isEqualTo: widget.email);
    collectionOfRecords.snapshots().listen((data) => data.documents.forEach((doc){
      recMap = {
        "url": doc.data["url"],
        "time": doc.data["time"]
      };
      records.add(recMap);
    }));
    Map result = {
      "records": records,
    };
    setState(() {
      
    });
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "History",
          style: TextStyle(
            fontFamily: "Product Sans"
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: getRecords().asStream(),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.hasData){
            return ListView.builder(
              itemCount: snapshot.data["records"].length,
              itemBuilder: (BuildContext context, int index){
                return InkWell(
                  onTap: () async{
                    var tempUrl = snapshot.data["records"][index]["url"];
                    if(await canLaunch(tempUrl)){
                      launch(tempUrl);
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.all(0),
                    child: ListTile(
                      title: Text(
                        snapshot.data["records"][index]["url"],
                        style: TextStyle(
                          fontFamily: "Product Sans"
                        ),
                      ),
                      subtitle: Text(
                        snapshot.data["records"][index]["time"],
                        style: TextStyle(
                          fontFamily: "Product Sans"
                        ),
                      ),
                    ),
                  ),
                );
              }
            );
          }
          return Center(child: CircularProgressIndicator());
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          var collectionRef = Firestore.instance.collection("records");
          var time = DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now());
          Map<String, dynamic> data = {
            "name": widget.name,
            "email": widget.email,
            "url": "instagram.com",
            "time": time
          };
          collectionRef.add(data);
          setState(() {
            
          });
        },
        child: Icon(Icons.camera_alt),
      ),
    );
  }
}