import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/errors/failures.dart';
import 'scan_model.dart';

class ScanApiService {
  final DioClient _dioClient;

  ScanApiService(this._dioClient);

  Future<ScanModel> scanUrl(String url) async {
    try {
      final response = await _dioClient.dio.post(
        ApiConstants.predictUrl,
        data: {'url': url},
      );

      return ScanModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw const NetworkFailure('Connection timeout');
      } else if (e.type == DioExceptionType.connectionError) {
        throw const NetworkFailure('No internet connection');
      } else {
        throw ServerFailure(e.message ?? 'Server error occurred');
      }
    } catch (e) {
      throw UnknownFailure('An unexpected error occurred: $e');
    }
  }

  Future<List<ScanModel>> getScanHistory() async {
    try {
      final response = await _dioClient.dio.get('/history');

      return (response.data as List)
          .map((json) => ScanModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        throw const NetworkFailure('Connection timeout');
      } else if (e.type == DioExceptionType.connectionError) {
        throw const NetworkFailure('No internet connection');
      } else {
        throw ServerFailure(e.message ?? 'Server error occurred');
      }
    } catch (e) {
      throw UnknownFailure('An unexpected error occurred: $e');
    }
  }
}
