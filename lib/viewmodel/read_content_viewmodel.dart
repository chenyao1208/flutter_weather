import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather/model/data/read_data.dart';
import 'package:flutter_weather/model/service/read_service.dart';
import 'package:flutter_weather/viewmodel/viewmodel.dart';

class ReadContentViewModel extends ViewModel {
  final data = StreamController<List<ReadItem>>();

  final _service = ReadService();

  ReadData _cacheData;
  String _type;

  void init({@required String type}) {
    _type = type;
    loadData(type: LoadType.NEW_LOAD);
  }

  Future<void> loadData({@required LoadType type}) async {
    if (selfLoading) return;
    selfLoading = true;

    if (type != LoadType.REFRESH) {
      isLoading.safeAdd(true);
    }

    try {
      final readData = await _service.getReadData(
          type: _type, page: (_cacheData?.page ?? 0) + 1);

      if (type == LoadType.REFRESH || type == LoadType.NEW_LOAD) {
        _cacheData = readData;
      } else {
        _cacheData?.page = readData.page;
        _cacheData?.data?.addAll(readData.data);
      }
      data.safeAdd(_cacheData?.data);
    } on DioError catch (e) {
      selfLoadType = type;
      doError(e);
    } finally {
      selfLoading = false;
      isLoading.safeAdd(false);
    }
  }

  void reload() {
    loadData(type: selfLoadType);
  }

  void loadMore() {
    loadData(type: LoadType.LOAD_MORE);
  }

  @override
  void dispose() {
    _service.dispose();

    data.close();

    super.dispose();
  }
}