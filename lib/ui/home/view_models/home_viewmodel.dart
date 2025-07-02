import 'package:first_flutter_app/data/repositories/booking/booking_repository.dart';
import 'package:first_flutter_app/data/repositories/user/user_repository.dart';
import 'package:first_flutter_app/domain/models/booking/booking_summary.dart';
import 'package:first_flutter_app/domain/models/user/user.dart';
import 'package:first_flutter_app/utils/command.dart';
import 'package:first_flutter_app/utils/result.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

class HomeviewModel extends ChangeNotifier {
  User? _user;
  List<BookingSummary> _bookings = [];

  User? get user => _user;
  List<BookingSummary> get bookings => _bookings;

  final BookingRepository _bookingRepository;
  final UserRepository _userRepository;
  final _log = Logger("HomeViewModel");

  HomeviewModel({
    required BookingRepository bookingRepository,
    required UserRepository userRepository,
  }) : _userRepository = userRepository,
       _bookingRepository = bookingRepository {
    load = Command0(_load)..execute();
    deleteBooking = Command1(_deleteBooking);
  }

  late Command0 load;
  late Command1<void, int> deleteBooking;

  Future<Result> _load() async {
    try {
      final result = await _bookingRepository.getBookingsList();
      switch (result) {
        case Ok<List<BookingSummary>>():
          _bookings = result.value;
          _log.fine("Loaded Booking");
        case Error<List<BookingSummary>>():
          _log.warning("Failed to load bookings", result.error);
      }

      final userResult = await _userRepository.getUser();
      switch (userResult) {
        case Ok<User>():
          _user = userResult.value;
          _log.fine("loaded user");
        case Error<User>():
          _log.warning("Failed to load user", userResult.error);
      }
      return userResult;
    } finally {
      notifyListeners();
    }
  }

  Future<Result<void>> _deleteBooking(int id) async {
    try {
      final resultDelete = await _bookingRepository.delete(id);
      switch (resultDelete) {
        case Ok<void>():
          _log.fine("Deleted booking $id");
        case Error<void>():
          _log.warning("Failed to delete booking $id", resultDelete.error);
          return resultDelete;
      }

      final result = await _bookingRepository.getBookingsList();
      switch (result) {
        case Ok<List<BookingSummary>>():
          _bookings = result.value;
          _log.fine("Loaded Booking");
        case Error<List<BookingSummary>>():
          _log.warning("Failed to load bookings", result.error);
      }
      return result;
    } finally {
      notifyListeners();
    }
  }
}
