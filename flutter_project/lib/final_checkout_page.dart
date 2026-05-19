import 'package:flutter/material.dart';
import 'package:flutter_project/services/cart_service.dart';
import 'package:flutter_project/final_feedback_page.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_project/services/currency_service.dart';

class FinalCheckoutPage extends StatefulWidget {
  final String userEmail;
  final List<CartItem> cartItems;
  final double subtotal;
  final double shipping;
  final double tax;
  final double total;

  const FinalCheckoutPage({
    super.key,
    required this.userEmail,
    required this.cartItems,
    required this.subtotal,
    required this.shipping,
    required this.tax,
    required this.total,
  });

  @override
  State<FinalCheckoutPage> createState() => _FinalCheckoutPageState();
}

class _FinalCheckoutPageState extends State<FinalCheckoutPage> {
  late PageController _pageController;
  int _currentStep = 0;

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();
  final TextEditingController _cardHolderController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  String _selectedPaymentMethod = 'card';

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _emailController.text = widget.userEmail;
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _zipController.dispose();
    _cardHolderController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  bool _validateShippingForm() {
    if (_fullNameController.text.trim().isEmpty) {
      _showValidationError('Full Name is required');
      return false;
    }
    if (_fullNameController.text.trim().length < 3) {
      _showValidationError('Full Name must be at least 3 characters');
      return false;
    }
    if (_phoneController.text.trim().isEmpty) {
      _showValidationError('Phone Number is required');
      return false;
    }
    if (_phoneController.text.trim().length < 10) {
      _showValidationError('Phone Number must be at least 10 digits');
      return false;
    }
    if (_addressController.text.trim().isEmpty) {
      _showValidationError('Street Address is required');
      return false;
    }
    if (_addressController.text.trim().length < 5) {
      _showValidationError('Street Address must be at least 5 characters');
      return false;
    }
    if (_cityController.text.trim().isEmpty) {
      _showValidationError('City is required');
      return false;
    }
    if (_cityController.text.trim().length < 2) {
      _showValidationError('City must be at least 2 characters');
      return false;
    }
    if (_zipController.text.trim().isEmpty) {
      _showValidationError('ZIP Code is required');
      return false;
    }
    if (_zipController.text.trim().length < 5) {
      _showValidationError('ZIP Code must be at least 5 characters');
      return false;
    }
    return true;
  }

  bool _validatePaymentForm() {
    if (_selectedPaymentMethod == 'card') {
      if (_cardHolderController.text.trim().isEmpty) {
        _showValidationError('Card Holder Name is required');
        return false;
      }
      if (_cardHolderController.text.trim().length < 3) {
        _showValidationError('Card Holder Name must be at least 3 characters');
        return false;
      }
      if (_cardNumberController.text.trim().isEmpty) {
        _showValidationError('Card Number is required');
        return false;
      }
      if (_cardNumberController.text.trim().replaceAll(' ', '').length != 16) {
        _showValidationError('Card Number must be 16 digits');
        return false;
      }
      if (_expiryController.text.trim().isEmpty) {
        _showValidationError('Expiry Date is required');
        return false;
      }
      if (!_expiryController.text.contains('/')) {
        _showValidationError('Expiry Date format must be MM/YY');
        return false;
      }
      if (_cvvController.text.trim().isEmpty) {
        _showValidationError('CVV is required');
        return false;
      }
      if (_cvvController.text.trim().length != 3) {
        _showValidationError('CVV must be 3 digits');
        return false;
      }
    }
    return true;
  }

  void _showValidationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _nextStep() {
    if (_currentStep == 1) {
      if (!_validateShippingForm()) {
        return;
      }
    }
    if (_currentStep < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _completeOrder() {
    if (!_validatePaymentForm()) {
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FinalFeedbackPage(
          userEmail: widget.userEmail,
          fullName: _fullNameController.text.trim(),
          address: _addressController.text.trim(),
          city: _cityController.text.trim(),
          zipCode: _zipController.text.trim(),
          paymentMethod: _selectedPaymentMethod,
          total: widget.total,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Checkout'),
      ),
      body: Column(
        children: [
          // Step Indicator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                _buildStepIndicator(0, 'Cart', _currentStep >= 0),
                Expanded(
                  child: Container(
                    height: 2,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    color: _currentStep >= 1 ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.1),
                  ),
                ),
                _buildStepIndicator(1, 'Shipping', _currentStep >= 1),
                Expanded(
                  child: Container(
                    height: 2,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    color: _currentStep >= 2 ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.1),
                  ),
                ),
                _buildStepIndicator(2, 'Payment', _currentStep >= 2),
              ],
            ),
          ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.2),
          const Divider(height: 1),

          // Page Content
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                setState(() {
                  _currentStep = index;
                });
              },
              children: [
                // Step 1: Order Review
                _buildOrderReviewStep(),

                // Step 2: Shipping Information
                _buildShippingStep(),

                // Step 3: Payment Information
                _buildPaymentStep(),
              ],
            ),
          ),

          // Action Buttons
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _previousStep,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: colorScheme.onSurface, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Back',
                        style: TextStyle(
                          color: colorScheme.onSurface,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                if (_currentStep > 0) const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _currentStep < 2 ? _nextStep : _completeOrder,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      _currentStep < 2 ? 'Next' : 'Place Order',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int step, String label, bool isActive) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isActive ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.05),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Center(
            child: Text(
              '${step + 1}',
              style: TextStyle(
                color: isActive ? colorScheme.onPrimary : colorScheme.onSurface.withOpacity(0.3),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isActive ? colorScheme.onSurface : colorScheme.onSurface.withOpacity(0.3),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderReviewStep() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),

          // Cart Items
          ...widget.cartItems.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              color: colorScheme.surface,
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: colorScheme.background,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.shopping_bag,
                          size: 35,
                          color: colorScheme.onSurface.withOpacity(0.2),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.product.name,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onSurface,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${CurrencyService.formatPrice(context, item.product.price)} x ${item.quantity}',
                            style: TextStyle(
                              fontSize: 12,
                              color: colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      CurrencyService.formatPrice(context, item.product.price * item.quantity),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(delay: (index * 50).ms).slideX(begin: 0.1);
          }),

          const SizedBox(height: 20),

          // Price Summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colorScheme.onSurface.withOpacity(0.1)),
            ),
            child: Column(
              children: [
                _buildPriceSummaryRow('Subtotal', widget.subtotal),
                const SizedBox(height: 10),
                _buildPriceSummaryRow('Shipping', widget.shipping),
                const SizedBox(height: 10),
                _buildPriceSummaryRow('Tax', widget.tax),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Divider(color: colorScheme.onSurface.withOpacity(0.1)),
                ),
                _buildPriceSummaryRow('Total', widget.total, isTotal: true),
              ],
            ),
          ).animate().fadeIn(delay: 300.ms),
        ],
      ),
    );
  }

  Widget _buildShippingStep() {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Shipping Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 20),
          _buildTextField('Full Name', _fullNameController, 'Enter your name'),
          const SizedBox(height: 16),
          _buildTextField('Email', _emailController, widget.userEmail,
              readOnly: true),
          const SizedBox(height: 16),
          _buildTextField('Phone Number', _phoneController, '07X XXX XXXX'),
          const SizedBox(height: 16),
          _buildTextField(
              'Street Address', _addressController, 'Enter street address'),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTextField('City', _cityController, 'City'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField('ZIP Code', _zipController, 'ZIP'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.blue.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info, color: Colors.blue, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Please ensure your address is correct for timely delivery',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.blue.withOpacity(0.8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildPaymentStep() {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Method',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 20),

          // Credit Card Option
          _buildPaymentOption(
            'card',
            'Credit/Debit Card',
            Icons.credit_card,
          ),
          const SizedBox(height: 12),

          // Digital Wallet Option
          _buildPaymentOption(
            'wallet',
            'Digital Wallet',
            Icons.account_balance_wallet,
          ),
          const SizedBox(height: 12),

          // Bank Transfer Option
          _buildPaymentOption(
            'bank',
            'Bank Transfer',
            Icons.account_balance,
          ),

          const SizedBox(height: 20),

          if (_selectedPaymentMethod == 'card') ...[
            _buildTextField(
                'Card Holder Name', _cardHolderController, 'John Doe'),
            const SizedBox(height: 16),
            _buildTextField(
                'Card Number', _cardNumberController, 'XXXX XXXX XXXX XXXX'),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                      'Expiry Date', _expiryController, 'MM/YY'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField('CVV', _cvvController, 'XXX'),
                ),
              ],
            ),
          ],

          const SizedBox(height: 20),

          // Order Summary Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colorScheme.onSurface.withOpacity(0.1)),
            ),
            child: Column(
              children: [
                _buildPriceSummaryRow('Subtotal', widget.subtotal),
                const SizedBox(height: 10),
                _buildPriceSummaryRow('Shipping', widget.shipping),
                const SizedBox(height: 10),
                _buildPriceSummaryRow('Tax', widget.tax),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Divider(color: colorScheme.onSurface.withOpacity(0.1)),
                ),
                _buildPriceSummaryRow('Total', widget.total, isTotal: true),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Terms Agreement
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.green.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'I agree to the terms and conditions',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.green.withOpacity(0.8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms);
  }

  Widget _buildPaymentOption(String value, String label, IconData icon) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = _selectedPaymentMethod == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.1),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? colorScheme.primary.withOpacity(0.05) : colorScheme.surface,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 28,
              color: isSelected ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? colorScheme.onSurface : colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? colorScheme.primary : colorScheme.onSurface.withOpacity(0.1),
                  width: 2,
                ),
                color: isSelected ? colorScheme.primary : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 12, color: Colors.white)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, String hint,
      {bool readOnly = false}) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: readOnly,
          style: TextStyle(color: colorScheme.onSurface),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.3)),
            filled: true,
            fillColor: readOnly ? colorScheme.onSurface.withOpacity(0.05) : colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: colorScheme.onSurface.withOpacity(0.1)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: colorScheme.onSurface.withOpacity(0.1)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: colorScheme.primary, width: 2),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceSummaryRow(String label, double amount,
      {bool isTotal = false}) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: colorScheme.onSurface,
          ),
        ),
        Text(
          CurrencyService.formatPrice(context, amount),
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: isTotal ? colorScheme.primary : colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
