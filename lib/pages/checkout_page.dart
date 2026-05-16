import 'package:flutter/material.dart';
import 'package:genzee_wears/pages/cart_page.dart';
import 'package:genzee_wears/services/auth_service.dart';

class CheckoutPage extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final double subtotal;
  final double discount;
  final double vat;
  final double total;
  final bool couponApplied;

  const CheckoutPage({
    super.key,
    required this.items,
    required this.subtotal,
    required this.discount,
    required this.vat,
    required this.total,
    required this.couponApplied,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  int _selectedAddressIndex = 0;

  final List<Map<String, String>> _addresses = [
    {
      'type': 'Home',
      'emoji': '🏠',
      'address': 'Dui Pokhari, Madhyapur Thimi, Bhaktapur',
      'person': 'Salonee Shrestha · 9748012345',
    },
    {
      'type': 'Office',
      'emoji': '🏢',
      'address': 'Swastik College, Chardobato, Bhaktapur',
      'person': 'Salonee Shrestha · 9748012345',
    },
    {
      'type': 'Others',
      'emoji': '📌',
      'address': 'Global College, Mid-Baneshwor, Kathmandu',
      'person': 'Salonee Shrestha · 9748012345',
    },
  ];

  bool _orderPlaced = false;
  void _showSnackbar(String message, {bool isSuccess = false}) {
    final overlay = Overlay.of(context);
    if (overlay == null) return;
    final overlayEntry = OverlayEntry(
      builder: (ctx) => Positioned(
        bottom: 60 + MediaQuery.of(ctx).viewInsets.bottom,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSuccess ? kGreen : kCard2,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10)],
            ),
            child: Text(message, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white)),
          ),
        ),
      ),
    );
    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 2), () { overlayEntry.remove(); });
  }

  void _openAddressPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: kCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) {
        return SingleChildScrollView(
          child: StatefulBuilder(
            builder: (context, setSheetState) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Delivery Address',
                          style: TextStyle(
                            color: kText,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.close, color: kSub),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 14),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: kCard2,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: kBorder),
                      ),
                      child: GestureDetector(
                        onTap: () => _showSnackbar('Search location coming soon!'),
                        child: Row(
                          children: const [
                            Icon(Icons.search, color: kSub, size: 18),
                            SizedBox(width: 10),
                            Text('Search for location', style: TextStyle(color: kMuted2, fontSize: 14)),
                          ],
                        ),
                      ),
                    ),
                    const Text(
                      'SAVED ADDRESSES',
                      style: TextStyle(
                        color: kSub, fontSize: 11,
                        fontWeight: FontWeight.w700, letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ..._addresses.asMap().entries.map((entry) {
                      final index = entry.key;
                      final addr  = entry.value;
                      final isSelected = index == _selectedAddressIndex;
          
                      return GestureDetector(
                        onTap: () {
                          setSheetState(() => _selectedAddressIndex = index);
                          setState(() => _selectedAddressIndex = index);
                        },
                        child: _buildAddressCard(addr, isSelected),
                      );
                    }),
                    GestureDetector(
                      onTap: () => _showSnackbar('Add new address coming soon!'),
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: kBorder,
                            width: 2,
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            '+ Add New Address',
                            style: TextStyle(
                              color: kPurple,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
          
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPurple,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 6,
                          shadowColor: kPurple.withOpacity(0.4),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          _showSnackbar('Address saved ✓', isSuccess: true);
                        },
                        child: const Text(
                          'Apply  ✓',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_orderPlaced) return _buildSuccessScreen();

    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: kBg,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: kBorder),
        ),
        leading: _buildBackButton(),
        title: const Text(
          'Checkout',
          style: TextStyle(
            color: kText,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
        ),
      ),

      body: Column(
        children: [
          _buildStepIndicator(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _sectionLabel('Delivery Address'),
                Builder(builder: (ctx) {
                  final addr = _addresses[_selectedAddressIndex];
                  final currentUser = AuthService.instance.currentUser;
                  final rawPerson = addr['person']!;
                  final parts = rawPerson.split('·');
                  final phone = parts.length > 1 ? parts.sublist(1).join('·').trim() : '';
                  final defaultName = parts[0].trim();
                  final displayName = currentUser != null ? currentUser.name : defaultName;
                  final displayPerson = phone.isNotEmpty ? '$displayName · $phone' : displayName;

                  return _buildInfoBlock(
                    icon: '📍',
                    label: 'Delivering to',
                    value: '${addr['emoji']} ${addr['address']}\n$displayPerson',
                    onTap: _openAddressPicker,
                  );
                }),
                const SizedBox(height: 16),

                _sectionLabel('Payment Method'),
                _buildInfoBlock(
                  icon: '💳',
                  label: 'Credit Card',
                  value: '•••• •••• •••• 5978',
                  onTap: () => _showSnackbar('Payment methods coming soon!'),
                ),
                const SizedBox(height: 16),
                _sectionLabel('Item List'),
                _buildItemList(),
                const SizedBox(height: 12),
                _buildSummaryBox(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildPlaceOrderBar(),
    );
  }

  Widget _buildBackButton() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          width: 38, height: 38,
          decoration: BoxDecoration(
            color: kCard,
            shape: BoxShape.circle,
            border: Border.all(color: kBorder),
          ),
          child: const Icon(Icons.arrow_back_ios_new, color: kText, size: 14),
        ),
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          _stepDot(label: 'Cart', number: '✓', isDone: true),
          _stepLine(isDone: true),
          _stepDot(label: 'Checkout', number: '2', isActive: true),
          _stepLine(isDone: false),
          _stepDot(label: 'Done', number: '3'),
        ],
      ),
    );
  }

  Widget _stepDot({
    required String label,
    required String number,
    bool isDone = false,
    bool isActive = false,
  }) {
    Color dotColor  = isDone ? kGreen : isActive ? kPurple : kMuted;
    Color textColor = isDone ? kGreen : isActive ? kPurple : kMuted2;

    return Column(
      children: [
        Container(
          width: 22, height: 22,
          decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                color: isDone || isActive ? Colors.white : kMuted2,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: textColor, fontSize: 10, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _stepLine({required bool isDone}) {
    return Expanded(
      child: Container(
        height: 1,
        margin: const EdgeInsets.only(bottom: 14, left: 6, right: 6),
        color: isDone ? kGreen : kBorder,
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          color: kSub,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildInfoBlock({
    required String icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: kCard,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: kBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 38, height: 38,
              decoration: BoxDecoration(
                color: kPurple.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(child: Text(icon, style: const TextStyle(fontSize: 18))),
            ),
            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(color: kSub, fontSize: 11, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: const TextStyle(color: kText, fontSize: 14, fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: kMuted2, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressCard(Map<String, String> addr, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF1A1720) : kCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isSelected ? kPurple : kBorder,
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: isSelected ? kPurple.withOpacity(0.15) : kMuted,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(child: Text(addr['emoji']!, style: const TextStyle(fontSize: 16))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(addr['type']!, style: const TextStyle(color: kText, fontSize: 14, fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(addr['address']!, style: const TextStyle(color: kSub, fontSize: 12)),
                Builder(builder: (ctx) {
                  final currentUser = AuthService.instance.currentUser;
                  final rawPerson = addr['person']!;
                  final parts = rawPerson.split('·');
                  final phone = parts.length > 1 ? parts.sublist(1).join('·').trim() : '';
                  final defaultName = parts[0].trim();
                  final displayName = currentUser != null ? currentUser.name : defaultName;
                  final displayPerson = phone.isNotEmpty ? '$displayName · $phone' : displayName;
                  return Text(displayPerson, style: const TextStyle(color: kMuted2, fontSize: 11));
                }),
              ],
            ),
          ),

          Container(
            width: 18, height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? kPurple : kBorder,
                width: 2,
              ),
            ),
            child: isSelected
                ? Center(
              child: Container(
                width: 8, height: 8,
                decoration: const BoxDecoration(
                  color: kPurple,
                  shape: BoxShape.circle,
                ),
              ),
            )
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildItemList() {
    return Container(
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: kBorder),
      ),
      child: Column(
        children: widget.items.asMap().entries.map((entry) {
          final i    = entry.key;
          final item = entry.value;
          final isLast = i == widget.items.length - 1;

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: isLast ? null : const Border(
                bottom: BorderSide(color: kBorder),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 52, height: 52,
                  decoration: BoxDecoration(
                    color: kMuted,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Builder(builder: (ctx) {
                      final prod = item['product'] as dynamic;
                      final img = prod?.image as String?;
                      if (img != null && img.isNotEmpty) {
                        return Image.asset(img, fit: BoxFit.cover, width: 52, height: 52);
                      }
                      return Center(child: Text(prod?.name?.substring(0, 1).toUpperCase() ?? '?', style: const TextStyle(fontSize: 20)));
                    }),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        (item['product'] as dynamic).name ?? 'Product',
                        style: const TextStyle(color: kText, fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '★ ${(item['product'] as dynamic).rating ?? 0}  ·  ×${item['quantity']}',
                        style: const TextStyle(color: kSub, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Text(
                  '\$${(((item['product'] as dynamic).price ?? 0.0) * (item['quantity'] as int)).toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: kText,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSummaryBox() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: kCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: kBorder),
      ),
      child: Column(
        children: [
          _summaryRow('Total Items', '${widget.items.length.toString().padLeft(2, '0')}'),
          _summaryRow('Subtotal', '\$${widget.subtotal.toStringAsFixed(2)}'),

          if (widget.couponApplied)
            _summaryRow('Discount', '-\$${widget.discount.toStringAsFixed(2)}', valueColor: kGreen),

          _summaryRow('VAT (13%)', '\$${widget.vat.toStringAsFixed(2)}'),
          _summaryRow('Shipping Fee', '\$00.50'),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(color: kBorder, height: 1),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Payable',
                style: TextStyle(color: kText, fontSize: 17, fontWeight: FontWeight.w700),
              ),
              Text(
                '\$${widget.total.toStringAsFixed(2)}',
                style: const TextStyle(color: kPurple, fontSize: 17, fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {Color valueColor = kText}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: kSub, fontSize: 14)),
          Text(value, style: TextStyle(color: valueColor, fontSize: 14, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildPlaceOrderBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: const BoxDecoration(
        color: kBg,
        border: Border(top: BorderSide(color: kBorder)),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: kPurple,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 8,
          shadowColor: kPurple.withOpacity(0.45),
        ),
        onPressed: () {
          setState(() => _orderPlaced = true);
        },
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Place Order', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            SizedBox(width: 8),
            Text('🎉'),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessScreen() {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120, height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [kPurple, kGreen],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: kPurple.withOpacity(0.4),
                        blurRadius: 40,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text('🎉', style: TextStyle(fontSize: 52)),
                  ),
                ),
                const SizedBox(height: 28),
                const Text(
                  'Order Placed!',
                  style: TextStyle(
                    color: kText,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Your order is being placed\nand will be delivered shortly.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: kSub, fontSize: 15, height: 1.6),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: kPurple.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: kPurple),
                  ),
                  child: const Text(
                    '#ORD-2026-4837',
                    style: TextStyle(color: kPurple, fontWeight: FontWeight.w700, fontSize: 13),
                  ),
                ),
                const SizedBox(height: 28),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: kCard,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: kBorder),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: const [
                          Text('5', style: TextStyle(color: kPurple, fontSize: 28, fontWeight: FontWeight.w800)),
                          SizedBox(height: 4),
                          Text('Est. Hours', style: TextStyle(color: kSub, fontSize: 12)),
                        ],
                      ),
                      Container(width: 1, height: 50, color: kBorder),
                      Column(
                        children: [
                          Text(
                            '\$${widget.total.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: kPurple,
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text('Total Paid', style: TextStyle(color: kSub, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 8,
                      shadowColor: kPurple.withOpacity(0.45),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Back to Home',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}