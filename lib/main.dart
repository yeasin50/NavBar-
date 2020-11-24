import 'package:flutter/material.dart';

import './CustomPaints/DrawerPainter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NavBar',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Offset _offset = Offset(0, 0);
  GlobalKey globalKey = GlobalKey();
  List<double> limits = [];
  final numOfButton = 5;

  //sideBar status
  bool isMenuOpen = false;

  @override
  void initState() {
    //
    limits = [0, 0, 0, 0, 0, 0];
    WidgetsBinding.instance.addPostFrameCallback(getPosition);
    super.initState();
  }

  getPosition(duration) {
    RenderBox renderBox = globalKey.currentContext.findRenderObject();
    final position = renderBox.localToGlobal(Offset.zero);
    double start = position.dy - 20; //topBar
    double contLimit = position.dy + renderBox.size.height - 20;
    double step = (contLimit - start) / numOfButton;
    //setting buttons locations
    limits = [];
    for (double x = start; x <= contLimit; x = x + step) {
      limits.add(x);
    }
    setState(() {
      //refress the
      limits = limits;
    });
  }

  double getSize(int index) {
    double size = (_offset.dy > limits[index] && _offset.dy < limits[index + 1])
        ? 25
        : 20;
    return size;
  }

  @override
  Widget build(BuildContext context) {
    final Size mediaQuery = MediaQuery.of(context).size;
    final sidebarSize = mediaQuery.width * 0.65;
    final menuContainerHeight = mediaQuery.height / 2;
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromRGBO(255, 65, 108, 1.0),
                Color.fromRGBO(255, 75, 73, 1.0),
              ],
            ),
          ),
          width: mediaQuery.width,
          child: Stack(
            children: <Widget>[
              Center(
                child: MaterialButton(
                  color: Colors.white,
                  child: Text(
                    "Elastic NavBar",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  onPressed: () {},
                ),
              ),
              //SizeBox contain sideBar
              AnimatedPositioned(
                duration: Duration(milliseconds: 400),
                //20 gonna always open
                left: isMenuOpen ? 0 : -sidebarSize + 20,
                top: 0,
                curve: Curves.elasticOut,
                child: SizedBox(
                  width: sidebarSize,
                  child: GestureDetector(
                    //we can get moving location
                    onPanUpdate: (details) {
                      /// return fingure position on the screen
                      ///
                      /// checking if fingure out of sideBar,nothing gonna change
                      if (details.localPosition.dx <= sidebarSize) {
                        setState(() {
                          _offset = details.localPosition;
                        });
                      }

                      //opening sideBar
                      if (details.localPosition.dx > sidebarSize - 20 &&
                          details.delta.distanceSquared > 2) {
                        setState(() {
                          isMenuOpen = true;
                        });
                      }
                    },
                    //we can detect when click on screen
                    onPanEnd: (details) {
                      setState(() {
                        //while pull out fingure from screen,
                        _offset = Offset(0, 0);
                      });
                    },
                    child: Stack(
                      children: <Widget>[
                        CustomPaint(
                          size: Size(sidebarSize, mediaQuery.height),
                          painter: DrawerPainter(offset: _offset),
                        ),
                        Container(
                          height: mediaQuery.height,
                          width: sidebarSize,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Container(
                                height: mediaQuery.height * .25,
                                child: Center(
                                  child: Column(
                                    children: <Widget>[
                                      Image.asset(
                                        "assets/images/smile.jpg",
                                        width: sidebarSize / 2,
                                      ),
                                      Text(
                                        "Senorita👼🏿",
                                        style: TextStyle(color: Colors.black54),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Divider(
                                thickness: 2,
                              ),
                              Container(
                                key: globalKey,
                                width: double.infinity,
                                height: menuContainerHeight,
                                child: Column(
                                  children: <Widget>[
                                    //being 5 button devided by 5
                                    MyButton(
                                      text: "Profile",
                                      iconData: Icons.person,
                                      textSize: getSize(0),
                                      height: (menuContainerHeight) / 5,
                                    ),
                                    MyButton(
                                      text: "Payments",
                                      iconData: Icons.payment,
                                      textSize: getSize(1),
                                      height: (menuContainerHeight) / 5,
                                    ),
                                    MyButton(
                                      text: "Notifications",
                                      iconData: Icons.notifications,
                                      textSize: getSize(2),
                                      height: (mediaQuery.height / 2) / 5,
                                    ),
                                    MyButton(
                                      text: "Settings",
                                      iconData: Icons.settings,
                                      textSize: getSize(3),
                                      height: (menuContainerHeight) / 5,
                                    ),
                                    MyButton(
                                      text: "Files",
                                      iconData: Icons.attach_file,
                                      textSize: getSize(4),
                                      height: (menuContainerHeight) / 5,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        //sidebar clossing button
                        AnimatedPositioned(
                            right: isMenuOpen ? 10 : sidebarSize,
                            bottom: 30,
                            child: IconButton(
                              icon: Icon(Icons.backspace_outlined),
                              enableFeedback: true,
                              onPressed: () {
                                this.setState(() {
                                  isMenuOpen = false;
                                });
                              },
                            ),
                            duration: Duration(milliseconds: 350)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  final String text;
  final IconData iconData;
  final double textSize;
  final double height;

  MyButton({this.text, this.iconData, this.textSize, this.height});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Icon(
            iconData,
            color: Colors.black45,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            text,
            style: TextStyle(color: Colors.black45, fontSize: textSize),
          ),
        ],
      ),
      onPressed: () {},
    );
  }
}
