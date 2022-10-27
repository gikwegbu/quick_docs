import 'package:flutter/material.dart';
import 'package:quick_docs/screens/home/home_screen.dart';
import 'package:quick_docs/screens/login/login_screen.dart';
import 'package:routemaster/routemaster.dart';


// The routes users can see when logged out.
final loggedOutRoute = RouteMap(routes: {
  '/': (route) => const MaterialPage(child: LoginScreen()),
});

// The routes users can see when logged in.
final loggedInRoute = RouteMap(routes: {
  "/": (route) => const MaterialPage(child: HomeScreen()),
  // ""
});