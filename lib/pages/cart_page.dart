import 'package:flutter/material.dart';
import 'package:genzee_wears/models/product_model.dart';
import 'package:genzee_wears/services/auth_service.dart';
import 'package:genzee_wears/services/cart_service.dart';
import 'package:genzee_wears/pages/checkout_page.dart';

const Color kBg     = Color(0xFF0A0A0B);
const Color kCard   = Color(0xFF1C1C1E);
const Color kCard2  = Color(0xFF232325);
const Color kBorder = Color(0xFF2A2A2D);
const Color kPurple = Color(0xFF7C53FB);
const Color kMuted  = Color(0xFF353537);
const Color kMuted2 = Color(0xFF4A4A4E);
const Color kText   = Color(0xFFF0F0F2);
const Color kSub    = Color(0xFF9A9AA0);
const Color kGreen  = Color(0xFF3ECF6A);
const Color kGold   = Color(0xFFF5C542);

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Map<String, dynamic>> _cartItems = [];
  bool isLoading = true;
  bool _couponApplied = false;
  double _discountPct = 0.0;
  final TextEditingController _couponCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCartItems();
  }

  Future<void> _loadCartItems() async {
    try {
      final userId = AuthService.instance.currentUser?.id ?? 0;
      if (userId == 0) {
        if (!mounted) return;
        setState(() {
          isLoading = false;
        });
        return;
      }
      
      final items = await CartService.instance.getCartItemsWithProducts(userId);
      if (!mounted) return;
      setState(() {
        _cartItems = items;
        isLoading = false;
      });
    } catch (e) {
      print('Error loading cart: $e');
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      _snack('Error loading cart items');
    }
  }

  Future<void> _updateQuantity(int productId, int newQuantity) async {
    final userId = AuthService.instance.currentUser?.id ?? 0;
    if (userId == 0) return;
    
    await CartService.instance.updateQuantity(userId, productId, newQuantity);
    await _loadCartItems();
  }

  Future<void> _removeItem(int productId) async {
    final userId = AuthService.instance.currentUser?.id ?? 0;
    if (userId == 0) return;
    
    await CartService.instance.removeFromCart(userId, productId);
    await _loadCartItems();
  }

  double get _subtotal {
    double total = 0;
    for (final item in _cartItems) {
      final product = item['product'] as Product;
      final quantity = item['quantity'] as int;
      total += product.price * quantity;
    }
    return total;
  }

  double get _discount => _couponApplied ? _subtotal * _discountPct : 0.0;
  double get _vat => _subtotal * 0.13;
  double get _total    => _subtotal - _discount + _vat + 0.50;

  void _applyCoupon() {
    final code = _couponCtrl.text.trim().toUpperCase();
    if (code.isEmpty) { _snack('Enter a coupon code first'); return; }
    if (code == 'DARK20') {
      setState(() { _couponApplied = true; _discountPct = 0.20; });
      _snack('🎉 20% discount applied!', ok: true);
    } else if (code == 'SAVE10') {
      setState(() { _couponApplied = true; _discountPct = 0.10; });
      _snack('🎉 10% discount applied!', ok: true);
    } else {
      _snack('Invalid coupon code');
    }
  }

  void _snack(String msg, {bool ok = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: const TextStyle(fontWeight: FontWeight.w600)),
      backgroundColor: ok ? kGreen : kCard2,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: _buildAppBar(),
      body: isLoading 
          ? const Center(child: CircularProgressIndicator(color: kPurple))
          : _cartItems.isEmpty ? _buildEmptyState() : _buildList(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: kBg,
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: kBorder),
      ),
      title: Container(
        margin: EdgeInsets.only(left: 10),
        child: const Text(
          'My Cart',
          style: TextStyle(color: kText, fontSize: 20,
              fontWeight: FontWeight.w700, letterSpacing: -0.3),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
              color: kPurple, borderRadius: BorderRadius.circular(20)),
          child: Text(
            '${_cartItems.length} ${_cartItems.length==1?'item':'items'}',
            style: const TextStyle(color: Colors.white,
                fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          width: 90, height: 90,
          decoration: BoxDecoration(
            color: kCard, shape: BoxShape.circle,
            border: Border.all(color: kBorder),
          ),
          child: const Center(child: Text('🛒', style: TextStyle(fontSize: 40))),
        ),
        const SizedBox(height: 20),
        const Text('Your cart is empty',
            style: TextStyle(color: kText, fontSize: 18, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        const Text('Add items from the product page',
            style: TextStyle(color: kSub, fontSize: 14)),
      ]),
    );
  }

  Widget _buildList() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        ..._cartItems.map((item) => _buildItemCard(item)),
        const SizedBox(height: 4),
        _buildCouponRow(),
        const SizedBox(height: 8),
        _buildSummaryBox(),
        const SizedBox(height: 20),
        _buildBottomBar(),
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildItemCard(Map<String, dynamic> item) {
    final product = item['product'] as Product;
    final quantity = item['quantity'] as int;
    final bool isAsset = product.image.contains('/') || product.image.contains('.');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: kBorder),
      ),
      child: Row(children: [
        Container(
          width: 68, height: 68,
          decoration: BoxDecoration(
              color: kMuted, borderRadius: BorderRadius.circular(14)),
          clipBehavior: Clip.antiAlias,
          child: isAsset
              ? Image.asset(product.image, fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
              const Center(child: Text('🛍', style: TextStyle(fontSize: 28))))
              : Center(child: Text(product.image,
              style: const TextStyle(fontSize: 30))),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(product.name,
                style: const TextStyle(color: kText, fontSize: 15,
                    fontWeight: FontWeight.w700),
                overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Row(children: [
              const Icon(Icons.star, color: kGold, size: 13),
              const SizedBox(width: 3),
              Text('${product.rating}',
                  style: const TextStyle(color: kGold, fontSize: 12,
                      fontWeight: FontWeight.w600)),
            ]),
            const SizedBox(height: 4),
            Text(
              '\$${(product.price * quantity).toStringAsFixed(2)}',
              style: const TextStyle(color: kText, fontSize: 15,
                  fontWeight: FontWeight.w700),
            ),
          ]),
        ),
        const SizedBox(width: 12),
        _buildQtyCtrl(product.id, quantity),
      ]),
    );
  }

  Widget _buildQtyCtrl(int productId, int currentQty) {
    return Column(children: [
      GestureDetector(
        onTap: () => _updateQuantity(productId, currentQty + 1),
        child: Container(
          width: 28, height: 28,
          decoration: const BoxDecoration(color: kPurple, shape: BoxShape.circle),
          child: const Icon(Icons.add, color: Colors.white, size: 16),
        ),
      ),
      const SizedBox(height: 8),
      Text('$currentQty',
          style: const TextStyle(color: kText, fontSize: 15,
              fontWeight: FontWeight.w700)),
      const SizedBox(height: 8),
      GestureDetector(
        onTap: () {
          if (currentQty > 1) {
            _updateQuantity(productId, currentQty - 1);
          } else {
            _removeItem(productId);
          }
        },
        child: Container(
          width: 28, height: 28,
          decoration: BoxDecoration(
            color: kCard2, shape: BoxShape.circle,
            border: Border.all(color: kBorder),
          ),
          child: const Icon(Icons.remove, color: kSub, size: 16),
        ),
      ),
    ]);
  }

  Widget _buildCouponRow() {
    return Row(children: [
      Expanded(
        child: TextField(
          controller: _couponCtrl,
          style: const TextStyle(color: kText, fontSize: 14),
          decoration: InputDecoration(
            hintText: '🏷  Enter Coupon Code',
            hintStyle: const TextStyle(color: kMuted2, fontSize: 14),
            filled: true,
            fillColor: kCard,
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: kBorder)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: kBorder)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: kPurple)),
          ),
        ),
      ),
      const SizedBox(width: 10),
      GestureDetector(
        onTap: _applyCoupon,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
              color: kPurple, borderRadius: BorderRadius.circular(10)),
          child: const Text('Apply',
              style: TextStyle(color: Colors.white, fontSize: 14,
                  fontWeight: FontWeight.w700)),
        ),
      ),
    ]);
  }

  Widget _buildSummaryBox() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: kBorder),
      ),
      child: Column(children: [
        _sRow('Total Items', _cartItems.length.toString().padLeft(2, '0')),
        _sRow('Subtotal', '\$${_subtotal.toStringAsFixed(2)}'),
        if (_couponApplied)
          _sRow('Coupon Discount', '-\$${_discount.toStringAsFixed(2)}',
              vc: kGreen),
        _sRow('VAT (13%)', '\$${_vat.toStringAsFixed(2)}'),
        _sRow('Shipping Fee', '\$00.50'),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Divider(color: kBorder, height: 1),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('Total Payable',
              style: TextStyle(color: kText, fontSize: 17,
                  fontWeight: FontWeight.w700)),
          Text('\$${_total.toStringAsFixed(2)}',
              style: const TextStyle(color: kPurple, fontSize: 17,
                  fontWeight: FontWeight.w700)),
        ]),
      ]),
    );
  }

  Widget _sRow(String label, String val, {Color vc = kText}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: const TextStyle(color: kSub, fontSize: 14)),
        Text(val, style: TextStyle(
            color: vc, fontSize: 14, fontWeight: FontWeight.w500)),
      ]),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: kBg,
        border: Border(top: BorderSide(color: kBorder)),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: kPurple,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)),
          elevation: 8,
          shadowColor: kPurple.withOpacity(0.45),
        ),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (_) => CheckoutPage(
              items: _cartItems,
              subtotal: _subtotal,
              discount: _discount,
              vat: _vat,
              total: _total,
              couponApplied: _couponApplied,
            ),
          ));
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Proceed to Checkout',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward, size: 18),
          ],
        ),
      ),
    );
  }
}