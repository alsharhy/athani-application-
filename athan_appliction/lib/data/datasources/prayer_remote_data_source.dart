import 'package:dio/dio.dart';
import '../../core/constants/app_constants.dart';
import '../../core/errors/failures.dart';
import '../models/prayer_times_model.dart';

abstract class PrayerRemoteDataSource {
  Future<PrayerTimesModel> getPrayerTimes(double latitude, double longitude, int method);
}

class PrayerRemoteDataSourceImpl implements PrayerRemoteDataSource {
  final Dio dio;

  PrayerRemoteDataSourceImpl(this.dio);

  @override
  Future<PrayerTimesModel> getPrayerTimes(double latitude, double longitude, int method) async {
    try {
      final response = await dio.get(
        AppConstants.baseUrl,
        queryParameters: {
          'latitude': latitude,
          'longitude': longitude,
          'method': method,
        },
      );

      if (response.statusCode == 200) {
        return PrayerTimesModel.fromJson(response.data);
      } else {
        throw const ServerFailure();
      }
    } on DioException {
      throw const NetworkFailure();
    } catch (e) {
      throw const ServerFailure();
    }
  }
}
