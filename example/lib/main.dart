// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:moosyl/moosyl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static const colorScheme = ColorScheme.light(
    primary: Color(0xFF4445F4),
    onPrimary: Color(0xFFFFFFFF),
    surface: Color(0xFFF0F0F0),
    onSurface: Color(0xFF000000),
    secondary: Color(0xFFEAF1FF),
    onSecondary: Color(0xFF000000),
    error: Color(0xFFCE2C2C),
    tertiary: Color(0xFF01D066),
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Moosyl  Demo',
      localizationsDelegates: MoosylLocalization.localizationsDelegates,
      supportedLocales: MoosylLocalization.supportedLocales,
      locale: const Locale('en'),
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: colorScheme,
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Moosyl Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: MoosylView(
        //withScaffold: true,
        apiKey:
            'hjafbhawbfj3bhj232i23jd2bmdhaggd737732jvgmdbvvajd721yiejhddadcnkc338',
        transactionId: '507876',
        organizationLogo: const Text('Moosyl'),
        fullPage: false,
        customHandlers: {
          PaymentMethodTypes.bimBank: () {
            print('Moosyl');
          },
        },
        customIcons: const {},
        // inputBuilder: (onCall) {
        //   return ElevatedButton(
        //     onPressed: onCall,
        //     child: const Text('Buy'),
        //   );
        // },
        onPaymentSuccess: () {
          print('object');
        },
      ),
    );
  }
}
