import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:laigo/Screens/Conversation/All_conversation.dart';
import 'package:laigo/Screens/Conversation/CategoriesData.dart';
import 'package:laigo/data/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Conversation extends StatefulWidget {
  @override
  _ConversationState createState() => _ConversationState();
}

int currentIndex = 0;

class _ConversationState extends State<Conversation> {
  PageController _pageController = PageController(initialPage: 0);

  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          bottomNavigationBar: Container(
            height: 140,
            child: Theme(
              data: ThemeData(canvasColor: kAppbarColor),
              child: BottomNavigationBar(
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.messenger,
                      size: 30,
                    ),
                    label: 'OPENERS',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      Icons.call,
                      size: 30,
                    ),
                    label: 'IN CONVERSATION',
                  ),
                ],
                currentIndex: _selectedIndex,
                selectedItemColor: Colors.blue,
                onTap: _onItemTapped,
                unselectedFontSize: 20,
                selectedFontSize: 20,
              ),
            ),
          ),
          appBar: CustomAppBar(
            height: 140,
          ),
          body: SizedBox.expand(
            child: PageView(
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                scrollDirection: Axis.horizontal,
                pageSnapping: true,
                controller: _pageController,
                children: [
                  AllConversation(),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('conversationCategories')
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.data == null) {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                              return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data.docs.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(context,
                                                  MaterialPageRoute(builder:
                                                      (BuildContext context) {
                                                return CategoryConversation(
                                                  nameoFCategory: snapshot
                                                      .data.docs[index]
                                                      .data()['nameOfCategory'],
                                                );
                                              }));
                                            },
                                            child: ListTile(
                                              leading: SizedBox(
                                      height: 40,
                                      width: 40,
                                     child: CachedNetworkImage(
                                      imageUrl:
                                          "${snapshot.data.docs[index].data()['conversationCategoryicon']}",
                                      placeholder: (context, url) => Container(
                                          child: CircularProgressIndicator(
                                            
                                              backgroundColor:
                                                  Color(0xff427FA4),
                                              valueColor:
                                                  new AlwaysStoppedAnimation<
                                                      Color>(Colors.white),
                                                      )),
                                      errorWidget: (context, url, error) =>
                                          CircularProgressIndicator(
                                        backgroundColor: Color(0xff427FA4),
                                        valueColor:
                                            new AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                      fadeInCurve: Curves.easeIn,
                                      fadeInDuration:
                                          Duration(milliseconds: 1000),
                                    )


                                          ),
                                                title: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Text(
                                                '${snapshot.data.docs[index].data()['nameOfCategory']}',
                                                style: GoogleFonts.raleway(
                                                    color: Colors.black,
                                                    fontSize: 22),
                                              ),
                                            )),
                                          ),
                                          Divider(color: Colors.black),
                                        ],
                                      ),
                                    );
                                  });
                            }),
                      ],
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}

class CustomAppBar extends PreferredSize {
  final double height;

  CustomAppBar({this.height = kToolbarHeight});

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: kAppbarColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                "Conversation",
                style: TextStyle(fontSize: 28, color: Color(0xff085787)),
              ),
            ),
            Column(
              children: [
                Spacer(),
                buildAppbarItems(),
              ],
            ),
          ],
        ));
  }
}

class buildAppbarItems extends StatelessWidget {
  const buildAppbarItems({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                    decoration: BoxDecoration(
                        color: currentIndex == 0
                            ? Colors.grey.withOpacity(0.3)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      child: Text(
                        "All",
                        style: ktextStyle,
                      ),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                    decoration: BoxDecoration(
                        color: currentIndex == 1
                            ? Colors.grey.withOpacity(0.3)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Categories",
                        style: ktextStyle,
                      ),
                    )),
              ),
            ],
          )
        ],
      ),
    );
  }
}
