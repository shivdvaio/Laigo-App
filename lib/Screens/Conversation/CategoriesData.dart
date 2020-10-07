import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laigo/data/constant.dart';


class CategoryConversation extends StatefulWidget {
  CategoryConversation({this.nameoFCategory});
  final nameoFCategory;
  @override
  _CategoryConversationState createState() => _CategoryConversationState();
}

String text;

class _CategoryConversationState extends State<CategoryConversation> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
              child: Scaffold(
          backgroundColor: Colors.white,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(140.0),
                    child: AppBar(
                  elevation: 0,
                  backgroundColor: kAppbarColor,
                  leading: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(Icons.arrow_back_ios_outlined,
                          size: 40, color: Colors.grey)),
                  title: Text('${widget.nameoFCategory}',
                      style: TextStyle(
                          fontSize: 30,
                          color: Color(0xff427FA4),
                          fontWeight: FontWeight.bold)),
                  centerTitle: true,
                ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection(widget.nameoFCategory)
                        .snapshots(),
                    // ignore: deprecated_member_us
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.data == null) {
                        return CircularProgressIndicator();
                      }
                      return ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (BuildContext context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  InkWell(
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(
                                            builder: (BuildContext context) {
                                          return CategoryDataofConversation(
                                            name: widget.nameoFCategory,
                                            index: index,
                                          );
                                        }));
                                      },
                                      child: ListTile(title: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Text(
                                                "${snapshot.data.docs[index].data()['lines'].toString()}",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.black,
                                                )),
                                          ),
                                        ),)),
                                      Divider(color: Colors.grey),
                                ],
                              ),
                            );
                          });
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryDataofConversation extends StatefulWidget {
  final String name;
  final int index;
  CategoryDataofConversation({this.name, this.index});
  @override
  _CategoryDataofConversationState createState() =>
      _CategoryDataofConversationState();
}

String data;

int lengthOfsentences;
int indexValue1 = 0;

class _CategoryDataofConversationState
    extends State<CategoryDataofConversation> {


      @override
  void initState() {
    super.initState();
    setIndex();
  }

  void setIndex() {
    setState(() {
      indexValue1 = widget.index;
    });
  }

  void increase() {
    print(indexValue1);
   
     
    setState(() {
      if (indexValue1 >= 0) {
        if (indexValue1 + 1 < lengthOfsentences) {
          
          indexValue1++;
        }
      }
    });
  }

  void decrease() {

    setState(() {

      if (indexValue1 > 0) {
        if (indexValue1 + 1 <= lengthOfsentences) {
          if (indexValue1 < 0) {
            return;
          } else {
            indexValue1--;
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffeeeeee),
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(140.0),
          child: AppBar(
            backgroundColor: kAppbarColor,
            elevation: 0,
            leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios_outlined,
                size: 40,
                color: Colors.grey,
              ),
            ),
            actions: [
              InkWell(
                onTap: () {
                  Clipboard.setData(new ClipboardData(text: data ?? "wait"));
                  Get.snackbar(
                    "ClipBoard",
                    "Text Copied",
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    height: 30,
                    child: Icon(
                      Icons.copy,
                      size: 40,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
            title: Text("Sentence",
                style: TextStyle(
                    fontSize: 30,
                    color: Color(0xff427FA4),
                    fontWeight: FontWeight.bold)),
          ),
        ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StreamBuilder(
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.data == null) {
                          return CircularProgressIndicator();
                        }
                        data = snapshot.data.docs[widget.index]
                            .data()['lines']
                            .toString();
                            lengthOfsentences = snapshot.data.docs.length;
                        return Container(
                          margin: EdgeInsets.only(left: 60),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              '${snapshot.data.docs[indexValue1].data()['lines'].toString()}',
                              style: GoogleFonts.quicksand(
                                        fontSize: 20, color: Colors.white),
                            ),
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20)),
                              color:  Color(0XFF369AFA),
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0xfff6f5f5),
                                    blurRadius: 10,
                                    offset: Offset(0, 3))
                              ]),
                          height: 180,
                          width: double.infinity,
                        );
                      },
                      stream: FirebaseFirestore.instance
                          .collection(widget.name)
                          .snapshots()),
                SizedBox(height: 60),
                 
                  
                  StreamBuilder(
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.data == null) {
                          return CircularProgressIndicator();
                        }
                        return Container(
                           margin: EdgeInsets.only(right:60),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              'Usage: \n${snapshot.data.docs[indexValue1].data()['explaination'].toString()}',
                              style:  GoogleFonts.quicksand(
                                        fontSize: 18, color: Colors.black),
                            ),
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20)),
                              color: Color(0xffE2E2E2),
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0xfff6f5f5),
                                    blurRadius: 10,
                                    offset: Offset(0, 3))
                              ]),
                          height: 250,
                          width: double.infinity,
                        );
                      },
                      stream: FirebaseFirestore.instance
                          .collection(widget.name)
                          .snapshots()),
                          SizedBox(
                      height: 50,
                    ),
                          Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          Icons.arrow_back_ios_outlined,
                          size: 40,
                        ),
                        Icon(Icons.arrow_forward_ios_outlined,size: 40)
                      ],
                    )
                ]),
          ),
        ),
      ),
    );
  }
}
