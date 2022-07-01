import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mason/core/providers/user_auth.dart';
import 'package:provider/provider.dart';

import 'core/services/cloud_functions/cloud_functions_dao.dart';
import 'core/services/item_dao.dart';

import 'navigation/navigation.dart';
import 'utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    // comes with firebase_options.dart   ->>> needs to be created by Firebase
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          Provider(
            create: (_) => CloudFunctionsDAO(),
            lazy: false,
          ),
          Provider(
            create: (_) => ItemDAO(),
            lazy: false,
          ),
          ChangeNotifierProvider<UserAuth>.value(value: userAuth),
        ],
        child: MaterialApp.router(
          scaffoldMessengerKey: snackbarKey,
          scrollBehavior: ScrollConfiguration.of(context).copyWith(
              scrollbars:
                  false), // to avoid scroll errors in chrome // other option is to name every scrollcontroller
          routeInformationParser: goRouter.routeInformationParser,
          routerDelegate: goRouter.routerDelegate,
          debugShowCheckedModeBanner: false,
          title: 'News App',
          theme: ThemeData(primarySwatch: Colors.blue),
        ));
  }
}
