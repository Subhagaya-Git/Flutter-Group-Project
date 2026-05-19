import 'package:flutter/material.dart';
import '../main.dart';

class CurrencyService {
  static String formatPrice(BuildContext context, double price) {
    final currencyCode = MyApp.of(context)?.currencyCode ?? 'USD';
    
    switch (currencyCode) {
      case 'LKR':
        // Assuming 1 USD = 300 LKR for demonstration if needed, 
        // but user only asked to switch symbol/code, usually prices are already in one base.
        // If they want actual conversion, they'd specify.
        // For now, let's just use the symbol.
        return 'LKR ${price.toStringAsFixed(2)}';
      case 'EUR':
        return '€${price.toStringAsFixed(2)}';
      case 'GBP':
        return '£${price.toStringAsFixed(2)}';
      case 'USD':
      default:
        return '\$${price.toStringAsFixed(2)}';
    }
  }

  static String getCurrencySymbol(BuildContext context) {
    final currencyCode = MyApp.of(context)?.currencyCode ?? 'USD';
    switch (currencyCode) {
      case 'LKR':
        return 'LKR ';
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      case 'USD':
      default:
        return '\$';
    }
  }
}
