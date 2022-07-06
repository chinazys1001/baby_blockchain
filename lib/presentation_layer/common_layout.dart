import 'package:baby_blockchain/presentation_layer/constants.dart';
import 'package:baby_blockchain/presentation_layer/screens/account_screen.dart';
import 'package:baby_blockchain/presentation_layer/screens/my_robots_screen.dart';
import 'package:baby_blockchain/presentation_layer/screens/transfer_rights_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

class CommonLayout extends StatefulWidget {
  const CommonLayout({Key? key}) : super(key: key);

  @override
  State<CommonLayout> createState() => _CommonLayoutState();
}

class _CommonLayoutState extends State<CommonLayout> {
  int _selectedScreen = 1;
  static const List<Widget> _screens = <Widget>[
    AccountScreen(),
    MyRobotsScreen(),
    TransferRightsScreen(),
  ];

  Widget getResponsiveDriverWidget() {
    // bottom navigation bar for mobile phones
    if (MediaQuery.of(context).size.width < mobileScreenMaxWidthh) {
      return Scaffold(
        backgroundColor: BackgroundColor,
        body: Center(
          child: _screens.elementAt(_selectedScreen),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: LightColor,
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Colors.black.withOpacity(0.1),
              )
            ],
          ),
          child: GNav(
            rippleColor: SplashColor,
            activeColor: AccentColor,
            color: DisabledColor,
            tabBackgroundColor: ShadowColor,
            iconSize: 24,
            gap: 8,
            padding: const EdgeInsets.all(20),
            selectedIndex: _selectedScreen,
            onTabChange: (index) {
              setState(() {
                _selectedScreen = index;
              });
            },
            tabs: const [
              GButton(
                icon: LineIcons.userCog,
                text: 'Account',
              ),
              GButton(
                icon: LineIcons.robot,
                text: 'My Robots',
              ),
              GButton(
                icon: LineIcons.alternateExchange,
                text: 'Transfer Rights',
              ),
            ],
          ),
        ),
      );
    }
    // tab bar for desktops & tablets
    return DefaultTabController(
      length: 3,
      initialIndex: _selectedScreen,
      child: Scaffold(
        backgroundColor: BackgroundColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
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
            labelColor: LightColor,
            indicatorColor: LightColor,
            indicatorWeight: 4.0,
            tabs: [
              Tab(
                child: Text(
                  'Account',
                  style: TextStyle(fontSize: mediumFontSize),
                ),
              ),
              Tab(
                child: Text(
                  'My Robots',
                  style: TextStyle(fontSize: mediumFontSize),
                ),
              ),
              Tab(
                child: Text(
                  'Transfer Rights',
                  style: TextStyle(fontSize: mediumFontSize),
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
