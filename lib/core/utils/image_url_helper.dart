import 'package:ansor_market_mobile/core/constants/api_constants.dart';

class ImageUrlHelper {
  static String build(String imageKey) =>
      '${ApiConstants.cdnBaseUrl}/$imageKey';

  static String buildThumbnail(String imageKey) =>
      '${ApiConstants.cdnBaseUrl}/thumbnails/$imageKey';
}
