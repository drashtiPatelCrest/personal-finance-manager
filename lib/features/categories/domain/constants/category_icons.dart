import 'package:flutter/material.dart';

/// Predefined category icons mapped to stable string codes.
abstract final class CategoryIcons {
  static const Map<String, IconData> icons = {
    'category': Icons.category_outlined,
    'shopping_cart': Icons.shopping_cart_outlined,
    'restaurant': Icons.restaurant_outlined,
    'directions_car': Icons.directions_car_outlined,
    'home': Icons.home_outlined,
    'work': Icons.work_outline,
    'school': Icons.school_outlined,
    'medical': Icons.medical_services_outlined,
    'fitness': Icons.fitness_center_outlined,
    'flight': Icons.flight_outlined,
    'gift': Icons.card_giftcard_outlined,
    'pets': Icons.pets_outlined,
    'savings': Icons.savings_outlined,
    'payments': Icons.payments_outlined,
    'trending_up': Icons.trending_up,
    'account_balance': Icons.account_balance_outlined,
    'attach_money': Icons.attach_money,
    'local_cafe': Icons.local_cafe_outlined,
    'movie': Icons.movie_outlined,
    'phone': Icons.phone_android_outlined,
  };

  static IconData resolve(String iconCode) {
    return icons[iconCode] ?? Icons.category_outlined;
  }

  static String get defaultIconCode => 'category';
}
