import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lucy/pages/accounts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:barcode_scan/barcode_scan.dart';

class HomeScreen extends StatefulWidget {

  final name, email, displayPicURL;

  HomeScreen({this.name, this.email, this.displayPicURL});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

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
        actions: <Widget>[
          InkWell(
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => AccountScreen(name: widget.name, email: widget.email, photoUrl: widget.displayPicURL,)
                )
              );
            },
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Icon(
                Icons.person
              ),
            ),
          )
        ],
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection("records").where("email", isEqualTo: widget.email).snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.hasData){
            if(snapshot.data.documents.length != 0){
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index){
                  return Dismissible(
                    key: Key(snapshot.data.documents[index].documentID),
                    onDismissed: (direction){
                      Firestore.instance.collection("records").document(snapshot.data.documents[index].documentID).delete();
                      Scaffold.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Record deleted"
                          )
                        )
                      );
                    },
                    background: Container(color: Colors.amber),
                    child: InkWell(
                      onTap: () async{
                        var tempUrl = snapshot.data.documents[index]["url"];
                        if(await canLaunch(tempUrl)){
                          launch(tempUrl);
                        }
                      },
                      child: Padding(
                        padding: EdgeInsets.all(0),
                        child: ListTile(
                          title: Text(
                            snapshot.data.documents[index]["url"],
                            style: TextStyle(
                              fontFamily: "Product Sans"
                            ),
                          ),
                          subtitle: Text(
                            snapshot.data.documents[index]["time"],
                            style: TextStyle(
                              fontFamily: "Product Sans"
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }
              );
            }
            else{
              return Align(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Center(
                      child: Text(
                        "No Records found",
                        style: TextStyle(
                          fontFamily: "Product Sans",
                          fontSize: 24
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 3 - 42,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Image.asset(
                        "assets/images/panda.png",
                        alignment: Alignment.bottomCenter,
                      ),
                    )
                  ],
                ),
              );
            }
          }
          return Center(
            child: CircularProgressIndicator()
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          var url = await BarcodeScanner.scan();
          var collectionRef = Firestore.instance.collection("records");
          var time = DateFormat("dd-MM-yyyy hh:mm:ss").format(DateTime.now());
          Map<String, dynamic> data = {
            "name": widget.name,
            "email": widget.email,
            "url": url,
            "time": time
          };
          collectionRef.add(data);
        },
        child: Icon(Icons.camera_alt),
      ),
    );
  }
}