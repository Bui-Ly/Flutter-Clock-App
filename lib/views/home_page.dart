import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clock_app/constants/theme_data.dart';
import 'package:flutter_clock_app/custom_views/clock_view.dart';
import 'package:flutter_clock_app/constants/enums.dart';
import 'package:flutter_clock_app/models/menu_info.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'alarm_page.dart';
import 'clock_page.dart';
import '../data.dart';

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var formatterTime = DateFormat('HH : mm').format(now);
    var formatterDate = DateFormat('EEE, d MMM').format(now);
    var timezoneString = now.timeZoneOffset.toString().split('.').first;
    var offsetSign = '';
    if (!timezoneString.startsWith('-')) {
      offsetSign = '+';
    }
    print('timezone: $timezoneString');

    return Scaffold(
      backgroundColor: Color(0xFF2D2F41),
      body: SafeArea(
        child: Row(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: menuItems
                  .map(
                    (currentMenuInfo) => buildMenuButton(currentMenuInfo),
                  )
                  .toList(),
            ),
            VerticalDivider(
              color: Colors.white54,
              width: 1,
            ),
            Expanded(
              child: Consumer<MenuInfo>(
                builder: (BuildContext context, MenuInfo value, Widget child) {
                  if (value.menuType == MenuType.clock) {
                    return ClockPage();
                  } else if (value.menuType == MenuType.alarm) {
                    return AlarmPage();
                  } else {
                    return Container(
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(fontSize: 20),
                          children: <TextSpan>[
                            TextSpan(text: 'Upcoming \n'),
                            TextSpan(text: value.title, style: TextStyle(fontSize: 48)),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

// MARK: - func
  Widget buildMenuButton(MenuInfo currentMenuInfo) {
    return Consumer<MenuInfo>(
      builder: (BuildContext context, MenuInfo value, Widget child) {
        return FlatButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topRight: Radius.circular(32)),
          ),
          padding: EdgeInsets.symmetric(vertical: 16),
          color: currentMenuInfo.menuType == value.menuType ? CustomColors.menuBackgroundColor : Colors.transparent,
          onPressed: () {
            var menuInfo = Provider.of<MenuInfo>(context, listen: false);
            menuInfo.updateMenu(currentMenuInfo);
          },
          child: Column(
            children: <Widget>[
              Image.asset(currentMenuInfo.imageSource, scale: 1.5),
              SizedBox(height: 16),
              Text(
                currentMenuInfo.title ?? '',
                style: TextStyle(
                  fontFamily: 'avenir',
                  color: Colors.white,
                  fontSize: 14,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
