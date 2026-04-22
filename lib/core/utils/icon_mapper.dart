import 'package:flutter/material.dart';

/// ─────────────────────────────────────────────────────────────────────────────
/// IconMapper — Centralized mapping for Material Icons.
///
/// Flutter's icon tree shaker requires constant IconData instances to subset
/// the font. This class provides a way to map dynamic code points stored in
/// the database back to their constant definitions.
/// ─────────────────────────────────────────────────────────────────────────────
class IconMapper {
  IconMapper._();

  static IconData getIcon(int? code) {
    if (code == null) return Icons.category;

    switch (code) {
      // ── Default Budget Icons ────────────────────────────────────────────────
      case 0xe041: return Icons.account_balance_wallet;
      case 0xe59c: return Icons.shopping_bag;
      case 0xe318: return Icons.home;
      case 0xe28f: return Icons.flight;
      case 0xe51c: return Icons.restaurant;
      case 0xe1d1: return Icons.directions_car;
      case 0xe25b: return Icons.favorite;
      case 0xe54d: return Icons.school;

      // ── Common Category Icons ───────────────────────────────────────────────
      case 0xe395: return Icons.local_grocery_store;
      case 0xe396: return Icons.local_gas_station;
      case 0xe3ab: return Icons.medical_services;
      case 0xe664: return Icons.coffee;
      case 0xef63: return Icons.payments;
      case 0xe8f9: return Icons.work;
      case 0xe8b1: return Icons.redeem;
      case 0xe869: return Icons.build;
      case 0xe40f: return Icons.movie;
      case 0xe20b: return Icons.electric_bolt;
      case 0xe894: return Icons.language;
      case 0xf5f0: return Icons.checkroom;
      case 0xe52f: return Icons.fastfood;
      case 0xe566: return Icons.directions_bus;
      case 0xe028: return Icons.celebration;
      case 0xe332: return Icons.laptop_mac;
      case 0xe307: return Icons.fitness_center;
      case 0xe85a: return Icons.account_balance;
      case 0xe32a: return Icons.pets;
      case 0xe529: return Icons.child_care;

      // ── Fallback ────────────────────────────────────────────────────────────
      default:
        // ── Scalable Fallback ──────────────────────────────────────────────────
        // If the code is not in our explicit switch (for tree-shaking safety),
        // we return the IconData directly. Since our categories are seeded from
        // Utils.dart which references these icons as constants, the character
        // glyphs will be preserved in the font bundle even with tree-shaking enabled.
        return IconData(code, fontFamily: 'MaterialIcons');
    }
  }
}
