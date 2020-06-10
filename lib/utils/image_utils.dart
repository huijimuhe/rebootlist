
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rebootlist/utils/text_utils.dart';

class ImageUtils {

  static String getIconPath(String name, {String format: 'png'}) {
    return 'assets/icons/$name.$format';
  }
  static String getImagePath(String name, {String format: 'png'}) {
    return 'assets/images/$name.$format';
  }
  static ImageProvider getImageProvider(String imageUrl, {String holderImg: "none"}){
    if (TextUtils.isEmpty(imageUrl)){
      return AssetImage(getIconPath(holderImg));
    }
  }
}

