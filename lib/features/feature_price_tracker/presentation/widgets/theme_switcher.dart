
import 'package:first_source_test/features/feature_price_tracker/presentation/bloc/theme_cubit/theme_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeSwitcher extends StatefulWidget {
  const ThemeSwitcher({super.key});

  @override
  State<ThemeSwitcher> createState() => _ThemeSwitcherState();
}

class _ThemeSwitcherState extends State<ThemeSwitcher> {

  @override
  Widget build(BuildContext context) {


    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state){

        /// check true/false for set Icon
        final switchIcon = Icon(state.isDarkMode ? CupertinoIcons.moon_fill : CupertinoIcons.sun_max_fill);

        return IconButton(
            icon: switchIcon,
            onPressed: () {
              /// change theme with click on IconBtn
              BlocProvider.of<ThemeCubit>(context).changeTheme();
            },);
      },
    );
  }
}
