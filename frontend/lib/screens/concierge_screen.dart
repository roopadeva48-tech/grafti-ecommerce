import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/grafti_provider.dart';
import '../theme/grafti_theme.dart';
import '../models/models.dart';

class ConciergeScreen extends StatefulWidget {
  const ConciergeScreen({super.key});

  @override
  State<ConciergeScreen> createState() => _ConciergeScreenState();
}

class _ConciergeScreenState extends State<ConciergeScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // Helper to extract the latest generated custom quote from the chat history
  Quote? _getLatestQuote(List<ChatMessage> messages) {
    for (var msg in messages.reversed) {
      if (msg.quote != null) {
        return msg.quote;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GraftiProvider>(context);
    final messages = provider.chatMessages;
    final latestQuote = _getLatestQuote(messages);

    final isDesktop = MediaQuery.of(context).size.width >= 768;

    return Scaffold(
      backgroundColor: GraftiTheme.surfaceBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Row(
          children: [
            ClipOval(
              child: Image.network(
                '${provider.baseUrl}/images/avatar_concierge.jpg',
                width: 36,
                height: 36,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.support_agent),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Craft Concierge',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: GraftiTheme.darkPlum),
                ),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(color: Color(0xFF4CAF50), shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 4),
                    const Text('Online', style: TextStyle(fontSize: 11, color: GraftiTheme.mutedText)),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_outlined, color: GraftiTheme.darkPlum),
            onPressed: () {
              provider.chatMessages.clear();
              provider.chatMessages.add(ChatMessage(
                sender: 'concierge',
                text: "Hi! I am your Craft Concierge. I specialize in designing and tailoring premium, one-of-a-kind handmade gifts. Just tell me what you want to customize (e.g. try asking for a 'card' or 'crochet wizard')!",
                timestamp: DateTime.now(),
              ));
              setState(() {});
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: isDesktop
            ? Row(
                children: [
                  // Left Side: Staged Mockup & Active Quote
                  Expanded(
                    flex: 4,
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(right: BorderSide(color: GraftiTheme.softLilac)),
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Staged Bespoke Customization',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: GraftiTheme.darkPlum),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Below is the active rendering of the mockup generated from your conversation.',
                            style: TextStyle(fontSize: 12, color: GraftiTheme.mutedText),
                          ),
                          const SizedBox(height: 24),
                          Expanded(
                            child: latestQuote == null
                                ? _buildEmptyQuoteState()
                                : SingleChildScrollView(
                                    child: _buildDesktopQuotePanel(context, latestQuote, provider),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Right Side: Chat thread
                  Expanded(
                    flex: 5,
                    child: _buildChatThread(provider, messages, isDesktop),
                  ),
                ]
              )
            : _buildChatThread(provider, messages, isDesktop),
      ),
    );
  }

  Widget _buildEmptyQuoteState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.brush_outlined, size: 64, color: GraftiTheme.softLilac.withOpacity(0.5)),
          const SizedBox(height: 16),
          const Text(
            'No customization active yet',
            style: TextStyle(fontWeight: FontWeight.bold, color: GraftiTheme.darkPlum),
          ),
          const SizedBox(height: 6),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              'Tell our AI Craft Concierge details (like name and theme) for a "greeting card" or "crochet doll" to initialize a quote mockup!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: GraftiTheme.mutedText),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatThread(GraftiProvider provider, List<ChatMessage> messages, bool isDesktop) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];
              final isUser = message.sender == 'user';

              return Column(
                children: [
                  Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * (isDesktop ? 0.45 : 0.75),
                      ),
                      decoration: BoxDecoration(
                        color: isUser ? GraftiTheme.primaryPink : Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(20),
                          topRight: const Radius.circular(20),
                          bottomLeft: isUser ? const Radius.circular(20) : Radius.zero,
                          bottomRight: isUser ? Radius.zero : const Radius.circular(20),
                        ),
                        boxShadow: GraftiTheme.softShadow,
                        border: Border.all(
                          color: isUser ? Colors.transparent : GraftiTheme.softLilac,
                        ),
                      ),
                      child: Text(
                        message.text,
                        style: TextStyle(
                          color: isUser ? Colors.white : GraftiTheme.plumDarkText,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),

                  // On Mobile: Render inline quote card, On Desktop: Rendered in Left Panel
                  if (!isDesktop && !isUser && message.quote != null) ...[
                    const SizedBox(height: 8),
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeOutBack,
                      builder: (context, val, child) {
                        return Transform.translate(
                          offset: Offset(0, 50 * (1 - val)),
                          child: Opacity(opacity: val, child: child),
                        );
                      },
                      child: _buildInlineQuoteCard(context, message.quote!, provider),
                    ),
                    const SizedBox(height: 12),
                  ],
                ],
              );
            },
          ),
        ),

        if (provider.isChatLoading)
          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2, color: GraftiTheme.primaryPink),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Concierge is designing...',
                    style: TextStyle(fontSize: 12, color: GraftiTheme.mutedText, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          ),

        // Input Field Panel
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: GraftiTheme.softLilac)),
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('📸 Selected mockup attachment: flower_reference.jpg')),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: GraftiTheme.secondaryPastelPink, shape: BoxShape.circle),
                  child: const Icon(Icons.add_photo_alternate_outlined, color: GraftiTheme.darkPlum, size: 22),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: GraftiTheme.surfaceBackground,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: GraftiTheme.softLilac),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: _messageController,
                    onSubmitted: (val) {
                      if (val.trim().isNotEmpty) {
                        provider.sendConciergeMessage(val);
                        _messageController.clear();
                        _scrollToBottom();
                      }
                    },
                    decoration: const InputDecoration(
                      hintText: 'Type message (e.g. card, crochet)...',
                      hintStyle: TextStyle(color: GraftiTheme.mutedText, fontSize: 13),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () {
                  final val = _messageController.text;
                  if (val.trim().isNotEmpty) {
                    provider.sendConciergeMessage(val);
                    _messageController.clear();
                    _scrollToBottom();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(color: GraftiTheme.primaryPink, shape: BoxShape.circle),
                  child: const Icon(Icons.send, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
        ),
        if (!isDesktop) const SizedBox(height: 72), // Mobile nav offset
      ],
    );
  }

  Widget _buildInlineQuoteCard(BuildContext context, Quote quote, GraftiProvider provider) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: GraftiTheme.softShadow,
        border: Border.all(color: GraftiTheme.softLilac),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
            child: SizedBox(
              height: 140,
              width: double.infinity,
              child: Image.network('${provider.baseUrl}${quote.mockupImage}', fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(quote.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    ),
                    Text('\$${quote.price.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, color: GraftiTheme.primaryPink)),
                  ],
                ),
                const Divider(color: GraftiTheme.softLilac, height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => provider.addCustomQuoteToCart(quote),
                    child: const Text('Add to Cart', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopQuotePanel(BuildContext context, Quote quote, GraftiProvider provider) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: GraftiTheme.softLilac),
        boxShadow: GraftiTheme.softShadow,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 240,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  '${provider.baseUrl}${quote.mockupImage}',
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, _, __) => Container(color: GraftiTheme.secondaryPastelPink),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: GraftiTheme.darkPlum.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.brush, size: 12, color: Colors.white),
                        SizedBox(width: 6),
                        Text(
                          'Live Mockup Render',
                          style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  quote.title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: GraftiTheme.plumDarkText),
                ),
                const SizedBox(height: 8),
                Text(
                  'Staged custom craft mockup with active billing breakdown:',
                  style: TextStyle(fontSize: 12, color: GraftiTheme.mutedText),
                ),
                const SizedBox(height: 16),
                const Divider(color: GraftiTheme.softLilac),
                const SizedBox(height: 8),
                ...quote.breakdown.map((item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('• ${item.label}', style: const TextStyle(fontSize: 13, color: GraftiTheme.plumDarkText)),
                          Text('\$${item.cost.toStringAsFixed(2)}', style: const TextStyle(fontSize: 13, color: GraftiTheme.mutedText)),
                        ],
                      ),
                    )),
                const Divider(color: GraftiTheme.softLilac, height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Budget Quote', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    Text('\$${quote.price.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: GraftiTheme.primaryPink)),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      provider.addCustomQuoteToCart(quote);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('"${quote.title}" added to shopping cart!')),
                      );
                    },
                    child: const Text('Add Bespoke Craft to Cart', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
