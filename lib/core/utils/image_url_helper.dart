import 'package:ansor_market_mobile/core/constants/api_constants.dart';

class ImageUrlHelper {
  static String build(String imageKey) =>
      '${ApiConstants.cdnBaseUrl}/ansor-market/$imageKey';

  static String buildThumbnail(String imageKey) =>
      '${ApiConstants.cdnBaseUrl}/ansor-market/thumbnails/$imageKey';
}
