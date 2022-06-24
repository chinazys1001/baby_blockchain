import 'package:baby_blockchain/constants.dart';
import 'package:baby_blockchain/data_layer/firebase_options.dart';
import 'package:baby_blockchain/presentation_layer/account_screen.dart';
import 'package:baby_blockchain/presentation_layer/my_robots_screen.dart';
import 'package:baby_blockchain/presentation_layer/transfer_rights_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BabyBlockchain',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedScreen = 1;
  static const List<Widget> _screens = <Widget>[
    AccountScreen(),
    MyRobotsScreen(),
    TransferRightsScreen(),
  ];

  Widget getResponsiveDriverWidget() {
    if (MediaQuery.of(context).size.width < 600) {
      return Scaffold(
        backgroundColor: BackgroundColor,
        appBar: AppBar(
          backgroundColor: AccentColor,
          centerTitle: true,
          title: Text(
            'BabyBlockchain',
            style: GoogleFonts.fredokaOne(
              color: LightColor,
              fontSize: bigFontSize,
            ),
          ),
        ),
        body: Center(
          child: _screens.elementAt(_selectedScreen),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: LightColor,
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Colors.black.withOpacity(.1),
              )
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
              child: GNav(
                rippleColor: SplashColor,
                gap: 8,
                activeColor: AccentColor,
                iconSize: 24,
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                tabBackgroundColor: BackgroundColor,
                color: ShadowColor,
                selectedIndex: _selectedScreen,
                onTabChange: (index) {
                  setState(() {
                    _selectedScreen = index;
                  });
                },
                tabs: const [
                  GButton(
                    icon: Icons.account_box_outlined,
                    text: 'Account',
                  ),
                  GButton(
                    icon: Icons.rocket_launch_outlined,
                    text: 'My Robots',
                  ),
                  GButton(
                    icon: Icons.change_circle_outlined,
                    text: 'Transfer Rights',
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return DefaultTabController(
      length: 3,
      initialIndex: _selectedScreen,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AccentColor,
          centerTitle: true,
          title: Text(
            'BabyBlockchain',
            style: GoogleFonts.fredokaOne(
              color: LightColor,
              fontSize: bigFontSize,
            ),
          ),
          bottom: const TabBar(
            labelColor: AccentColor,
            indicatorColor: AccentColor,
            indicatorWeight: 4.0,
            tabs: [
              Tab(
                child: Text(
                  'Account',
                  style: TextStyle(
                    color: LightColor,
                    fontSize: mediumFontSize,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'My Robots',
                  style: TextStyle(
                    color: LightColor,
                    fontSize: mediumFontSize,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'Transfer Rights',
                  style: TextStyle(
                    color: LightColor,
                    fontSize: mediumFontSize,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: _screens,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return getResponsiveDriverWidget();
  }
}
