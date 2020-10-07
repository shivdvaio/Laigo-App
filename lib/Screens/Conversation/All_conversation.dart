import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:laigo/data/constant.dart';

class AllConversation extends StatefulWidget {
  @override
  _AllConversationState createState() => _AllConversationState();
}

class _AllConversationState extends State<AllConversation> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('AllSentences')
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
                                    return AllConversationData(
                                      index: index,
                                    );
                                  }));
                                },
                                child: ListTile(
                                    leading: SingleChildScrollView(
                                  child: Text(
                                    "${snapshot.data.docs[index].data()['lines'].toString()}",
                                    style: GoogleFonts.raleway(
                                        color: Colors.black, fontSize: 22),
                                  ),
                                ))),
                            Divider(color: Colors.grey),
                          ],
                        ),
                      );
                    });
              }),
        ],
      ),
    );
  }
}

String data;

class AllConversationData extends StatefulWidget {
  final int index;
  AllConversationData({this.index});
  @override
  _AllConversationDataState createState() => _AllConversationDataState();
}

class _AllConversationDataState extends State<AllConversationData> {

int lengthOfsentences;
int indexValue1 = 0;
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          backgroundColor: Color(0xffeeeeee),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(140.0),
            child: SafeArea(
              child: AppBar(
                  backgroundColor: kAppbarColor,
                  elevation: 0,
                  leading: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: 40,
                      color: Colors.grey,
                    ),
                  ),
                  actions: [
                    InkWell(
                      onTap: () {
                        Clipboard.setData(
                            new ClipboardData(text: data ?? "wait"));
                        Get.snackbar(
                          "ClipBoard",
                          "Text Copied",
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: SizedBox(
                          height: 40,
                          child: Icon(
                            Icons.copy,
                            color: Colors.grey,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ],
                  title: Text("Sentence",
                      style: GoogleFonts.quicksand(
                          fontSize: 30, color: Color(0xff427FA4)))),
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
                              .collection('AllSentences')
                              .snapshots()),
                      SizedBox(height: 60),
                      
                      StreamBuilder(
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.data == null) {
                              return CircularProgressIndicator();
                            }
                            return Container(
                              margin: EdgeInsets.only(right: 60),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Text(
                                    'Usage: \n\n ${snapshot.data.docs[indexValue1].data()['explaination']}',
                                    style: TextStyle(fontSize: 17),
                                  ),
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
                              height: 300,
                              width: double.infinity,
                            );
                          },
                          stream: FirebaseFirestore.instance
                              .collection('AllSentences')
                              .snapshots()),
                               SizedBox(
                        height: 50,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: (){
                              decrease();
                            },
                                                      child: Icon(
                              Icons.arrow_back_ios_outlined,
                              size: 40,
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              increase();
                            },
                            child: Icon(Icons.arrow_forward_ios_outlined, size: 40))
                        ],
                      )
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
