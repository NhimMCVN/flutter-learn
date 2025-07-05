// Copyright 2024 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import '../../../utils/result.dart';
import 'user_repository.dart';

class UserRepositoryLocal implements UserRepository {
  UserRepositoryLocal({required dynamic localDataService})
    : _localDataService = localDataService;

  final dynamic _localDataService;

  @override
  Future<Result<dynamic>> getUser() async {
    return Result.ok(_localDataService.getUser());
  }
}
