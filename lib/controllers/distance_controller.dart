import 'dart:math';

class DistanceController {

  static double distanceBetween(
      double startLatitude,
      double startLongitude,
      double endLatitude,
      double endLongitude,
      ) {
    //print("INPUT: $startLatitude,$startLongitude  -  $endLatitude,$endLongitude");
    var earthRadius = 6378137.0;
    var dLat = _toRadians(endLatitude - startLatitude);
    var dLon = _toRadians(endLongitude - startLongitude);

    var a = pow(sin(dLat / 2), 2) +
        pow(sin(dLon / 2), 2) *
            cos(_toRadians(startLatitude)) *
            cos(_toRadians(endLatitude));
    var c = 2 * asin(sqrt(a));
    double distance = (earthRadius * c);
    print("DISTANCE CALCULATED: $distance");
    return distance;
  }

  static _toRadians(double degree) {
    return degree * pi / 180;
  }

}