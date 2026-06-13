import 'package:equatable/equatable.dart';

class PrayerTimesEntity extends Equatable {
  final Map<String, String> timings;
  final String dateReadable;
  final String dateHijri;

  const PrayerTimesEntity({
    required this.timings,
    required this.dateReadable,
    required this.dateHijri,
  });

  @override
  List<Object> get props => [timings, dateReadable, dateHijri];
}
