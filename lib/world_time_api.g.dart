// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'world_time_api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimeAtLocation _$TimeAtLocationFromJson(Map<String, dynamic> json) =>
    TimeAtLocation(
      timeOffset: json['utc_offset'] as String,
      timestamp: json['datetime'] as String,
    );

Map<String, dynamic> _$TimeAtLocationToJson(TimeAtLocation instance) =>
    <String, dynamic>{
      'utc_offset': instance.timeOffset,
      'datetime': instance.timestamp,
    };

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers

class _WorldTimeApi implements WorldTimeApi {
  _WorldTimeApi(
    this._dio, {
    this.baseUrl,
  }) {
    baseUrl ??= 'https://worldtimeapi.org/api/timezone';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<TimeAtLocation> getTimeAtLocation(
    String continent,
    String city,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final Map<String, dynamic>? _data = null;
    final _result = await _dio
        .fetch<Map<String, dynamic>>(_setStreamType<TimeAtLocation>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '/${continent}/${city}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = TimeAtLocation.fromJson(_result.data!);
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(
    String dioBaseUrl,
    String? baseUrl,
  ) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}
