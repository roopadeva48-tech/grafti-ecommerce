class User {
  final String id;
  final String email;
  final String name;
  final String accountType;
  final String avatarUrl;
  final String phoneNumber;
  final String paymentMode;
  final String location;
  final String deliveryAddress;
  final String token;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.accountType,
    required this.avatarUrl,
    required this.phoneNumber,
    required this.paymentMode,
    required this.location,
    required this.deliveryAddress,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      accountType: json['accountType'] ?? 'customer',
      avatarUrl: json['avatarUrl'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      paymentMode: json['paymentMode'] ?? '',
      location: json['location'] ?? '',
      deliveryAddress: json['deliveryAddress'] ?? '',
      token: json['token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'accountType': accountType,
      'avatarUrl': avatarUrl,
      'phoneNumber': phoneNumber,
      'paymentMode': paymentMode,
      'location': location,
      'deliveryAddress': deliveryAddress,
      'token': token,
    };
  }
}

class Product {
  final String id;
  final String title;
  final String category;
  final double price;
  final double rating;
  final int reviewsCount;
  final String imageUrl;
  final String description;
  final bool isCustomizable;
  final List<String> options;

  Product({
    required this.id,
    required this.title,
    required this.category,
    required this.price,
    required this.rating,
    required this.reviewsCount,
    required this.imageUrl,
    required this.description,
    required this.isCustomizable,
    required this.options,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewsCount: json['reviewsCount'] ?? 0,
      imageUrl: json['imageUrl'] ?? '',
      description: json['description'] ?? '',
      isCustomizable: json['isCustomizable'] ?? false,
      options: List<String>.from(json['options'] ?? []),
    );
  }
}

class CartItem {
  final Product product;
  int quantity;
  final bool isCustom;
  final Map<String, String> customSelections;

  CartItem({
    required this.product,
    this.quantity = 1,
    this.isCustom = false,
    required this.customSelections,
  });
}

class QuoteBreakdown {
  final String label;
  final double cost;

  QuoteBreakdown({required this.label, required this.cost});

  factory QuoteBreakdown.fromJson(Map<String, dynamic> json) {
    return QuoteBreakdown(
      label: json['label'] ?? '',
      cost: (json['cost'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class Quote {
  final String title;
  final double price;
  final String mockupImage;
  final List<QuoteBreakdown> breakdown;

  Quote({
    required this.title,
    required this.price,
    required this.mockupImage,
    required this.breakdown,
  });

  factory Quote.fromJson(Map<String, dynamic> json) {
    var breakdownList = json['breakdown'] as List? ?? [];
    return Quote(
      title: json['title'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      mockupImage: json['mockupImage'] ?? '',
      breakdown: breakdownList.map((item) => QuoteBreakdown.fromJson(item)).toList(),
    );
  }
}

class ChatMessage {
  final String sender; // 'user' or 'concierge'
  final String text;
  final DateTime timestamp;
  final Quote? quote;

  ChatMessage({
    required this.sender,
    required this.text,
    required this.timestamp,
    this.quote,
  });
}
