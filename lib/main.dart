import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/root/bloc.dart';
import 'views/root.dart';

void main() {
  final ThemeData appTheme = ThemeData.dark();

  runApp(MyApp(
    theme: ThemeData.from(
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: Colors.deepPurple,
        onPrimary: Colors.white,
        secondary: Colors.white,
        onSecondary: Colors.black,
        tertiary: Colors.purpleAccent[700],
        onTertiary: Colors.black,
        error: Colors.red,
        onError: Colors.white,
        background: Colors.grey[900]!,
        onBackground: Colors.grey[300]!,
        surface: Colors.grey[850]!,
        onSurface: Colors.grey[300]!,
      ),
    ),
  ));
}

class MyApp extends StatelessWidget {
  final ThemeData theme;

  const MyApp({
    required this.theme,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Lab 2.1',
        theme: theme,
        home: Scaffold(
          body: BlocProvider(
            create: (context) => RootBloc(),
            child: Root(),
          ),
        ),
      );
}
