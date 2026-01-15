import 'package:flutter_riverpod/flutter_riverpod.dart';

// State class to hold latitude and longitude as strings (or null)
class LocationState {
  final String? lat;
  final String? long;

  LocationState({this.lat, this.long});

  // CopyWith method for immutable updates
  LocationState copyWith({String? lat, String? long}) {
    return LocationState(
      lat: lat ?? this.lat,
      long: long ?? this.long,
    );
  }
}

// StateNotifier to manage location state
class LocationNotifier extends StateNotifier<LocationState> {
  LocationNotifier() : super(LocationState()); // Initial state with null values

  // Update latitude and longitude
  void updateLocation({String? lat, String? long}) {
    state = state.copyWith(lat: lat, long: long);
  }

  // Clear location
  void clearLocation() {
    state = LocationState();
  }
}

// StateNotifierProvider to provide the notifier
final locationNotifer = StateNotifierProvider<LocationNotifier, LocationState>(
  (ref) => LocationNotifier(),
);