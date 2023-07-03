import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

class AppImage {
  final String value;

  const AppImage(this.value);

  Widget draw({double? width, double? height}) => SvgPicture.asset(
        'assets/image/$value',
        width: width ?? 100,
        height: height ?? 100,
      );

  static const AppImage notebook = AppImage('notebook.svg');
  static const AppImage fileSearching = AppImage('chefile_searchingvron.svg');
}
