import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/grafti_provider.dart';
import '../theme/grafti_theme.dart';
import '../models/models.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GraftiProvider>(context);

    return Scaffold(
      backgroundColor: GraftiTheme.surfaceBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'Discover Crafts',
          style: TextStyle(fontWeight: FontWeight.bold, color: GraftiTheme.darkPlum),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Search Input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(26),
                  boxShadow: GraftiTheme.softShadow,
                  border: Border.all(color: GraftiTheme.softLilac.withOpacity(0.4)),
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
                          hintText: 'Search items, tags, or materials...',
                          hintStyle: TextStyle(color: GraftiTheme.mutedText, fontSize: 14),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    if (_searchController.text.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear, color: GraftiTheme.mutedText, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          provider.searchProducts('');
                        },
                      ),
                  ],
                ),
              ),
            ),

            // Results count or suggestions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Found ${provider.filteredProducts.length} results',
                    style: const TextStyle(fontSize: 12, color: GraftiTheme.mutedText, fontWeight: FontWeight.bold),
                  ),
                  if (provider.selectedCategory != 'All')
                    GestureDetector(
                      onTap: () {
                        provider.selectCategory('All');
                        _searchController.clear();
                      },
                      child: Text(
                        'Clear filters (${provider.selectedCategory})',
                        style: const TextStyle(fontSize: 12, color: GraftiTheme.primaryPink, fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Search Grid
            Expanded(
              child: provider.filteredProducts.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.search_off_outlined, size: 64, color: GraftiTheme.softLilac),
                          const SizedBox(height: 16),
                          const Text(
                            'No craft matches found',
                            style: TextStyle(fontWeight: FontWeight.bold, color: GraftiTheme.darkPlum),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Try adjusting your search terms.',
                            style: TextStyle(color: GraftiTheme.mutedText, fontSize: 12),
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.72,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: provider.filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = provider.filteredProducts[index];
                        return _buildSearchCard(context, product, provider);
                      },
                    ),
            ),
            const SizedBox(height: 72), // Nav bar spacing
          ],
        ),
      ),
    );
  }

  Widget _buildSearchCard(BuildContext context, Product product, GraftiProvider provider) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: GraftiTheme.softShadow,
        border: Border.all(color: GraftiTheme.softLilac.withOpacity(0.3)),
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
                    color: GraftiTheme.softLilac.withOpacity(0.3),
                    child: const Icon(Icons.gif_box_outlined, color: GraftiTheme.darkPlum),
                  ),
                ),
                // Rating tag
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 10),
                        const SizedBox(width: 2),
                        Text(
                          '${product.rating}',
                          style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: GraftiTheme.plumDarkText),
                        ),
                      ],
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
                  product.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: GraftiTheme.plumDarkText),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: GraftiTheme.darkPlum),
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
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: GraftiTheme.primaryPink,
                          shape: BoxShape.circle,
                        ),
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
