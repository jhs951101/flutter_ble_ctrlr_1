class RouteName {
  factory RouteName() => _instance;

  RouteName._internal();

  static final RouteName _instance = RouteName._internal();
  
  final String test1 = '/test1';
  final String test2 = '/test2';

  final String splash = '/';
  final String home = '/home';
}
