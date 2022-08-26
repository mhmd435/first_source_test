import 'package:first_source_test/config/my_theme.dart';
import 'package:first_source_test/config/strings.dart';
import 'package:first_source_test/features/feature_price_tracker/presentation/bloc/price_tracker_cubit/price_tracker_cubit.dart';
import 'package:first_source_test/features/feature_price_tracker/presentation/bloc/theme_cubit/theme_cubit.dart';
import 'package:first_source_test/features/feature_price_tracker/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'locator.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  /// don't allow app to landscape mode
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp,],
  );

  /// init service locator
  await initLocator();

  // runApp(const MyApp());
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => locator<ThemeCubit>()),
      BlocProvider(create: (_) => locator<PriceTrackerCubit>()),
    ],
    child: const MyApp(),
  ),);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state){
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: state.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          theme: MyThemes.lightTheme,
          darkTheme: MyThemes.darkTheme,
          title: Strings.appName,
          home: const HomeScreen(),
        );
      },
    );
  }
}
