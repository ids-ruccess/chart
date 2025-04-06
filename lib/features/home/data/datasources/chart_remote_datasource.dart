import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../../../../core/api/dio_client.dart';
import '../../domain/entities/chart_data.dart';

class ChartRemoteDataSource {
  final DioClient dioClient;
  ChartRemoteDataSource(this.dioClient);

  Future<ChartData> fetchChartData(String date) async {
    try {
      final response = await dioClient.get('/v1/user/app/glucose?date=$date');
      debugPrint("--------------");
      debugPrint(date);
      if (response.statusCode == 200) {
        final jsonData = response.data is String
            ? json.decode(response.data)
            : response.data;

        debugPrint(response.data.toString());
        return ChartData.fromJson(jsonData);
      } else {
        throw Exception('Failed to load chart data');
      }
    } on DioException catch (e) {
      throw Exception('DioError: ${e.message}');
    }
  }
}