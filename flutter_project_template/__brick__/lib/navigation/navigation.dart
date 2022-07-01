import 'package:flutter/material.dart';
import 'package:flutter_mason/core/providers/user_auth.dart';

import 'package:go_router/go_router.dart';

import '../../utils/constants.dart';

final GoRouter goRouter = GoRouter(
    routes: [
      GoRoute(
        name: 'home',
        path: '/',
        builder: (context, state) => const Home(),
      ),
      GoRoute(
          path: '/splash',
          builder: (context, state) => const SplashPage(),
          name: 'splash'),
      GoRoute(
          name: 'login',
          path: '/login',
          builder: (context, state) => const LoginPage(),
          routes: [
            GoRoute(
                path: 'signup',
                builder: (context, state) => SignUpPage(),
                name: 'signup'),
          ]),
      // GoRoute(
      //     path: '/boarding', builder: (context, state) => const BoardingPage())
    ],
    // initialLocation: '/splash',
    refreshListenable: userAuth,
    redirect: (GoRouterState state) {
      //code is executed from top to bottom..
      // if (!appStateManager.isInitialized) {
      //   //deep linking
      //   if (state.subloc != '/splash') {
      //     return '/splash' + '?next=${state.location}';
      //   }
      //   return null;
      // }

      // if (!appStateManager.isBoarded) {
      //   if (state.subloc != '/boarding') {
      //     return '/boarding';
      //   }
      //   return null;
      // }

      if (!userAuth.isLoggedin()) {
        // if not logged in but on the sign up page just do nothing
        if (state.subloc == '/login/signup') {
          return null;
        }

        // if not logged in but on a different page than login or signup go to the login page
        if (state.subloc != '/login') {
          const SnackBar snackBar = SnackBar(content: Text("Please login"));
          snackbarKey.currentState?.showSnackBar(snackBar);
          return '/login';
        }
        return null;
      }

      if (!userAuth.isEmailVerified()) {
        // if not verified in but on the sign up page just do nothing
        if (state.subloc == '/login/signup') {
          return null;
        }

        // if not verified in but on a different page than login or signup go to the login page
        if (state.subloc != '/login') {
          // show a snack to instruct that the user needs to verify their email
          const SnackBar snackBar =
              SnackBar(content: Text("Please verify your email"));
          snackbarKey.currentState?.showSnackBar(snackBar);
          return '/login';
        }
        return null;
      }

      if (state.subloc == '/splash' || state.subloc == '/login') {
        if (state.queryParams.containsKey('next')) {
          //deep linking
          return state.queryParams['next']!;
        }
        return '/';
      }
      return null;
    });
