import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:laigo/data/constant.dart';

class CategoryOptionsData extends StatefulWidget {
  final String nameOfCategory;
  CategoryOptionsData({this.nameOfCategory});
  @override
  _CategoryOptionsDataState createState() => _CategoryOptionsDataState();
}

class _CategoryOptionsDataState extends State<CategoryOptionsData> {
  String categoryName;

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
              title: Text('${widget.nameOfCategory}',
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
                        .collection(widget.nameOfCategory)
                        .snapshots(),
                    // ignore: deprecated_member_us
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.data == null) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (BuildContext context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (BuildContext context) {
                                      return CategoryOptionsdata(
                                        name: widget.nameOfCategory,
                                        index: index,
                                      );
                                    }));
                                  },
                                  child: Column(
                                    children: [
                                      ListTile(
                                          title: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Text(
                                            "${snapshot.data.docs[index].data()['lines'].toString()}",
                                            style: GoogleFonts.raleway(
                                                color: Colors.black,
                                                fontSize: 22)),
                                      )),
                                      Divider(color: Colors.grey),
                                    ],
                                  )),
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

class CategoryOptionsdata extends StatefulWidget {
  final String name;
  final int index;
  CategoryOptionsdata({this.name, this.index});
  @override
  _CategoryOptionsdataState createState() => _CategoryOptionsdataState();
}

String data;

int lengthOfsentences;
int indexValue1 = 0;

class _CategoryOptionsdataState extends State<CategoryOptionsdata> {
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
    return SafeArea(
      child: Scaffold(
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
                            return Center(child: CircularProgressIndicator());
                          }
                          data = snapshot.data.docs[widget.index]
                              .data()['lines']
                              .toString();
                          lengthOfsentences = snapshot.data.docs.length;
                          return Container(
                            margin: EdgeInsets.only(left: 60),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Text(
                                  '${snapshot.data.docs[indexValue1].data()['lines'].toString()}',
                                  style: GoogleFonts.quicksand(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ),
                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20)),
                                color: Color(0XFF369AFA),
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
                            return Center(child: CircularProgressIndicator());
                          }
                          return Container(
                            margin: EdgeInsets.only(right: 60),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Text(
                                    'Usage : \n\n${snapshot.data.docs[indexValue1].data()['explaination'].toString()}',
                                    style: GoogleFonts.quicksand(
                                        fontSize: 18, color: Colors.black)),
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
                        InkWell(
                          onTap: () {
                            decrease();
                          },
                          child: Icon(
                            Icons.arrow_back_ios_outlined,
                            size: 40,
                          ),
                        ),
                        InkWell(
                            onTap: () {
                              increase();
                            },
                            child: Icon(Icons.arrow_forward_ios_outlined,
                                size: 40))
                      ],
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
