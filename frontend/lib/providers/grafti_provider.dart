import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/models.dart';

class GraftiProvider with ChangeNotifier {
  // Navigation State
  int _activeTab = 2; // Default to Home (Index 2)
  int get activeTab => _activeTab;

  void setActiveTab(int index) {
    _activeTab = index;
    notifyListeners();
  }

  // Auth State
  User? _currentUser;
  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  String _accountTypeSelection = 'customer'; // Default select
  String get accountTypeSelection => _accountTypeSelection;

  void setAccountTypeSelection(String type) {
    _accountTypeSelection = type;
    notifyListeners();
  }

  bool _isAuthLoading = false;
  bool get isAuthLoading => _isAuthLoading;

  // Catalog State
  List<Product> _products = [];
  List<Product> get products => _products;

  List<Product> _filteredProducts = [];
  List<Product> get filteredProducts => _filteredProducts;

  String _selectedCategory = 'All';
  String get selectedCategory => _selectedCategory;

  bool _isProductsLoading = false;
  bool get isProductsLoading => _isProductsLoading;

  // Wishlist
  final Set<String> _wishlist = {};
  Set<String> get wishlist => _wishlist;

  void toggleWishlist(String productId) {
    if (_wishlist.contains(productId)) {
      _wishlist.remove(productId);
    } else {
      _wishlist.add(productId);
    }
    notifyListeners();
  }

  // Cart State
  final List<CartItem> _cart = [];
  List<CartItem> get cart => _cart;

  double get cartSubtotal {
    double sum = 0.0;
    for (var item in _cart) {
      sum += item.product.price * item.quantity;
    }
    return sum;
  }

  double get customCraftingFee {
    double sum = 0.0;
    for (var item in _cart) {
      if (item.isCustom) {
        sum += 25.0 * item.quantity; // Custom fee per item
      }
    }
    return sum;
  }

  double get deliveryFee {
    if (_cart.isEmpty) return 0.0;
    return cartSubtotal > 100.0 ? 0.0 : 10.0;
  }

  String _voucherCode = '';
  String get voucherCode => _voucherCode;

  double get discount {
    if (_voucherCode.toUpperCase() == 'WELCOME25') {
      return cartSubtotal * 0.25; // 25% off subtotal
    }
    return 0.0;
  }

  double get cartTotal {
    return cartSubtotal + customCraftingFee + deliveryFee - discount;
  }

  // Chat State
  final List<ChatMessage> _chatMessages = [];
  List<ChatMessage> get chatMessages => _chatMessages;

  bool _isChatLoading = false;
  bool get isChatLoading => _isChatLoading;

  // Notifications
  int _unreadNotifications = 2;
  int get unreadNotifications => _unreadNotifications;

  final List<String> _notifications = [
    "✨ Your customized Greeting Card order is being handcrafted right now!",
    "🎁 Welcome to Grafti! Use code WELCOME25 for 25% off your first order."
  ];
  List<String> get notificationsList => _notifications;

  void clearNotifications() {
    _unreadNotifications = 0;
    notifyListeners();
  }

  // Environment Setup
  String get baseUrl {
    if (kIsWeb) {
      // In web local development, connect to Next.js dev server on port 3000
      if (Uri.base.host == 'localhost' || Uri.base.host == '127.0.0.1') {
        return 'http://${Uri.base.host}:3000';
      }
      return Uri.base.origin;
    } else {
      // Android emulator fallback to localhost mapping, iOS/desktop to localhost:3000
      return defaultTargetPlatform == TargetPlatform.android
          ? 'http://10.0.2.2:3000'
          : 'http://localhost:3000';
    }
  }

  // Constructors & Initialization
  GraftiProvider() {
    // Seed initial welcome message for chat
    _chatMessages.add(ChatMessage(
      sender: 'concierge',
      text: "Hi! I am your Craft Concierge. I specialize in designing and tailoring premium, one-of-a-kind handmade gifts. Just tell me what you want to customize (e.g. try asking for a 'card' or 'crochet wizard')!",
      timestamp: DateTime.now(),
    ));
    fetchProducts();
  }

  // API Call: Fetch Products
  Future<void> fetchProducts() async {
    _isProductsLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse('$baseUrl/api/products'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          var list = data['products'] as List;
          _products = list.map((p) => Product.fromJson(p)).toList();
          _filteredProducts = List.from(_products);
        }
      } else {
        _seedMockProducts();
      }
    } catch (e) {
      print('Network error fetching products, seeding local fallback catalog: $e');
      _seedMockProducts();
    } finally {
      _isProductsLoading = false;
      notifyListeners();
    }
  }

  void _seedMockProducts() {
    // Fallback static list in case server is unreachable
    _products = [
      Product(
        id: 'p1',
        title: 'Whimsical Pop-up Greeting Card',
        category: 'Greeting card',
        price: 15.00,
        rating: 4.9,
        reviewsCount: 124,
        imageUrl: '/images/product_card.jpg',
        description: 'A beautifully handmade three-dimensional pop-up greeting card featuring intricate paper-cut floral designs. Perfect for special moments.',
        isCustomizable: true,
        options: ['Personalized Name', 'Custom Message', 'Custom Color Ribbon']
      ),
      Product(
        id: 'p2',
        title: 'Whimsical Crochet Wizard Doll',
        category: 'Crochet',
        price: 28.50,
        rating: 4.8,
        reviewsCount: 92,
        imageUrl: '/images/product_crochet.jpg',
        description: 'Handmade cozy wool crochet doll of a little wizard with a felt hat and a wooden wand. Filled with love and magic.',
        isCustomizable: true,
        options: ['Embroidered Initials', 'Hat Color Change']
      ),
      Product(
        id: 'p3',
        title: 'Aari Work Floral Patch',
        category: 'Aari work',
        price: 45.00,
        rating: 4.7,
        reviewsCount: 38,
        imageUrl: '/images/product_card.jpg',
        description: 'Traditional heavy embroidery work on silk patch using Zardosi and beads.',
        isCustomizable: false,
        options: []
      )
    ];
    _filteredProducts = List.from(_products);
  }

  // Filter Catalog
  void selectCategory(String category) {
    _selectedCategory = category;
    if (category == 'All') {
      _filteredProducts = List.from(_products);
    } else {
      _filteredProducts = _products.where((p) => p.category == category).toList();
    }
    notifyListeners();
  }

  // Search Catalog
  void searchProducts(String query) {
    if (query.isEmpty) {
      selectCategory(_selectedCategory);
    } else {
      _filteredProducts = _products
          .where((p) =>
              p.title.toLowerCase().contains(query.toLowerCase()) ||
              p.category.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  // API Call: Login
  Future<bool> login(String email, String password) async {
    _isAuthLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'action': 'signin',
          'email': email,
          'password': password,
          'accountType': _accountTypeSelection,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          _currentUser = User.fromJson(data['user']);
          _unreadNotifications++;
          _notifications.insert(0, "🔑 Sign-in successful! Welcome back, ${_currentUser!.name}!");
          notifyListeners();
          return true;
        }
      }
    } catch (e) {
      print('Auth error: $e. Falling back to local offline session.');
    }

    // Fallback Offline Mock User
    _currentUser = User(
      id: 'user_deva_offline',
      email: email,
      name: email.toLowerCase().contains('deva') ? 'Deva' : 'Grafti Offline Lover',
      accountType: _accountTypeSelection,
      avatarUrl: '/images/avatar_deva.jpg',
      phoneNumber: '+1 (555) 019-2834',
      paymentMode: 'UPI / saved card',
      location: 'New York, NY',
      deliveryAddress: '123 ribbon street, NY',
      token: 'mock_jwt_token_deva_grafti',
    );
    _unreadNotifications++;
    _notifications.insert(0, "🔑 Offline sign-in simulation successful!");
    _isAuthLoading = false;
    notifyListeners();
    return true;
  }

  // API Call: Sign Up
  Future<bool> signup(String email, String password, String name) async {
    _isAuthLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'action': 'signup',
          'email': email,
          'password': password,
          'name': name,
          'accountType': _accountTypeSelection,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          _currentUser = User.fromJson(data['user']);
          _unreadNotifications++;
          _notifications.insert(0, "🎉 Registration complete! Welcome to Grafti, ${_currentUser!.name}!");
          notifyListeners();
          return true;
        }
      }
    } catch (e) {
      print('Signup error: $e');
    }

    // Fallback Sign Up
    _currentUser = User(
      id: 'user_new_offline',
      email: email,
      name: name,
      accountType: _accountTypeSelection,
      avatarUrl: '/images/avatar_deva.jpg',
      phoneNumber: '+1 (555) 000-0000',
      paymentMode: 'Not Configured',
      location: 'Not Configured',
      deliveryAddress: 'Not Configured',
      token: 'mock_signup_token',
    );
    _unreadNotifications++;
    _notifications.insert(0, "🎉 Offline sign-up simulation successful!");
    _isAuthLoading = false;
    notifyListeners();
    return true;
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  // Cart Operations
  void addToCart(Product product, {bool isCustom = false, Map<String, String>? selections}) {
    // Check if item already exists in cart with same customization
    final index = _cart.indexWhere((item) =>
        item.product.id == product.id && item.isCustom == isCustom);

    if (index >= 0) {
      _cart[index].quantity++;
    } else {
      _cart.add(CartItem(
        product: product,
        quantity: 1,
        isCustom: isCustom,
        customSelections: selections ?? {},
      ));
    }
    _unreadNotifications++;
    _notifications.insert(0, "🛍️ Added '${product.title}' to your shopping cart!");
    notifyListeners();
  }

  void addCustomQuoteToCart(Quote quote) {
    // Create a mock product from the quote
    final product = Product(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      title: quote.title,
      category: 'Custom Concierge',
      price: quote.price,
      rating: 5.0,
      reviewsCount: 1,
      imageUrl: quote.mockupImage,
      description: 'Custom handcrafted item tailored by your Grafti Concierge.',
      isCustomizable: true,
      options: [],
    );

    _cart.add(CartItem(
      product: product,
      quantity: 1,
      isCustom: true,
      customSelections: {'Tailored': 'Yes'},
    ));
    _unreadNotifications++;
    _notifications.insert(0, "✨ Staged bespoke custom quote added to cart!");
    notifyListeners();
  }

  void removeFromCart(CartItem item) {
    _cart.remove(item);
    notifyListeners();
  }

  void updateCartQuantity(CartItem item, int change) {
    item.quantity += change;
    if (item.quantity <= 0) {
      _cart.remove(item);
    }
    notifyListeners();
  }

  bool applyVoucher(String code) {
    if (code.toUpperCase() == 'WELCOME25') {
      _voucherCode = code;
      notifyListeners();
      return true;
    }
    return false;
  }

  void removeVoucher() {
    _voucherCode = '';
    notifyListeners();
  }

  // API Call: Concierge AI Message
  Future<void> sendConciergeMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Add user message
    _chatMessages.add(ChatMessage(
      sender: 'user',
      text: text,
      timestamp: DateTime.now(),
    ));
    _isChatLoading = true;
    notifyListeners();

    try {
      final messagesPayload = _chatMessages
          .map((m) => {'sender': m.sender, 'text': m.text})
          .toList();

      final response = await http.post(
        Uri.parse('$baseUrl/api/concierge'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'messages': messagesPayload}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          Quote? quote;
          if (data['hasQuote'] == true && data['quote'] != null) {
            quote = Quote.fromJson(data['quote']);
          }

          _chatMessages.add(ChatMessage(
            sender: 'concierge',
            text: data['reply'] ?? '',
            timestamp: DateTime.now(),
            quote: quote,
          ));

          if (quote != null) {
            _unreadNotifications++;
            _notifications.insert(0, "🎨 Concierge designed a new mockup: ${quote.title}!");
          }
        }
      }
    } catch (e) {
      print('Concierge API error: $e. Using offline simulator.');
      // Local simulator fallback
      await Future.delayed(const Duration(seconds: 1));
      String replyText = "I see you're typing: '$text'. I'm currently in local preview mode. Mention 'card' or 'crochet' for offline demo quote cards!";
      Quote? quote;

      final query = text.toLowerCase();
      if (query.contains('card') || query.contains('greeting')) {
        replyText = "Here is an offline simulation of your custom Pop-up greeting card!";
        quote = Quote(
          title: 'Custom Pop-up Card (Offline Demo)',
          price: 185.0,
          mockupImage: '/images/product_card.jpg',
          breakdown: [
            QuoteBreakdown(label: 'Standard card base', cost: 15.0),
            QuoteBreakdown(label: 'Detailed floral papercuts', cost: 120.0),
            QuoteBreakdown(label: 'Hand lettering personalization', cost: 50.0),
          ],
        );
      } else if (query.contains('crochet') || query.contains('wizard')) {
        replyText = "Here is an offline simulation of your customized crochet wizard doll!";
        quote = Quote(
          title: 'Personalized Crochet Wizard Doll (Offline Demo)',
          price: 95.0,
          mockupImage: '/images/product_crochet.jpg',
          breakdown: [
            QuoteBreakdown(label: 'Crochet base model', cost: 28.5),
            QuoteBreakdown(label: 'Custom dye palette', cost: 46.5),
            QuoteBreakdown(label: 'Initial stitching', cost: 20.0),
          ],
        );
      }

      _chatMessages.add(ChatMessage(
        sender: 'concierge',
        text: replyText,
        timestamp: DateTime.now(),
        quote: quote,
      ));
    } finally {
      _isChatLoading = false;
      notifyListeners();
    }
  }

  // API Call: Checkout / Process Payment
  Future<Map<String, dynamic>> checkout({required String address, required String paymentMethod}) async {
    final payloadItems = _cart
        .map((item) => {
              'id': item.product.id,
              'price': item.product.price,
              'quantity': item.quantity,
              'isCustom': item.isCustom,
            })
        .toList();

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/checkout'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'items': payloadItems,
          'address': address,
          'paymentMethod': paymentMethod,
          'voucherCode': _voucherCode,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          // Success checkout clears cart
          _cart.clear();
          _voucherCode = '';
          _unreadNotifications++;
          _notifications.insert(0, "💳 Payment success! Your order ${data['order']['orderId']} is completed!");
          notifyListeners();
          return {'success': true, 'order': data['order']};
        }
      }
    } catch (e) {
      print('Checkout API error: $e. Simulating local success checkout.');
    }

    // Local checkout success fallback
    final mockOrderId = 'ord_offline_${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
    _cart.clear();
    _voucherCode = '';
    _unreadNotifications++;
    _notifications.insert(0, "💳 Simulated offline payment success! Order ID: $mockOrderId");
    notifyListeners();
    return {
      'success': true,
      'order': {
        'orderId': mockOrderId,
        'total': cartTotal,
        'status': 'completed',
      }
    };
  }
}
