/// Entity representing a cat breed image.
///
/// Contains image information including its identifier in The Cat API,
/// dimensions, and URL for download.
///
/// **Example:**
/// ```dart
/// final image = ImageEntity(
///   id: 'GhAqFaX2K',
///   width: 1080,
///   height: 720,
///   url: 'https://cdn2.thecatapi.com/images/GhAqFaX2K.jpg',
/// );
/// ```
class ImageEntity {
  /// Unique identifier of the image in The Cat API.
  final String id;

  /// Image width in pixels.
  final int width;

  /// Image height in pixels.
  final int height;

  /// Complete URL for downloading/displaying the image.
  final String url;

  /// Creates an instance of [ImageEntity].
  ///
  /// **Parameters:**
  /// - [id]: Image identifier in the API
  /// - [width]: Width in pixels
  /// - [height]: Height in pixels
  /// - [url]: Complete image URL
  ImageEntity({
    required this.id,
    required this.width,
    required this.height,
    required this.url,
  });

  /// Creates an instance of [ImageEntity] from JSON.
  ///
  /// Maps API JSON fields to corresponding properties.
  /// Missing values are replaced with safe defaults.
  ///
  /// **Parameters:**
  /// - [json]: Decoded object with 'id', 'width', 'height', 'url'
  ///
  /// **Returns:**
  /// Instance of [ImageEntity] with JSON data
  factory ImageEntity.fromJson(Map<String, dynamic> json) {
    return ImageEntity(
      id: json['id'] ?? '',
      width: json['width'] ?? 0,
      height: json['height'] ?? 0,
      url: json['url'] ?? '',
    );
  }

  /// Converts this instance to JSON.
  ///
  /// **Returns:**
  /// Serializable map with image information
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'width': width,
      'height': height,
      'url': url,
    };
  }
}
