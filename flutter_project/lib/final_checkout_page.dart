import 'package:flutter/material.dart';
import 'package:flutter_project/services/cart_service.dart';
import 'package:flutter_project/final_feedback_page.dart';

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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Checkout',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
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
                    color: _currentStep >= 1 ? Colors.black : Colors.grey[300],
                  ),
                ),
                _buildStepIndicator(1, 'Shipping', _currentStep >= 1),
                Expanded(
                  child: Container(
                    height: 2,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    color: _currentStep >= 2 ? Colors.black : Colors.grey[300],
                  ),
                ),
                _buildStepIndicator(2, 'Payment', _currentStep >= 2),
              ],
            ),
          ),
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
                        side: const BorderSide(color: Colors.black, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Back',
                        style: TextStyle(
                          color: Colors.black,
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
                      backgroundColor: Colors.black,
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
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int step, String label, bool isActive) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isActive ? Colors.black : Colors.grey[200],
            borderRadius: BorderRadius.circular(50),
          ),
          child: Center(
            child: Text(
              '${step + 1}',
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey[600],
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
            color: isActive ? Colors.black : Colors.grey[500],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderReviewStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Cart Items
          ...widget.cartItems.map((item) {
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
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
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.headphones,
                          size: 35,
                          color: Colors.grey[400],
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
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '\$${item.product.price.toStringAsFixed(2)} x ${item.quantity}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '\$${(item.product.price * item.quantity).toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 20),

          // Price Summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              children: [
                _buildPriceSummaryRow('Subtotal', widget.subtotal),
                const SizedBox(height: 10),
                _buildPriceSummaryRow('Shipping', widget.shipping),
                const SizedBox(height: 10),
                _buildPriceSummaryRow('Tax', widget.tax),
                const Divider(height: 20),
                _buildPriceSummaryRow('Total', widget.total, isTotal: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShippingStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Shipping Information',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          _buildTextField('Full Name', _fullNameController, 'John Doe'),
          const SizedBox(height: 16),
          _buildTextField('Email', _emailController, widget.userEmail,
              readOnly: true),
          const SizedBox(height: 16),
          _buildTextField('Phone Number', _phoneController, '+1 (555) 000-00'),
          const SizedBox(height: 16),
          _buildTextField(
              'Street Address', _addressController, '123 Main Street'),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildTextField('City', _cityController, 'New York'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField('ZIP Code', _zipController, '10001'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.info, color: Colors.blue[700], size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Please ensure your address is correct for timely delivery',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.blue[700],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment Method',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
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
                'Card Number', _cardNumberController, '1234 5678 9012 3456'),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                      'Expiry Date', _expiryController, 'MM/YY'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildTextField('CVV', _cvvController, '123'),
                ),
              ],
            ),
          ],

          const SizedBox(height: 20),

          // Order Summary Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              children: [
                _buildPriceSummaryRow('Subtotal', widget.subtotal),
                const SizedBox(height: 10),
                _buildPriceSummaryRow('Shipping', widget.shipping),
                const SizedBox(height: 10),
                _buildPriceSummaryRow('Tax', widget.tax),
                const Divider(height: 20),
                _buildPriceSummaryRow('Total', widget.total, isTotal: true),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Terms Agreement
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.green[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green[700], size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'I agree to the terms and conditions',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.green[700],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(String value, String label, IconData icon) {
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
            color: _selectedPaymentMethod == value
                ? Colors.black
                : Colors.grey[300]!,
            width: _selectedPaymentMethod == value ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: _selectedPaymentMethod == value
              ? Colors.black.withOpacity(0.05)
              : Colors.white,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 28,
              color: _selectedPaymentMethod == value
                  ? Colors.black
                  : Colors.grey[400],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: _selectedPaymentMethod == value
                      ? Colors.black
                      : Colors.grey[600],
                ),
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: _selectedPaymentMethod == value
                      ? Colors.black
                      : Colors.grey[300]!,
                  width: 2,
                ),
                color: _selectedPaymentMethod == value
                    ? Colors.black
                    : Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, String hint,
      {bool readOnly = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          readOnly: readOnly,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.black, width: 2),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            filled: readOnly,
            fillColor: readOnly ? Colors.grey[100] : Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceSummaryRow(String label, double amount,
      {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: Colors.black,
          ),
        ),
        Text(
          '\$${amount.toStringAsFixed(2)}',
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: isTotal ? Colors.green : Colors.black,
          ),
        ),
      ],
    );
  }
}
