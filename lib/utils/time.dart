class ParsedTime {

  static String secondsToString(int time) {

    final seconds = time % 60;
    final minutes = time ~/ 60;
    final secondsText = seconds >= 10 ? '$seconds' : '0$seconds';
    final minutesText = minutes >= 10 ? '$minutes' : '0$minutes';

    return '$minutesText:$secondsText';
  }
}