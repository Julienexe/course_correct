import 'package:flutter/material.dart';

//a place to build and design logic for reusable widgets and useful assets such as the app bar, bottom bar and much more

const TextStyle defaultTextStyle = TextStyle(
    fontFamily: 'Arial',
    fontWeight: FontWeight.w500,
    color: Color.fromARGB(255, 134, 133, 133));

const themeColor = Color.fromARGB(255, 64, 120, 166);

TextStyle bannerTextStyle = defaultTextStyle.copyWith(
  fontSize: 20,
  color: themeColor,
  fontWeight: FontWeight.bold,
);

Container curriculumBox(text) {
  //creates a box around text, could be modified to add an icon as well, to the right of the text
  return Container(
    height: 50,
    margin: const EdgeInsets.all(10),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
        //border
        border: Border.all(
      color: const Color.fromARGB(255, 208, 207, 207),
      width: 1,
    )),
    child: Text(
      text,
      style:
          defaultTextStyle.copyWith(fontSize: 17, fontWeight: FontWeight.w900),
    ),
  );
}

// class Material3BottomNav extends StatelessWidget {
//   Material3BottomNav({super.key});
//   final _tab1navigatorKey = GlobalKey<NavigatorState>();
//   final _tab2navigatorKey = GlobalKey<NavigatorState>();
//   final _tab3navigatorKey = GlobalKey<NavigatorState>();

//   @override
//   Widget build(BuildContext context) {
//     return PersistentBottomBarScaffold(
//       items: [
//         PersistentTabItem(
//           tab:  const Homepage(),
//           icon: Icons.home,
//           title: 'Home',
//           navigatorkey: _tab1navigatorKey,
//         ),
//         PersistentTabItem(
//           tab: const DashboardPage(),
//           icon: Icons.search,
//           title: 'Search',
//           navigatorkey: _tab2navigatorKey,
//         ),
//         PersistentTabItem(
//           tab: const ProfilePage1(),
//           icon: Icons.person,
//           title: 'Profile',
//           navigatorkey: _tab3navigatorKey,
//         ),
//       ],
//     );
//   }
// }

//homepage reusable widgets
