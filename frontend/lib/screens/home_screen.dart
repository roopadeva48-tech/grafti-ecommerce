import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/grafti_provider.dart';
import '../theme/grafti_theme.dart';
import '../models/models.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  int _activePromoPage = 0;
  final PageController _promoController = PageController();

  final List<String> _categories = [
    'All',
    'Greeting card',
    'Crochet',
    'Aari work',
    'Stationery',
    'Aari work accessories',
    'Kerchief embroidery',
    'Pencil carving',
    'Paper craft',
    'Paper products'
  ];

  final Map<String, IconData> _categoryIcons = {
    'All': Icons.apps,
    'Greeting card': Icons.card_giftcard,
    'Crochet': Icons.toys_outlined,
    'Aari work': Icons.brush_outlined,
    'Stationery': Icons.edit_note,
    'Aari work accessories': Icons.hardware_outlined,
    'Kerchief embroidery': Icons.color_lens_outlined,
    'Pencil carving': Icons.gesture,
    'Paper craft': Icons.architecture_outlined,
    'Paper products': Icons.description_outlined,
  };

  @override
  void dispose() {
    _searchController.dispose();
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GraftiProvider>(context);
    final user = provider.currentUser;
    
    // Detect viewport size
    final isDesktop = MediaQuery.of(context).size.width >= 768;

    return Scaffold(
      backgroundColor: GraftiTheme.surfaceBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Image.asset(
          'assets/logo.png',
          height: isDesktop ? 38 : 30,
          fit: BoxFit.contain,
          alignment: Alignment.centerLeft,
          errorBuilder: (context, error, stackTrace) => Text(
            isDesktop ? 'Handcrafted Gift Platform' : 'Grafti',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: GraftiTheme.darkPlum,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Stack(
              children: [
                Icon(
                  provider.wishlist.isNotEmpty ? Icons.favorite : Icons.favorite_border,
                  color: provider.wishlist.isNotEmpty ? const Color(0xFFEF4444) : GraftiTheme.darkPlum,
                  size: 24,
                ),
                if (provider.wishlist.isNotEmpty)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
              ],
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Wishlist has ${provider.wishlist.length} item(s).'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
          if (!isDesktop) ...[
            IconButton(
              icon: const Icon(Icons.settings_outlined, color: GraftiTheme.darkPlum),
              onPressed: () => provider.setActiveTab(4),
            ),
            const SizedBox(width: 8),
            // Profile status indicator
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: provider.accountTypeSelection == 'business'
                      ? const Color(0xFF4CAF50)
                      : GraftiTheme.primaryPink,
                  width: 2,
                ),
              ),
              child: ClipOval(
                child: Image.network(
                  '${provider.baseUrl}${user?.avatarUrl ?? "/images/avatar_deva.jpg"}',
                  width: 32,
                  height: 32,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, color: GraftiTheme.darkPlum),
                ),
              ),
            ),
            const SizedBox(width: 16),
          ],
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: isDesktop ? 40.0 : 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search & Filters Panel
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 52,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(26),
                            boxShadow: GraftiTheme.softShadow,
                            border: Border.all(color: GraftiTheme.softLilac),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              const Icon(Icons.search, color: GraftiTheme.mutedText),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  onChanged: (val) => provider.searchProducts(val),
                                  decoration: const InputDecoration(
                                    hintText: 'Search handmade crafts...',
                                    hintStyle: TextStyle(color: GraftiTheme.mutedText, fontSize: 14),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        height: 52,
                        width: 52,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: GraftiTheme.softShadow,
                          border: Border.all(color: GraftiTheme.softLilac),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.tune, color: GraftiTheme.darkPlum),
                          onPressed: () {
                            provider.selectCategory('All');
                            _searchController.clear();
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // Carousel Promotional Slide Banner
                Container(
                  height: isDesktop ? 160 : 130,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  child: PageView(
                    controller: _promoController,
                    onPageChanged: (idx) {
                      setState(() {
                        _activePromoPage = idx;
                      });
                    },
                    children: [
                      _buildPromoSlide(
                        color1: const Color(0xFF475569), // Muted Slate
                        color2: const Color(0xFF64748B),
                        title: "25% Offer for first order",
                        subtitle: "Don't let it vanish. Enter coupon WELCOME25",
                        action: "WELCOME25",
                      ),
                      _buildPromoSlide(
                        color1: const Color(0xFF0F172A),
                        color2: const Color(0xFF334155),
                        title: "Bespoke AI Concierge Designer",
                        subtitle: "Generate live staged craft mockups in real-time.",
                        action: "CHAT",
                      ),
                    ],
                  ),
                ),
                
                // Indicators
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(2, (index) {
                      return Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _activePromoPage == index
                              ? GraftiTheme.primaryPink
                              : GraftiTheme.softLilac,
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 24),

                // Responsive Category Row
                const Text(
                  'Browse Categories',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: GraftiTheme.darkPlum),
                ),
                const SizedBox(height: 12),
                
                isDesktop
                    ? Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: _categories.map((cat) {
                          final isSelected = provider.selectedCategory == cat;
                          return ChoiceChip(
                            label: Text(cat),
                            selected: isSelected,
                            onSelected: (_) => provider.selectCategory(cat),
                            backgroundColor: Colors.white,
                            selectedColor: GraftiTheme.secondaryPastelPink,
                            labelStyle: TextStyle(
                              color: isSelected ? GraftiTheme.darkPlum : GraftiTheme.plumDarkText,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(color: isSelected ? GraftiTheme.primaryPink : GraftiTheme.softLilac),
                            ),
                          );
                        }).toList(),
                      )
                    : SizedBox(
                        height: 96,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _categories.length,
                          itemBuilder: (context, index) {
                            final cat = _categories[index];
                            final isSelected = provider.selectedCategory == cat;
                            final categoryIcon = _categoryIcons[cat] ?? Icons.category_outlined;

                            return Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: GestureDetector(
                                onTap: () => provider.selectCategory(cat),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 52,
                                      height: 52,
                                      decoration: BoxDecoration(
                                        color: isSelected ? GraftiTheme.primaryPink : Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: GraftiTheme.softShadow,
                                        border: Border.all(
                                          color: isSelected ? Colors.transparent : GraftiTheme.softLilac,
                                        ),
                                      ),
                                      child: Icon(
                                        categoryIcon,
                                        color: isSelected ? Colors.white : GraftiTheme.darkPlum,
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      cat,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                        color: isSelected ? GraftiTheme.primaryPink : GraftiTheme.plumDarkText,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                const SizedBox(height: 28),

                // Products Section
                const Text(
                  'Collections',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: GraftiTheme.darkPlum),
                ),
                const SizedBox(height: 12),

                // Responsive Product Grid
                provider.isProductsLoading
                    ? const Center(child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: CircularProgressIndicator(color: GraftiTheme.primaryPink),
                      ))
                    : provider.filteredProducts.isEmpty
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(32.0),
                              child: Text(
                                'No craft items found.',
                                style: TextStyle(color: GraftiTheme.mutedText),
                              ),
                            ),
                          )
                        : GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: isDesktop ? 4 : 2,
                              childAspectRatio: isDesktop ? 0.76 : 0.72,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                            itemCount: provider.filteredProducts.length,
                            itemBuilder: (context, index) {
                              final product = provider.filteredProducts[index];
                              return _buildProductCard(context, product, provider);
                            },
                          ),

                const SizedBox(height: 24),

                // Pagination (1-6 pills)
                Center(
                  child: Container(
                    height: 40,
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(6, (idx) {
                        final pageNum = idx + 1;
                        final isCurrentPage = pageNum == 1;
                        return GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Switched to Mock Page $pageNum')),
                            );
                          },
                          child: Container(
                            width: 32,
                            height: 32,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: isCurrentPage ? GraftiTheme.primaryPink : Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: GraftiTheme.softShadow,
                              border: Border.all(
                                color: isCurrentPage ? Colors.transparent : GraftiTheme.softLilac,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '$pageNum',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: isCurrentPage ? Colors.white : GraftiTheme.darkPlum,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),

                SizedBox(height: isDesktop ? 48 : 100), // Nav offset buffer
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPromoSlide({
    required Color color1,
    required Color color2,
    required String title,
    required String subtitle,
    required String action,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color1, color2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: GraftiTheme.softShadow,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: GraftiTheme.darkPlum,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            onPressed: () {
              if (action == "CHAT") {
                Provider.of<GraftiProvider>(context, listen: false).setActiveTab(5); // Concierge
              } else {
                Provider.of<GraftiProvider>(context, listen: false).applyVoucher(action);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Voucher $action applied!')),
                );
              }
            },
            child: const Text('Explore', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, Product product, GraftiProvider provider) {
    final inWishlist = provider.wishlist.contains(product.id);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: GraftiTheme.softShadow,
        border: Border.all(color: GraftiTheme.softLilac),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  '${provider.baseUrl}${product.imageUrl}',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: GraftiTheme.secondaryPastelPink,
                    child: const Icon(Icons.gif_box_outlined, color: GraftiTheme.darkPlum, size: 36),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: () => provider.toggleWishlist(product.id),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: Icon(
                        inWishlist ? Icons.favorite : Icons.favorite_border,
                        color: inWishlist ? const Color(0xFFEF4444) : GraftiTheme.mutedText,
                        size: 16,
                      ),
                    ),
                  ),
                ),
                if (product.isCustomizable)
                  Positioned(
                    bottom: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        '🪄 Custom',
                        style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: GraftiTheme.darkPlum),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.category.toUpperCase(),
                  style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: GraftiTheme.mutedText, letterSpacing: 0.8),
                ),
                const SizedBox(height: 4),
                Text(
                  product.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: GraftiTheme.plumDarkText),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: GraftiTheme.darkPlum),
                    ),
                    GestureDetector(
                      onTap: () {
                        provider.addToCart(product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${product.title} added!'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(color: GraftiTheme.primaryPink, shape: BoxShape.circle),
                        child: const Icon(Icons.add, color: Colors.white, size: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
