import 'package:baby_blockchain/presentation_layer/constants.dart';
import 'package:baby_blockchain/presentation_layer/screens/account_screen.dart';
import 'package:baby_blockchain/presentation_layer/screens/confirmed_operations_screen.dart';
import 'package:baby_blockchain/presentation_layer/screens/my_robots_screen.dart';
import 'package:baby_blockchain/presentation_layer/screens/pending_operations_screen.dart';
import 'package:baby_blockchain/presentation_layer/screens/transfer_rights_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

class CommonLayout extends StatefulWidget {
  const CommonLayout({Key? key, this.screenIndex}) : super(key: key);

  final int? screenIndex;

  @override
  State<CommonLayout> createState() => _CommonLayoutState();
}

class _CommonLayoutState extends State<CommonLayout> {
  int _selectedScreen = 1;
  final List<Widget> _screens = <Widget>[
    const AccountScreen(),
    const MyRobotsScreen(),
    const TransferRightsScreen(),
    const PendingOperationsScreen(),
    const ConfirmedOperationsScreen(),
  ];

  @override
  void initState() {
    if (widget.screenIndex != null) _selectedScreen = widget.screenIndex!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
          rippleColor: RippleColor,
          activeColor: PrimaryColor,
          backgroundColor: LightColor,
          hoverColor: BackgroundColor,
          color: DisabledColor,
          tabBackgroundColor: RippleColor,
          iconSize: 24,
          gap: 8,
          padding: EdgeInsets.symmetric(
              horizontal:
                  MediaQuery.of(context).size.width < mobileScreenMaxWidth
                      ? 12
                      : 24,
              vertical: 24),
          selectedIndex: _selectedScreen,
          onTabChange: (index) {
            setState(() {
              _selectedScreen = index;
            });
          },
          tabs: [
            GButton(
              icon: LineIcons.userCog,
              text: MediaQuery.of(context).size.width < mobileScreenMaxWidth
                  ? 'Account'
                  : 'My Account',
            ),
            GButton(
              icon: LineIcons.robot,
              text: MediaQuery.of(context).size.width < mobileScreenMaxWidth
                  ? 'Robots'
                  : 'My Robots',
            ),
            GButton(
              icon: LineIcons.alternateExchange,
              text: MediaQuery.of(context).size.width < mobileScreenMaxWidth
                  ? 'Transfer'
                  : 'Transfer Rights',
            ),
            GButton(
              icon: LineIcons.spinner,
              text: MediaQuery.of(context).size.width < mobileScreenMaxWidth
                  ? 'Pending'
                  : 'Pending Operations',
            ),
            GButton(
              icon: LineIcons.alternateListAlt,
              text: MediaQuery.of(context).size.width < mobileScreenMaxWidth
                  ? 'Confirmed'
                  : 'Confirmed Operations',
            ),
          ],
        ),
      ),
    );
  }
}
