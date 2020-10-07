
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:laigo/Screens/All/all.dart';
import 'package:laigo/Screens/Categories/categories.dart';
import 'package:laigo/Screens/Conversation/conCategories.dart';
import 'package:get/get.dart';

import 'package:laigo/data/constant.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
   SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  runApp(Laigo());
}

int currentIndex = 0;

class Laigo extends StatefulWidget {
  @override
  _LaigoState createState() => _LaigoState();
}

class _LaigoState extends State<Laigo> {
  PageController _pageController = PageController(initialPage: 0);

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      Get.to(Conversation());
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: (context, widget) => ResponsiveWrapper.builder(
        widget,
        maxWidth: 1200,
        minWidth: 480,
        defaultScale: true,
        breakpoints: [
          ResponsiveBreakpoint.resize(480, name: MOBILE),
          ResponsiveBreakpoint.autoScale(800, name: TABLET),
          ResponsiveBreakpoint.resize(1000, name: DESKTOP),
        ],
      ),
      // initialRoute: '/first',
      // routes: {
      //   '/first': (context) => SplashScreen(),
      // },
      theme: ThemeData.dark(),
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
                      icon: Icon(Icons.messenger,size: 30,),
                      label: 'OPENERS',
                   
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.call,size: 30,),
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
            extendBodyBehindAppBar: true,
            backgroundColor: Colors.white,
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
                  children: [All(), Categories()]),
            )),
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
                "Openers",
                style: TextStyle(fontSize: 28,  color: Color(0xff085787)),
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
