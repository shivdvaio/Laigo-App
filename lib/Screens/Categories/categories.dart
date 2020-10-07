import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:laigo/Screens/Categories/categoryData.dart';

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('OpenersCategories')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.data == null) {
                  return Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (BuildContext context) {
                              return CategoryOptionsData(
                                  nameOfCategory: snapshot.data.docs[index]
                                      .data()['openersCategoryname']);
                            }));
                          },
                          child: Column(
                            children: [
                              ListTile(
                                  leading: SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          "${snapshot.data.docs[index].data()['openersCategoryicon']}",
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
                                    ),
                                  ),
                                  title: Text(
                                    '${snapshot.data.docs[index].data()['openersCategoryname']}',
                                    style: GoogleFonts.raleway(
                                        color: Colors.black, fontSize: 22),
                                  )),
                              Divider(color: Colors.grey),
                            ],
                          ),
                        ),
                      );
                    });
              })
        ],
      ),
    );
  }
}
