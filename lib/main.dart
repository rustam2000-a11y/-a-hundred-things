import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:one_hundred_things/presentation/colors.dart';
import 'generated/l10n.dart';
import 'module/login/login_page.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;
  final FlutterLocalization localization = FlutterLocalization.instance;

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firestore Demo',
      theme: ThemeData(
        fontFamily: 'Roboto',
        primarySwatch: Colors.blue,
        primaryColor: AppColors.silverColor,
        scaffoldBackgroundColor: AppColors.silverColor,
        appBarTheme: AppBarTheme(color: AppColors.royalBlue),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style:
              ElevatedButton.styleFrom(backgroundColor: AppColors.silverColor),
        ),
      ),
       supportedLocales: S.delegate.supportedLocales,
      localizationsDelegates: [
       ...localization.localizationsDelegates,
        S.delegate
      ],
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      home: AuthCheck(toggleTheme: _toggleTheme),
    );
  }
}

class AuthCheck extends StatelessWidget {
  final VoidCallback toggleTheme;

  const AuthCheck({super.key, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          if (user == null) {
            return LoginPage(toggleTheme: toggleTheme);
          } else {
            return MyHomePage(toggleTheme: toggleTheme);
          }
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}



class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width; // Ширина экрана
    final screenHeight = MediaQuery.of(context).size.height; // Высота экрана
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      // Фон зависит от темы
      body: Padding(
        padding: EdgeInsets.only(
          top: screenHeight * 0.05, // Отступ сверху 5% от высоты экрана
          left: screenWidth * 0.05, // Отступ слева 5% от ширины экрана
          right: screenWidth * 0.05, // Отступ справа 5% от ширины экрана
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            Text(
              "Забыли пароль?",
              style: TextStyle(
                fontSize: screenWidth * 0.07,
                // Размер шрифта зависит от ширины экрана
                fontWeight: FontWeight.bold, // Толстый шрифт
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            // Отступ между текстом и следующим элементом
            Text(
              "Пожалуйста, введите свой адрес электронной почты для сброса пароля",
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                // Размер шрифта зависит от ширины экрана
                fontWeight: FontWeight.normal, // Обычный шрифт
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            // Отступ перед текстфилдом
            Text("Введите почту"),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            // Отступ перед кнопкой
            ElevatedButton(
              onPressed: () async {
                final email = _emailController.text.trim();

                if (email.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Введите ваш email")),
                  );
                  return;
                }

                try {
                  // Отправка запроса на восстановление пароля
                  await FirebaseAuth.instance
                      .sendPasswordResetEmail(email: email);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            "Ссылка для сброса пароля отправлена на ваш email")),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Ошибка: $e")),
                  );
                }
              },
              child: Text("Отправить запрос"),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(screenWidth * 0.9, 50),
                // Кнопка займет 90% ширины экрана
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final VoidCallback toggleTheme;

  const MyHomePage({super.key, required this.toggleTheme});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  List<String> _selectedItems = [];
  final ValueNotifier<List<String>> _selectedItemsNotifier = ValueNotifier([]);
  String? _selectedCategoryType;
  String _searchQuery = '';

  Future<void> _deleteSelectedItems() async {
    try {
      for (String itemId in _selectedItemsNotifier.value) {
        await FirebaseFirestore.instance
            .collection('item')
            .doc(itemId)
            .delete();
      }
      setState(() {
        _selectedItemsNotifier.value = [];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Выбранные элементы удалены')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка при удалении элементов: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(
              top: screenHeight * 0.07,
              left: screenWidth * 0.05,
              right: screenWidth * 0.05,
              bottom: screenHeight * 0.05,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: Theme.of(context).primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: screenWidth * 0.10,
                      height: screenWidth * 0.08,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[300],
                      ),
                      child: Center(
                        child: Image.asset(
                          'assets/logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          width: screenWidth * 0.08,
                          height: screenWidth * 0.08,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.brightness_6, color: Colors.black),
                            onPressed: widget.toggleTheme,
                          ),
                        ),
                        SizedBox(width: 10),
                        Container(
                          width: screenWidth * 0.08,
                          height: screenWidth * 0.08,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: IconButton(
                            icon:
                                Icon(Icons.search_rounded, color: Colors.black),
                            onPressed: _showSearchBottomSheet,
                          ),
                        ),
                        SizedBox(width: 10),
                        Container(
                          width: screenWidth * 0.08,
                          height: screenWidth * 0.08,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.more_vert, color: Colors.black),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute<dynamic>(
                                  builder: (context) => UserProfileScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 60),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('item')
                      .where('userId',
                          isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return SizedBox();

                    final itemCount = snapshot.data!.docs.length;
                    final progress = (itemCount / 100).clamp(0.0, 1.0);
                    final progressColor =
                        itemCount <= 55 ? Colors.blue : Colors.red;

                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            height: 15,
                            child: LinearProgressIndicator(
                              value: progress,
                              backgroundColor: Colors.grey[300],
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(progressColor),
                            ),
                          ),
                        ),
                        Positioned(
                          left: progress * (screenWidth * 0.85) - 10,
                          top: -25,
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.royalBlue,
                                ),
                                child: Text(
                                  '$itemCount%',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                width: 23,
                                height: 23,
                                decoration: BoxDecoration(
                                  color: progressColor,
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: screenHeight * 0.03,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(
              S.of(context).or,
              style: TextStyle(fontSize: 24),
            ),
          ),
          SizedBox(
            height: screenHeight * 0.02,
          ),
          Container(
            height: 50,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('item')
                  .where('userId',
                      isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No items found.'));
                }

                final items = snapshot.data!.docs;
                final types = items
                    .map((item) => item['type'] as String)
                    .toSet()
                    .toList();

                return ListView.builder(
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.horizontal,
                  itemCount: types.length,
                  itemBuilder: (context, index) {
                    return _buildCategoryButton(types[index]);
                  },
                );
              },
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.02,
                vertical: screenHeight * 0.02,
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('item')
                    .where('userId',
                        isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No items found.'));
                  }

                  final items = snapshot.data!.docs.where((item) {
                    if (_selectedCategoryType == null) return true;
                    return item['type'] == _selectedCategoryType;
                  }).toList();

                  if (items.isEmpty) {
                    return Center(
                        child: Text('No items found for selected category.'));
                  }

                  return ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return _buildCardItem(
                        itemId: item.id,
                        title: item['title'],
                        description: item['description'],
                        type: item['type'],
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: ValueListenableBuilder<List<String>>(
        valueListenable: _selectedItemsNotifier,
        builder: (context, selectedItems, child) {
          return selectedItems.isNotEmpty
              ? FloatingActionButton.extended(
                  onPressed: _deleteSelectedItems,
                  label: Text('Удалить выбранные'),
                  icon: Icon(Icons.delete),
                  backgroundColor: Colors.redAccent,
                )
              : FloatingActionButton(
                  onPressed: _showAddItemBottomSheet,
                  child: Icon(Icons.add),
                  backgroundColor: Colors.blueAccent,
                );
        },
      ),
    );
  }

  Widget _buildCategoryButton(String type) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_selectedCategoryType == type) {
            _selectedCategoryType = null;
          } else {
            _selectedCategoryType = type;
          }
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: _selectedCategoryType == type
                ? Colors.blueAccent
                : AppColors.silverColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              type,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardItem({
    required String itemId,
    required String title,
    required String description,
    required String type,
  }) {
    return ValueListenableBuilder<List<String>>(
      valueListenable: _selectedItemsNotifier,
      builder: (context, selectedItems, child) {
        bool isSelected = selectedItems.contains(itemId);

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) {
                  final screenHeight = MediaQuery.of(context).size.height;
                  final screenWidth = MediaQuery.of(context).size.width;

                  return SafeArea(
                    child: SingleChildScrollView(
                      child: Container(
                        height: screenHeight,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              height: screenHeight * 0.6,
                              width: double.infinity,
                              color: Colors.deepPurpleAccent[200],
                            ),
                            Positioned(
                              top: screenHeight * 0.05,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Text(
                                  'Тип: $type',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenWidth * 0.05,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              top: screenHeight * 0.55,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: screenHeight * 0.50,
                                padding: EdgeInsets.all(screenWidth * 0.05),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      spreadRadius: 3,
                                      blurRadius: 5,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Название:',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      title,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    SizedBox(height: screenHeight * 0.02),
                                    Text(
                                      'Описание:',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      description,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.blueAccent,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                    vertical: screenHeight * 0.02),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(content: Text('Добавлено')),
                                        );
                                      },
                                      child: Text(
                                        "Добавить",
                                        style: TextStyle(
                                            fontSize: screenWidth * 0.04),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        try {
                                          await FirebaseFirestore.instance
                                              .collection('item')
                                              .doc(itemId)
                                              .delete();
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                    'Item deleted successfully')),
                                          );
                                        } catch (e) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                                content: Text('Error: $e')),
                                          );
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                      ),
                                      child: Text(
                                        S.of(context).delete,
                                        style: TextStyle(
                                            fontSize: screenWidth * 0.04),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            onLongPress: () {
              if (isSelected) {
                _selectedItemsNotifier.value =
                    List.from(_selectedItemsNotifier.value)..remove(itemId);
              } else {
                _selectedItemsNotifier.value =
                    List.from(_selectedItemsNotifier.value)..add(itemId);
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.silverColor,
                borderRadius: BorderRadius.circular(20),
                border: isSelected
                    ? Border.all(color: Colors.blueAccent, width: 2)
                    : null,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey[300],
                      ),
                      child: Center(
                        child: Icon(Icons.image,
                            size: 40, color: Colors.grey[600]),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  title,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  if (isSelected)
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                  if (!isSelected)
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.edit,
                                              color: Colors.black),
                                          onPressed: () {
                                            _showEditItemBottomSheet(
                                              context,
                                              itemId: itemId,
                                              initialTitle: title,
                                              initialDescription: description,
                                              initialType: type,
                                            );
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.close,
                                              color: Colors.black),
                                          onPressed: () async {
                                            try {
                                              await FirebaseFirestore.instance
                                                  .collection('item')
                                                  .doc(itemId)
                                                  .delete();
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        'Item deleted successfully')),
                                              );
                                            } catch (e) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                    content: Text('Error: $e')),
                                              );
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ],
                          ),
                          Text(
                            description.length > 20
                                ? '${description.substring(0, 20)}...'
                                : description,
                            style: TextStyle(color: Colors.black),
                          ),
                          SizedBox(height: 8),
                          Text(
                            type,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showSearchBottomSheet() {
    final StreamController<String> _searchStreamController =
        StreamController<String>();

    _searchController.addListener(() {
      _searchStreamController.add(_searchController.text.toLowerCase());
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        final screenHeight = MediaQuery.of(context).size.height;
        final screenWidth = MediaQuery.of(context).size.width;

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            height: screenHeight * 0.8,
            padding: EdgeInsets.all(screenWidth * 0.05),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by title...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: StreamBuilder<String>(
                    stream: _searchStreamController.stream,
                    builder: (context, searchSnapshot) {
                      final searchQuery = searchSnapshot.data ?? '';

                      return StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('item')
                            .where('userId',
                                isEqualTo:
                                    FirebaseAuth.instance.currentUser?.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          }
                          if (!snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return Center(child: Text('No items found.'));
                          }

                          final items = snapshot.data!.docs.where((item) {
                            final title = item['title'] as String;
                            return title.toLowerCase().contains(searchQuery);
                          }).toList();

                          if (items.isEmpty) {
                            return Center(
                                child: Text('No items match your search.'));
                          }

                          return ListView.builder(
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final item = items[index];
                              return _buildCardItem(
                                itemId: item.id,
                                title: item['title'],
                                description: item['description'],
                                type: item['type'],
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
        );
      },
    ).whenComplete(() {
      _searchStreamController
          .close(); // Close the stream when the bottom sheet is dismissed
    });
  }

  // Функция для отображения bottom sheet при нажатии на кнопку "Добавить"
  void _showAddItemBottomSheet() {
    final TextEditingController _titleController = TextEditingController();
    final TextEditingController _descriptionController =
        TextEditingController();
    final TextEditingController _typeController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        final screenHeight = MediaQuery.of(context).size.height;
        final screenWidth = MediaQuery.of(context).size.width;

        return SafeArea(
          child: SingleChildScrollView(
            child: Container(
              height: screenHeight,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Верхний контейнер для изображения
                  Container(
                    height: screenHeight * 0.6,
                    width: double.infinity,
                    color: Colors.deepPurpleAccent[200],
                    child: Center(
                      child: Container(
                        width: screenWidth * 0.5,
                        height: screenWidth * 0.5,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius:
                              BorderRadius.circular(20), // Закругленные углы
                        ),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: screenWidth * 0.15, // Увеличиваем размер иконки
                        ),
                      ),
                    ),
                  ),

                  // Текстовое поле без контура поверх контейнера с изображением
                  Positioned(
                    top: screenHeight * 0.05, // Позиционируем в верхней части
                    left: 0,
                    right: 0,
                    child: Center(
                      child: TextField(
                        controller: _typeController,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: "Тип", // Подсказка текста
                          border: InputBorder.none, // Убираем контур
                        ),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.05,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // Контейнер для текстовых полей
                  Positioned(
                    top: screenHeight * 0.55,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: screenHeight * 0.50,
                      padding: EdgeInsets.all(screenWidth * 0.05),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 3,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          TextField(
                            controller: _titleController,
                            decoration: InputDecoration(
                              labelText: "Название предмета",
                              border: InputBorder.none, // Убираем контур
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),
                          TextField(
                            controller: _descriptionController,
                            decoration: InputDecoration(
                              labelText: "Описание предмета",
                              border: InputBorder.none, // Убираем контур
                            ),
                            style: TextStyle(fontSize: screenWidth * 0.045),
                            maxLines: 4,
                            minLines: 1,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Контейнер для кнопок, прикрепленный к нижней части экрана
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              if (_titleController.text.isNotEmpty &&
                                  _descriptionController.text.isNotEmpty &&
                                  _typeController.text.isNotEmpty) {
                                try {
                                  // Добавляем данные в коллекцию Firestore
                                  await FirebaseFirestore.instance
                                      .collection('item')
                                      .add({
                                    'title': _titleController.text,
                                    'description': _descriptionController.text,
                                    'type': _typeController.text,
                                    'userId':
                                        FirebaseAuth.instance.currentUser?.uid,
                                    'timestamp': Timestamp.now(),
                                  });
                                  // Закрываем bottom sheet и показываем сообщение об успехе
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text('Item added successfully')),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Error: $e")),
                                  );
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("Please fill all fields")),
                                );
                              }
                            },
                            child: Text(
                              "Добавить",
                              style: TextStyle(fontSize: screenWidth * 0.04),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Отмена",
                              style: TextStyle(fontSize: screenWidth * 0.04),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

void _showEditItemBottomSheet(
  BuildContext context, {
  required String itemId,
  required String initialTitle,
  required String initialDescription,
  required String initialType,
}) {
  final TextEditingController _titleController =
      TextEditingController(text: initialTitle);
  final TextEditingController _descriptionController =
      TextEditingController(text: initialDescription);
  final TextEditingController _typeController =
      TextEditingController(text: initialType);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context) {
      final screenHeight = MediaQuery.of(context).size.height;
      final screenWidth = MediaQuery.of(context).size.width;

      return SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: screenHeight,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Верхний контейнер для изображения
                Container(
                  height: screenHeight * 0.6,
                  width: double.infinity,
                  color: Colors.deepPurpleAccent[200],
                  child: Center(
                    child: Container(
                      width: screenWidth * 0.5,
                      height: screenWidth * 0.5,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: screenWidth * 0.15,
                      ),
                    ),
                  ),
                ),

                // Поле для ввода типа
                Positioned(
                  top: screenHeight * 0.05,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: TextField(
                      controller: _typeController,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: "Тип",
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.05,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // Контейнер для текстовых полей
                Positioned(
                  top: screenHeight * 0.55,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: screenHeight * 0.50,
                    padding: EdgeInsets.all(screenWidth * 0.05),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 3,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            labelText: "Название предмета",
                            border: InputBorder.none,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        TextField(
                          controller: _descriptionController,
                          decoration: InputDecoration(
                            labelText: "Описание предмета",
                            border: InputBorder.none,
                          ),
                          style: TextStyle(fontSize: screenWidth * 0.045),
                          maxLines: 4,
                          minLines: 1,
                        ),
                      ],
                    ),
                  ),
                ),

                // Контейнер для кнопок сохранения и отмены
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    padding:
                        EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            if (_titleController.text.isNotEmpty &&
                                _descriptionController.text.isNotEmpty &&
                                _typeController.text.isNotEmpty) {
                              try {
                                // Обновляем существующий документ в Firestore
                                await FirebaseFirestore.instance
                                    .collection('item')
                                    .doc(itemId)
                                    .update({
                                  'title': _titleController.text,
                                  'description': _descriptionController.text,
                                  'type': _typeController.text,
                                  'timestamp': Timestamp.now(),
                                });
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('Item updated successfully')),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error: $e')),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text('Please fill all fields')),
                              );
                            }
                          },
                          child: Text(
                            "Сохранить",
                            style: TextStyle(fontSize: screenWidth * 0.04),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Отмена",
                            style: TextStyle(fontSize: screenWidth * 0.04),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  String _selectedTheme = 'Light'; // Начальное значение для выбора темы
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double spacing = screenHeight * 0.01; // Отступы между элементами
    final double horizontalPadding =
        MediaQuery.of(context).size.width * 0.06; // Горизонтальные отступы

    // Получение текущего аутентифицированного пользователя
    User? currentUser = FirebaseAuth.instance.currentUser;
    String userEmail = currentUser?.email ?? 'Неизвестный пользователь';

    return Scaffold(
      body: Stack(
        children: [
          // Фоновый контейнер, занимающий весь экран
          Container(
            width: double.infinity,
            height: double.infinity,
            color: AppColors.silverColor, // Цвет фона
          ),
          // Верхний контейнер
          Container(
            width: double.infinity,
            color: AppColors.silverColor,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start, // Иконка слева
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(
                              context); // Действие при нажатии — возвращение назад
                        },
                        icon: Icon(Icons.arrow_back), // Иконка "назад"
                        color: Colors.white,
                      ),
                    ],
                  ),

                  // Опускаем содержимое на несколько пикселей вниз
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Контейнер 50x50 с одной стороны
                      Container(
                        width: 50,
                        height: 50,
                        color:
                            Colors.white, // Замените на нужный цвет или виджет
                      ),
                      // Иконка настроек с другой стороны
                      IconButton(
                        icon: Icon(Icons.settings, color: Colors.white),
                        iconSize: 38,
                        onPressed: () async {
                          try {
                            await FirebaseAuth.instance.signOut();
                            await Navigator.push(
                              context,
                              MaterialPageRoute<dynamic>(
                                builder: (context) => LoginPage(
                                  toggleTheme: () {
                                    // Логика переключения темы
                                  },
                                ),
                              ),
                            );
                          } catch (e) {
                            // Обработка ошибок, если нужно
                            print('Ошибка при выходе: $e');
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.15,
            // Слегка наслаивается на верхний контейнер
            left: 0,
            right: 0,
            child: Container(
              width: double.infinity,
              height: screenHeight * 0.9,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: spacing),
                      child: Row(
                        children: [
                          // Аватарка
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: AssetImage(
                                'assets/avatar.png'), // Замените на изображение пользователя
                          ),
                          SizedBox(width: 16),
                          // Почта пользователя
                          Expanded(
                            child: Text(
                              userEmail,
                              // Отображение почты аутентифицированного пользователя
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: spacing),
                      child: Divider(),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: spacing),
                      child: Text(
                        'Настройки учетной записи',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: spacing),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('Редактировать профиль'),
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<dynamic>(builder: (context) => Account()),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: spacing),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('Язык приложения'),
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          // Действие при нажатии
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: spacing),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('Push-уведомления'),
                        trailing: Switch(
                          value: true,
                          // Замените на переменную, чтобы управлять состоянием
                          onChanged: (bool value) {
                            // Действие при переключении
                          },
                        ),
                        onTap: () {
                          // Действие при нажатии на весь элемент (если нужно)
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: spacing),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('Тема'),
                        trailing: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 4.0),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: DropdownButton<String>(
                            value: _selectedTheme,
                            icon: Icon(Icons.arrow_drop_down),
                            underline: SizedBox(),
                            // Убираем стандартную линию под DropdownButton
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedTheme = newValue!;
                              });
                            },
                            items: <String>['Light', 'Dark']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                        onTap: () {
                          // Действие при нажатии на весь элемент (если нужно)
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: spacing),
                      child: Divider(),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: spacing),
                      child: Text(
                        'Настройки учетной записи',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: spacing),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('О нас'),
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          // Действие при нажатии
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: spacing),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('Политика конфиденциальности'),
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          // Действие при нажатии
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: spacing),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text('Условия использования'),
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          // Действие при нажатии
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: screenHeight * 0.25,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors
                    .grey, // Замените на AppColors.silverColor при необходимости
              ),
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomCenter,
                children: [
                  Positioned(
                    bottom: -screenHeight * 0.07,
                    child: CircleAvatar(
                      radius: screenHeight * 0.08,
                      backgroundImage: AssetImage('assets/avatar.png'),
                      // Проверьте путь к изображению
                      backgroundColor: Colors.grey[300],
                    ),
                  ),
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          SizedBox(width: 80),
                          Expanded(
                            child: Text(
                              'Ваш текст здесь',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.08),
            // Текст "Изменить"
            Center(
              child: Text(
                "Изменить",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Первый TextField
                  Text(
                    'Имя',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      hintText: 'Введите имя',
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  // Второй TextField
                  Text(
                    'Емеил',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      hintText: 'Введите имеил',
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  // Третий TextField
                  Text(
                    'Номер',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      hintText: 'Введите номер',
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  // Четвертый TextField
                  Text(
                    'Пароль',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      hintText: 'Введите пароль',
                    ),
                  ),
                  SizedBox(
                    height: screenHeight * 0.08,
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Действие при нажатии кнопки
                      },
                      child: Text(
                        "Обновить",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.3, vertical: 15.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
