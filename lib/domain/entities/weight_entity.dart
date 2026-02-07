/// Entity representing the weight range of a cat breed.
///
/// Stores typical weight in two unit systems:
/// - **Imperial:** Pounds (lbs)
/// - **Metric:** Kilograms (kg)
///
/// **Example:**
/// ```dart
/// final weight = WeightEntity(
///   imperial: '6 - 10',  // lbs
///   metric: '3 - 5',     // kg
/// );
/// ```
class WeightEntity {
  /// Weight range in pounds (e.g., "6 - 10").
  final String imperial;

  /// Weight range in kilograms (e.g., "3 - 5").
  final String metric;

  /// Creates an instance of [WeightEntity].
  ///
  /// **Parameters:**
  /// - [imperial]: Weight range in pounds
  /// - [metric]: Weight range in kilograms
  WeightEntity({required this.imperial, required this.metric});

  /// Creates an instance of [WeightEntity] from JSON.
  ///
  /// Maps 'imperial' and 'metric' from JSON to corresponding properties.
  ///
  /// **Parameters:**
  /// - [json]: Decoded object with 'imperial' and 'metric'
  ///
  /// **Returns:**
  /// Instance of [WeightEntity] with JSON values
  factory WeightEntity.fromJson(Map<String, dynamic> json) {
    return WeightEntity(
      imperial: json['imperial'] ?? '',
      metric: json['metric'] ?? '',
    );
  }

  /// Converts this instance to JSON.
  ///
  /// **Returns:**
  /// Map with 'imperial' and 'metric' as keys
  Map<String, dynamic> toJson() {
    return {
      'imperial': imperial,
      'metric': metric,
    };
  }
}
