import 'package:flutter_application_2/config/theme/helper/get_yes_no_answer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('pickWeightedAnswer respeta 40/40/20 en muestra grande', () {
    final service = GetYesNoAnswer();
    var yes = 0;
    var no = 0;
    var maybe = 0;

    for (var i = 0; i < 10000; i++) {
      switch (service.pickWeightedAnswer()) {
        case YesNoAnswerKind.yes:
          yes++;
        case YesNoAnswerKind.no:
          no++;
        case YesNoAnswerKind.maybe:
          maybe++;
      }
    }

    expect(yes, inInclusiveRange(3600, 4400));
    expect(no, inInclusiveRange(3600, 4400));
    expect(maybe, inInclusiveRange(1600, 2400));
  });
}
