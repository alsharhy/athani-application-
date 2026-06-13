import '../../domain/entities/prayer_times_entity.dart';

class PrayerTimesModel extends PrayerTimesEntity {
  const PrayerTimesModel({
    required super.timings,
    required super.dateReadable,
    required super.dateHijri,
  });

  factory PrayerTimesModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    final timings = Map<String, String>.from(data['timings']);
    final date = data['date'];
    
    return PrayerTimesModel(
      timings: timings,
      dateReadable: date['readable'],
      dateHijri: '${date['hijri']['day']} ${date['hijri']['month']['ar']} ${date['hijri']['year']}',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timings': timings,
      'date': {
        'readable': dateReadable,
        'hijri': {
          'day': dateHijri.split(' ')[0],
          'month': {'ar': dateHijri.split(' ')[1]},
          'year': dateHijri.split(' ')[2],
        }
      }
    };
  }
}
