import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

class AppIcon {
  final String value;

  const AppIcon(this.value);

  Widget draw({double? size}) => SvgPicture.asset(
        'assets/icon/$value',
        width: size ?? 24,
        height: size ?? 24,
      );

  static const AppIcon add = AppIcon('add.svg');
  static const AppIcon chevron = AppIcon('chevron.svg');
  static const AppIcon delete = AppIcon('delete.svg');
  static const AppIcon infoFilled = AppIcon('info_filled.svg');
  static const AppIcon info = AppIcon('info.svg');
  static const AppIcon pencil = AppIcon('pencil.svg');
  static const AppIcon search = AppIcon('search.svg');
  static const AppIcon eye = AppIcon('eye.svg');
  static const AppIcon save = AppIcon('save.svg');
}
