import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wellness_app/views/home_page.dart';
import './views/basescreen.dart';
import './views/browse_page.dart';
import './views/journal_page.dart';
import './views/login_page.dart';
import './views/animation.dart';
import 'controllers/activity_controller.dart';
import 'controllers/journal_controller.dart';
import './views/moods_page.dart';
import './views/user_provider.dart';  // Import the UserProvider

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ActivityController()),
        ChangeNotifierProvider(create: (_) => MoodProvider()),
        ChangeNotifierProvider(create: (_) => JournalController()),
        ChangeNotifierProvider(create: (_) => UserProvider()),  // Provide UserProvider
      ],
      child: MaterialApp(
        title: 'Mindfulness and Wellness',
        theme: ThemeData(primarySwatch: Colors.blue),
        initialRoute: '/animation',
        routes: {
          '/animation': (context) => const SplashScreen(),
          '/login': (context) => const LoginPage(),
          '/home': (context) => Builder(
      builder: (BuildContext context) {
      final userId = Provider.of<UserProvider>(context).userId;
      return MyHomePage(userId: userId!); // Use ! to assert that userId is not null
      },
      ),
          '/browse': (context) => const ExploreScreen(),
          '/journal': (context) => const JournalScreen(),
        },
        onUnknownRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => const LoginPage(),
          );
        },
      ),
    );
  }
}
