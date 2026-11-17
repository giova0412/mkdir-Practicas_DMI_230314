import 'package:flutter/material.dart';

class InfiniteScrollScreen extends StatefulWidget {
  static const String name = 'infinite_screen';

  const InfiniteScrollScreen({super.key});

  @override
  State<InfiniteScrollScreen> createState() => _InfiniteScrollScreenState();
}

class _InfiniteScrollScreenState extends State<InfiniteScrollScreen> {
  final ScrollController scrollController = ScrollController();
  final List<int> ids = List.generate(10, (i) => i + 1);

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      final maxScroll = scrollController.position.maxScrollExtent;
      final actual = scrollController.position.pixels;
      if (actual > maxScroll - 300) {
        agregarImagenes();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void agregarImagenes() {
    final ultimo = ids.last;
    setState(() {
      ids.addAll([ultimo + 1, ultimo + 2, ultimo + 3]);
    });
  }

  Future<void> recargar() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      ids
        ..clear()
        ..addAll(List.generate(10, (i) => i + 1));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scroll infinito'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: recargar,
        child: ListView.builder(
          controller: scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: ids.length,
          itemBuilder: (context, index) {
            final id = ids[index];
            return Image.network(
              'https://picsum.photos/id/$id/500/300',
              height: 300,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return const SizedBox(
                  height: 300,
                  child: Center(child: CircularProgressIndicator()),
                );
              },
              errorBuilder: (context, error, stackTrace) => Container(
                height: 300,
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: const Center(child: Icon(Icons.image_not_supported)),
              ),
            );
          },
        ),
      ),
    );
  }
}
