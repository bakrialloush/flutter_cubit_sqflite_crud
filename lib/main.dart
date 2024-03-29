import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_db/cubit/books_cubit.dart';
import 'package:test_db/cubit/users_cubit.dart';

import 'pages/home_page.dart';

const Color _themeColor = Colors.green;
const ThemeMode _themeBrightness = ThemeMode.light;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final UsersCubit userCubit = UsersCubit();
  final BooksCubit bookCubit = BooksCubit();
  await userCubit.refresh();
  await bookCubit.refresh();

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => userCubit),
      BlocProvider(create: (_) => bookCubit),
    ],
    child: const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomePage(),
      theme: ThemeData(
        colorSchemeSeed: _themeColor,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorSchemeSeed: _themeColor,
        brightness: Brightness.dark,
      ),
      themeMode: _themeBrightness,
      debugShowCheckedModeBanner: false,
    );
  }
}
