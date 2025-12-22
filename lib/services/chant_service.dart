import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spiritual_chanting/models/chant.dart';
import 'package:spiritual_chanting/core/constants.dart';

class ChantService {
  static final ChantService _instance = ChantService._internal();
  factory ChantService() => _instance;
  ChantService._internal();

  static String get remoteUrl {
        const env = String.fromEnvironment('APP_ENV', defaultValue: 'prod');
        return env == 'dev' ? AppConstants.chantsDevUrl : AppConstants.chantsProdUrl;
   }

  final Dio _dio = Dio(BaseOptions(
    connectTimeout: AppConstants.networkTimeout,
    receiveTimeout: AppConstants.networkTimeout,
  ));

  static const String _cacheFileName = AppConstants.chantsCacheFileName;

  
  Future<String> _getCacheFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$_cacheFileName';
  }

  Future<List<Chant>> loadChants() async {
    String? cachedJson;
    final cachePath = await _getCacheFilePath();
    final cacheFile = File(cachePath);

    // Try to read from cache first
    if (await cacheFile.exists()) {
      try {
        cachedJson = await cacheFile.readAsString();
        print('Loaded chants from cache');
      } catch (e) {
        print('Error reading cache: $e');
      }
    }

    // Always try to fetch fresh data with Dio
    try {
      final response = await _dio.get(remoteUrl);
      if (response.statusCode == 200) {
        final freshJson = response.data.toString(); // Dio gives dynamic, convert to string
        // Save to cache
        await cacheFile.writeAsString(freshJson);
        print('Fetched fresh chants with Dio and cached them');

        final List<dynamic> jsonList = json.decode(freshJson);
        return jsonList.map((json) => Chant.fromJson(json)).toList();
      }
    } on DioException catch (e) {
      print('Dio error fetching chants: ${e.message}');
      // Network error or timeout
      if (cachedJson != null) {
        print('Using cached chants due to network error');
        final List<dynamic> jsonList = json.decode(cachedJson);
        return jsonList.map((json) => Chant.fromJson(json)).toList();
      }
      rethrow;
    } catch (e) {
      print('Unexpected error: $e');
      if (cachedJson != null) {
        final List<dynamic> jsonList = json.decode(cachedJson);
        return jsonList.map((json) => Chant.fromJson(json)).toList();
      }
      rethrow;
    }

    // Safety fallback
    if (cachedJson != null) {
      final List<dynamic> jsonList = json.decode(cachedJson);
      return jsonList.map((json) => Chant.fromJson(json)).toList();
    }

    throw Exception('No chants available');
  }
}