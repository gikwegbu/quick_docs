# quick_docs

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.



## Instructions:

1. To spinup the server, run: 'npm run dev'. This starts the development server using nodemon. Just check the README.md  in the 'Server Folder to know more about the server setup.'

2. To launch the app on chrome, use 'flutter run -d chrome --web-hostname localhost --web-port 3000'.

3. For navigation, we'd be using navigator 2.0, but for web's dynamic routing, we'd be using routemaster, which is like same with reactRouter.

4. On your main, instead of returning just the MaterialApp, return MaterialApp.router.

5. Anywhere Navigator.of(context) was used to navigate, change it to Routemaster.of(context);

