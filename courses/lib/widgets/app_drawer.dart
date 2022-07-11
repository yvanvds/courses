import 'package:courses/convienience/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  static int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: _selectedIndex,
      labelType: NavigationRailLabelType.all,
      elevation: 5,
      backgroundColor: AppTheme.colorDark,
      unselectedIconTheme:
          IconThemeData(color: AppTheme.colorLightest, size: 40, opacity: 0.7),
      unselectedLabelTextStyle: AppTheme.text.bodyText1,
      selectedIconTheme:
          IconThemeData(color: AppTheme.colorAccent, size: 40, opacity: 0.7),
      selectedLabelTextStyle:
          AppTheme.text.bodyText1!.copyWith(color: AppTheme.colorAccent),
      onDestinationSelected: (index) {
        setState(() {
          _selectedIndex = index;
          String route = '/';
          switch (_selectedIndex) {
            case 0:
              route = '/';
              break;
            default:
              route = '/';
              break;
          }
          context.go(route);
        });
      },
      destinations: const [
        NavigationRailDestination(
          icon: Icon(Icons.home),
          selectedIcon: Icon(Icons.home_outlined),
          label: Text('Dashboard'),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.account_circle),
          selectedIcon: Icon(Icons.account_circle_outlined),
          label: Text('Account'),
        ),
      ],
    );
  }
}
