import 'package:flutter/rendering.dart';

/// Corner-radius tokens matching the HTML mock.
class AppRadii {
  AppRadii._();

  static const double sm = 9;    // Splitly logo tile in the header
  static const double md = 12;   // expense tile initials avatar
  static const double lg = 14;   // form fields, payer chip
  static const double xl = 16;   // balance card, expense row card
  static const double xxl = 18;  // floating action button
  static const double splash = 26; // splash logo tile
  static const double pill = 999;  // save button, empty CTA, toast

  static const BorderRadius smAll = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius mdAll = BorderRadius.all(Radius.circular(md));
  static const BorderRadius lgAll = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius xlAll = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius xxlAll = BorderRadius.all(Radius.circular(xxl));
  static const BorderRadius splashAll =
      BorderRadius.all(Radius.circular(splash));
  static const BorderRadius pillAll = BorderRadius.all(Radius.circular(pill));
}
