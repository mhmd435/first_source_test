import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState(isDarkMode: true));

  /// emit true/false when goto dark mode or light Mode
  void changeTheme() => emit(state.copyWith(newIsDarkMode: !state.isDarkMode));

}
