part of 'theme_cubit.dart';

class ThemeState extends Equatable{
  final bool isDarkMode;

  const ThemeState({required this.isDarkMode});

  ThemeState copyWith({
    bool? newIsDarkMode,
  }){
    return ThemeState(
        isDarkMode: newIsDarkMode ?? isDarkMode,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [isDarkMode];
}
