import 'dart:async';
import 'package:flutter/material.dart';
import '../../../model/things_model.dart';
import '../../../repository/things_repository.dart';
import 'appBar/new_custom_app_bar.dart';
import 'things_card_item.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key, required this.repository}) : super(key: key);
  final ThingsRepositoryI repository;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final StreamController<String> _searchStreamController =
      StreamController<String>();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      _searchStreamController.add(_searchController.text.toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    _searchStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: NewCustomAppBar(
        showSearchIcon: false,
        controller: _searchController,
        focusNode: _focusNode,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      focusNode: _focusNode,
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        hintText: 'WHAT ARE YOU LOOKING FOR?',
                        hintStyle: TextStyle(
                          color:
                              isDarkMode ? Colors.grey[400] : Colors.grey[700],
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color:
                              isDarkMode ? Colors.grey[400] : Colors.grey[700],
                        ),
                        filled: true,
                        fillColor: isDarkMode ? Colors.grey[900] : Colors.white,
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: StreamBuilder<String>(
                  stream: _searchStreamController.stream,
                  builder: (context, searchSnapshot) {
                    final searchQuery = searchSnapshot.data ?? '';

                    return StreamBuilder<List<ThingsModel>>(
                      stream:
                          widget.repository.searchThingsByTitle(searchQuery),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(
                              child: Text('No items match your search.'));
                        }

                        final items = snapshot.data!
                            .where((item) => item.title.trim().isNotEmpty)
                            .toList();

                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            final item = items[index];
                            return ThingsCardWidget(
                              itemId: item.id,
                              title: item.title,
                              description: item.description,
                              type: item.type,
                              imageUrl: item.imageUrl,
                              onStateUpdate: () {},
                              quantity: item.quantity,
                              allTypes: const [],
                              location: item.location ?? '',
                              weight: item.weight ?? 0.0,
                              colorText: item.colorText ?? '',
                              importance: item.importance ?? 0,
                              favorites: item.favorites,
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
