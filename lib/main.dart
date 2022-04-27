import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lab2_1/bloc/root/events.dart';

import 'bloc/root/bloc.dart';
import 'data/calculations_repository.dart';
import 'views/root.dart';

void main() => runApp(MyApp(
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
          body: RepositoryProvider(
            create: (context) => CalculationsRepository(),
            child: BlocProvider(
              create: (context) =>
                  RootBloc(context.read<CalculationsRepository>())
                    ..add(AppLoaded()),
              child: Root(),
            ),
          ),
        ),
      );
}
