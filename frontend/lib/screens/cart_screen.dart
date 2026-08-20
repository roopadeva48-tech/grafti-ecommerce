import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/grafti_provider.dart';
import '../theme/grafti_theme.dart';
import '../models/models.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _voucherController = TextEditingController();
  String _selectedPayment = 'Credit Card';

  final List<String> _paymentMethods = [
    'Credit Card',
    'UPI / NetBanking',
    'Apple/Google Pay',
    'Cash on Delivery'
  ];

  @override
  void dispose() {
    _voucherController.dispose();
    super.dispose();
  }

  void _triggerPayment(BuildContext context, GraftiProvider provider) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(
        child: CircularProgressIndicator(color: GraftiTheme.primaryPink),
      ),
    );

    final result = await provider.checkout(
      address: provider.currentUser?.deliveryAddress ?? '123 Magic Ribbon Way',
      paymentMethod: _selectedPayment,
    );

    if (mounted) {
      Navigator.pop(context);
    }

    if (result['success'] == true) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => const CheckoutSuccessModal(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GraftiProvider>(context);
    final cartItems = provider.cart;

    final isDesktop = MediaQuery.of(context).size.width >= 768;

    return Scaffold(
      backgroundColor: GraftiTheme.surfaceBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'Shopping Cart',
          style: TextStyle(fontWeight: FontWeight.bold, color: GraftiTheme.darkPlum),
        ),
      ),
      body: SafeArea(
        child: cartItems.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.shopping_bag_outlined, size: 72, color: GraftiTheme.softLilac),
                    const SizedBox(height: 16),
                    const Text(
                      'Your cart is empty',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: GraftiTheme.darkPlum),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => provider.setActiveTab(2),
                      child: const Text('Start Craft Shopping', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: isDesktop ? 40.0 : 20.0),
                  child: isDesktop
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left Column: Cart items
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'ORDER SUMMARY',
                                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: GraftiTheme.mutedText, letterSpacing: 1.1),
                                  ),
                                  const SizedBox(height: 12),
                                  ListView.builder(
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: cartItems.length,
                                    itemBuilder: (context, index) {
                                      final item = cartItems[index];
                                      return _buildCartItemCard(context, item, provider);
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 32),

                            // Right Column: Checkout forms & billing details
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildDeliverySection(provider),
                                  const SizedBox(height: 24),
                                  _buildVoucherSection(provider),
                                  const SizedBox(height: 24),
                                  _buildPaymentSection(),
                                  const SizedBox(height: 24),
                                  _buildBillingSummaryCard(provider),
                                  const SizedBox(height: 24),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 52,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(backgroundColor: GraftiTheme.successGreen),
                                      onPressed: () => _triggerPayment(context, provider),
                                      child: const Text('Proceed to Pay', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'ORDER ITEMS',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: GraftiTheme.mutedText, letterSpacing: 1.1),
                            ),
                            const SizedBox(height: 10),
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: cartItems.length,
                              itemBuilder: (context, index) {
                                final item = cartItems[index];
                                  return _buildCartItemCard(context, item, provider);
                              },
                            ),
                            const SizedBox(height: 24),
                            _buildDeliverySection(provider),
                            const SizedBox(height: 24),
                            _buildVoucherSection(provider),
                            const SizedBox(height: 24),
                            _buildPaymentSection(),
                            const SizedBox(height: 24),
                            _buildBillingSummaryCard(provider),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              height: 52,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: GraftiTheme.successGreen),
                                onPressed: () => _triggerPayment(context, provider),
                                child: const Text('Proceed to Pay', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                              ),
                            ),
                            const SizedBox(height: 120),
                          ],
                        ),
                ),
              ),
      ),
    );
  }

  Widget _buildDeliverySection(GraftiProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'DELIVERY LOCATION',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: GraftiTheme.mutedText, letterSpacing: 1.1),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: GraftiTheme.softShadow,
            border: Border.all(color: GraftiTheme.softLilac),
          ),
          child: Row(
            children: [
              const Icon(Icons.local_shipping_outlined, color: GraftiTheme.primaryPink),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Default Address',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: GraftiTheme.plumDarkText),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      provider.currentUser?.deliveryAddress ?? 'Configure address in profile',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: GraftiTheme.mutedText, fontSize: 11),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.keyboard_arrow_right, color: GraftiTheme.mutedText),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVoucherSection(GraftiProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'VOUCHER COUPON',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: GraftiTheme.mutedText, letterSpacing: 1.1),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: GraftiTheme.softLilac),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _voucherController,
                  decoration: const InputDecoration(
                    hintText: 'Try WELCOME25',
                    hintStyle: TextStyle(color: GraftiTheme.mutedText, fontSize: 13),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: GraftiTheme.darkPlum,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                padding: const EdgeInsets.symmetric(horizontal: 20),
              ),
              onPressed: () {
                if (provider.applyVoucher(_voucherController.text)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Voucher code applied successfully!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invalid Voucher Code.')),
                  );
                }
              },
              child: const Text('Apply', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
        if (provider.voucherCode.isNotEmpty) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 14),
              const SizedBox(width: 4),
              Text(
                'Code "${provider.voucherCode}" Active (25% Off)',
                style: const TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => provider.removeVoucher(),
                child: const Text('Remove', style: TextStyle(color: Colors.redAccent, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildPaymentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'PAYMENT METHOD',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: GraftiTheme.mutedText, letterSpacing: 1.1),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: GraftiTheme.softShadow,
            border: Border.all(color: GraftiTheme.softLilac),
          ),
          child: Column(
            children: _paymentMethods.map((method) {
              return RadioListTile<String>(
                title: Text(method, style: const TextStyle(fontSize: 13, color: GraftiTheme.plumDarkText)),
                value: method,
                groupValue: _selectedPayment,
                activeColor: GraftiTheme.primaryPink,
                contentPadding: EdgeInsets.zero,
                onChanged: (val) {
                  setState(() {
                    _selectedPayment = val!;
                  });
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildBillingSummaryCard(GraftiProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'BILLING SUMMARY',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: GraftiTheme.mutedText, letterSpacing: 1.1),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: GraftiTheme.softShadow,
            border: Border.all(color: GraftiTheme.softLilac),
          ),
          child: Column(
            children: [
              _buildPriceRow('Subtotal', provider.cartSubtotal),
              if (provider.customCraftingFee > 0)
                _buildPriceRow('Custom Crafting Fee', provider.customCraftingFee),
              _buildPriceRow('Delivery', provider.deliveryFee),
              if (provider.discount > 0)
                _buildPriceRow('Discount Voucher', -provider.discount, isDiscount: true),
              const Divider(color: GraftiTheme.softLilac, height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: GraftiTheme.darkPlum)),
                  Text('\$${provider.cartTotal.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: GraftiTheme.primaryPink)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRow(String label, double val, {bool isDiscount = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: GraftiTheme.plumDarkText)),
          Text(
            isDiscount ? '-\$${val.abs().toStringAsFixed(2)}' : '\$${val.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isDiscount ? Colors.green : GraftiTheme.plumDarkText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItemCard(BuildContext context, CartItem item, GraftiProvider provider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: GraftiTheme.softShadow,
        border: Border.all(color: GraftiTheme.softLilac),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              width: 64,
              height: 64,
              child: Image.network(
                '${provider.baseUrl}${item.product.imageUrl}',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: GraftiTheme.secondaryPastelPink,
                  child: const Icon(Icons.gif_box_outlined, color: GraftiTheme.darkPlum),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: GraftiTheme.plumDarkText),
                ),
                const SizedBox(height: 2),
                Text(
                  item.isCustom ? '🪄 Bespoke custom craft' : 'Handmade standard',
                  style: const TextStyle(fontSize: 10, color: GraftiTheme.mutedText),
                ),
                const SizedBox(height: 6),
                Text(
                  '\$${item.product.price.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: GraftiTheme.darkPlum),
                ),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 18),
                onPressed: () => provider.removeFromCart(item),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => provider.updateCartQuantity(item, -1),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(color: GraftiTheme.secondaryPastelPink, shape: BoxShape.circle),
                      child: const Icon(Icons.remove, size: 14, color: GraftiTheme.darkPlum),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => provider.updateCartQuantity(item, 1),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: GraftiTheme.primaryPink, shape: BoxShape.circle),
                      child: const Icon(Icons.add, size: 14, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}

// Custom Confetti & Checkmark Checkout Success Modal
class CheckoutSuccessModal extends StatefulWidget {
  const CheckoutSuccessModal({super.key});

  @override
  State<CheckoutSuccessModal> createState() => _CheckoutSuccessModalState();
}

class _CheckoutSuccessModalState extends State<CheckoutSuccessModal> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<ConfettiParticle> _particles = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..addListener(() {
        _updateParticles();
        setState(() {});
      });

    final random = math.Random();
    for (int i = 0; i < 60; i++) {
      _particles.add(ConfettiParticle(
        x: random.nextDouble() * 280 - 140,
        y: -150 - random.nextDouble() * 100,
        color: HSVColor.fromAHSV(
          1.0,
          random.nextDouble() * 360,
          0.6, // slightly lighter saturation for minimalist look
          0.9,
        ).toColor(),
        size: random.nextDouble() * 8 + 4,
        speedX: random.nextDouble() * 4 - 2,
        speedY: random.nextDouble() * 6 + 4,
        rot: random.nextDouble() * math.pi,
        rotSpeed: random.nextDouble() * 0.1 - 0.05,
      ));
    }

    _controller.forward();
  }

  void _updateParticles() {
    for (var p in _particles) {
      p.y += p.speedY;
      p.x += p.speedX;
      p.rot += p.rotSpeed;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
      elevation: 0,
      backgroundColor: Colors.white,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: SizedBox(
          height: 380,
          width: 300,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: const Size(300, 380),
                painter: ConfettiPainter(particles: _particles),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 90,
                      height: 90,
                      child: CustomPaint(
                        painter: CheckmarkCirclePainter(progress: _controller.value),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Payment Success!',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: GraftiTheme.darkPlum),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Your custom handmade craft is queued for fabrication. Our Concierge will notify you when it ships!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: GraftiTheme.mutedText, fontSize: 12),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: GraftiTheme.successGreen,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Provider.of<GraftiProvider>(context, listen: false).setActiveTab(2);
                      },
                      child: const Text('Back to Catalog', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ConfettiParticle {
  double x;
  double y;
  final Color color;
  final double size;
  final double speedX;
  final double speedY;
  double rot;
  final double rotSpeed;

  ConfettiParticle({
    required this.x,
    required this.y,
    required this.color,
    required this.size,
    required this.speedX,
    required this.speedY,
    required this.rot,
    required this.rotSpeed,
  });
}

class ConfettiPainter extends CustomPainter {
  final List<ConfettiParticle> particles;
  ConfettiPainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);

    for (var p in particles) {
      if (p.y > size.height / 2) continue;

      paint.color = p.color;
      canvas.save();
      canvas.translate(p.x, p.y);
      canvas.rotate(p.rot);
      canvas.drawRect(Rect.fromLTWH(-p.size / 2, -p.size / 2, p.size, p.size * 0.6), paint);
      canvas.restore();
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class CheckmarkCirclePainter extends CustomPainter {
  final double progress;
  CheckmarkCirclePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;

    final circlePaint = Paint()
      ..color = GraftiTheme.softLilac
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0;

    final checkPaint = Paint()
      ..color = GraftiTheme.successGreen
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 6.0;

    canvas.drawCircle(center, radius, circlePaint);

    if (progress > 0) {
      final fillPaint = Paint()
        ..color = GraftiTheme.successGreen
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6.0;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        2 * math.pi * progress.clamp(0.0, 0.5) * 2,
        false,
        fillPaint,
      );
    }

    if (progress > 0.4) {
      final checkProgress = ((progress - 0.4) / 0.6).clamp(0.0, 1.0);
      final path = Path();
      final start = Offset(size.width * 0.28, size.height * 0.5);
      final mid = Offset(size.width * 0.45, size.height * 0.65);
      final end = Offset(size.width * 0.72, size.height * 0.35);

      if (checkProgress < 0.5) {
        final localProg = checkProgress / 0.5;
        path.moveTo(start.dx, start.dy);
        path.lineTo(
          start.dx + (mid.dx - start.dx) * localProg,
          start.dy + (mid.dy - start.dy) * localProg,
        );
      } else {
        final localProg = (checkProgress - 0.5) / 0.5;
        path.moveTo(start.dx, start.dy);
        path.lineTo(mid.dx, mid.dy);
        path.lineTo(
          mid.dx + (end.dx - mid.dx) * localProg,
          mid.dy + (end.dy - mid.dy) * localProg,
        );
      }
      canvas.drawPath(path, checkPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CheckmarkCirclePainter oldDelegate) => true;
}
