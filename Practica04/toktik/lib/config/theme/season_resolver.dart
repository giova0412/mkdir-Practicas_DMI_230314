import 'package:toktik/domain/entities/season.dart';

class SeasonResolver {
  const SeasonResolver();

  static Season resolveByDate(DateTime date) {
    final month = date.month;
    final day = date.day;

    if (month == 10 && day >= 25 && day <= 31) {
      return Season.halloween;
    }

    if ((month == 12 && day >= 15) || (month == 1 && day <= 6)) {
      return Season.christmas;
    }

    if (month == 2 && day >= 10 && day <= 20) {
      return Season.valentine;
    }

    return Season.normal;
  }

  static Season resolveByCurrentDate() => resolveByDate(DateTime.now());
}
