enum FastingTimer {
  fourteenTen,
  sixteenEight,
  eighteenSix,
  twentyFour,
}

extension FastingTimerExtension on FastingTimer {
  String get label {
    switch (this) {
      case FastingTimer.fourteenTen:
        return '14-10';
      case FastingTimer.sixteenEight:
        return '16-8';
      case FastingTimer.eighteenSix:
        return '18-6';
      case FastingTimer.twentyFour:
        return '20-4';
      default:
        return '';
    }
  }

  // int get fastingDuration {
  //   switch (this) {
  //     case FastingTimer.fourteenTen:
  //       return 14 * 3600;
  //     case FastingTimer.sixteenEight:
  //       return 16 * 3600;
  //     case FastingTimer.eighteenSix:
  //       return 18 * 3600;
  //     case FastingTimer.twentyFour:
  //       return 20 * 3600;
  //     default:
  //       return 0;
  //   }
  // }
  int get fastingDuration {
    switch (this) {
      case FastingTimer.fourteenTen:
        return 1 * 60;
      case FastingTimer.sixteenEight:
        return 3 * 180;
      case FastingTimer.eighteenSix:
        return 5 * 3600;
      case FastingTimer.twentyFour:
        return 10 * 3600;
      default:
        return 0;
    }
  }

  int get eatingDuration {
    switch (this) {
      case FastingTimer.fourteenTen:
        return 10;
      case FastingTimer.sixteenEight:
        return 8;
      case FastingTimer.eighteenSix:
        return 6;
      case FastingTimer.twentyFour:
        return 4;
      default:
        return 0;
    }
  }
}
