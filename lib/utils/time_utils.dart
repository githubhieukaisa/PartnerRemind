/// Helper class for formatting time durations
class TimeUtils {
  /// Format seconds into HH:MM:SS or MM:SS
  static String formatSeconds(int totalSeconds) {
    if (totalSeconds < 0) return '00:00';
    
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;
    
    final mStr = minutes.toString().padLeft(2, '0');
    final sStr = seconds.toString().padLeft(2, '0');
    
    if (hours > 0) {
      final hStr = hours.toString().padLeft(2, '0');
      return '$hStr:$mStr:$sStr';
    }
    
    return '$mStr:$sStr';
  }
  
  /// Format seconds into readable text (e.g. "120m" or "45m 30s")
  static String formatSecondsToText(int totalSeconds) {
    if (totalSeconds == 0) return '0m';
    
    final isNegative = totalSeconds < 0;
    final absSeconds = totalSeconds.abs();
    
    final minutes = absSeconds ~/ 60;
    final seconds = absSeconds % 60;
    
    String result = '${minutes}m';
    if (seconds > 0) {
      result += ' ${seconds}s';
    }
    
    return (isNegative ? '-' : '') + result;
  }
}
