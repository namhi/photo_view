import 'package:flutter/material.dart';
import 'package:photo_view/photo_view_scale_boundary.dart';
import 'package:photo_view/photo_view_utils.dart';

class ScaleBoundaries {
  final _minScale;
  final _maxScale;
  Size size;
  ImageInfo imageInfo;

  ScaleBoundaries(this._minScale, this._maxScale, { @required this.size, @required this.imageInfo}) :
        assert(_minScale is double || _minScale is PhotoViewScaleBoundary),
        assert(_maxScale is double || _maxScale is PhotoViewScaleBoundary),
        assert(computeMinScale() <= computeMaxScale());

  double computeMinScale(){
    if(_minScale == PhotoViewScaleBoundary.contained){
      return scaleForContained(
        size: size,
        imageInfo: imageInfo
      );
    }
    if(_minScale == PhotoViewScaleBoundary.covered){
      return scaleForCovering(
          size: size,
          imageInfo: imageInfo
      );
    }
    return _minScale;
  }

  double computeMaxScale(){
    if(_maxScale == PhotoViewScaleBoundary.contained){
      return scaleForContained(
          size: size,
          imageInfo: imageInfo
      );
    }
    if(_maxScale == PhotoViewScaleBoundary.covered){
      return scaleForCovering(
          size: size,
          imageInfo: imageInfo
      );
    }
    return _maxScale;
  }

}