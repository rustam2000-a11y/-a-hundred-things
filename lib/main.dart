import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:one_hundred_things/presentation/colors.dart';
import 'generated/codegen_loader.g.dart';
import 'package:one_hundred_things/generated/locale_keys.g.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('ru')],
      path: 'assets/translations',
      fallbackLocale: Locale('en'),
      assetLoader: CodegenLoader(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'Firestore Demo',
      theme: ThemeData(
        fontFamily: 'Roboto',
        primarySwatch: Colors.blue,
        primaryColor: AppColors.royalBlue,
        scaffoldBackgroundColor: AppColors.silverColor,
        appBarTheme: AppBarTheme(color: AppColors.royalBlue),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.silverColor ),
        ),
      ),
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

class LoginPage extends StatefulWidget {
  final VoidCallback toggleTheme;

  const LoginPage({super.key, required this.toggleTheme});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  int _currentIndex = 0; // Индекс активной вкладки

  Future<void> _login(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(screenWidth, screenHeight * 0.25), // 30% от высоты экрана
        child: AppBar(
          backgroundColor: AppColors.silverColor,
          actions: [
            IconButton(
              icon: Icon(Icons.brightness_6),
              onPressed: widget.toggleTheme,
            ),
          ],
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(right: 16.0), // Отступ справа
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start, // Выравнивание всех элементов вправо
              children: [
                SizedBox(height: 20), // Отступ сверху для надписи "Logo"
                Text(
                  "Logo",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: Colors.white),
                ),
                const SizedBox(height: 10), // Отступ между "Logo" и заголовком
                Text(
                  "Начните сейчас",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,color: Colors.white),
                ),
                const SizedBox(height: 5), // Отступ между заголовком и описанием
                Text(
                  "Зарегистрируйтесь или войдите в систему, чтобы узнать больше о нашем приложении.",
                  textAlign: TextAlign.left, // Выравнивание текста вправо
                  style: TextStyle(fontSize: 12,color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Внешний контейнер
          Container(
            width: double.infinity,  // Контейнер займет всю доступную ширину
            padding: EdgeInsets.symmetric(horizontal: 30.0,vertical: 24), // Отступы по бокам внутри контейнера
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ), // Радиус закругленных углов сверху слева и справа
            ),
            child: Container(
              width: double.infinity,  // Вложенный контейнер займет всю ширину родителя
              padding: EdgeInsets.symmetric(horizontal: 3.0),  // Отступы внутри серого контейнера
              decoration: BoxDecoration(
                color: Colors.grey[200],  // Серый фон для вложенного контейнера
                borderRadius: BorderRadius.all(Radius.circular(5.0)),  // Радиус углов для серого контейнера
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,  // Кнопки будут располагаться по центру
                mainAxisSize: MainAxisSize.min,  // Контейнер займет минимальный размер по ширине
                children: [
                  // Кнопка Login
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _currentIndex = 0;
                        });
                      },
                      child: Text("Login"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _currentIndex == 0 ? Colors.white : Colors.grey[200],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide.none,  // Убираем контур
                        ),
                        elevation: 0,  // Убираем тень
                      ),
                    ),
                  ),
                  SizedBox(width: 5,),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _currentIndex = 1;
                        });
                      },
                      child: Text("Register"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _currentIndex == 1 ? Colors.white : Colors.grey[200],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide.none,  // Убираем контур
                        ),
                        elevation: 0,  // Убираем тень
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),

            // Вкладка с формой логина или регистрации
            _currentIndex == 0
                ? _loginForm()
                : _registrationForm(),
          ],
        ),
      );
  }

  // Форма логина
  Widget _loginForm() {
    bool _rememberMe = false;
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        color: Colors.white, // Цвет фона контейнера
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height, // Минимальная высота на весь экран
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 25),
                Text("Почта", style: TextStyle(fontSize: 16)),
                SizedBox(height: 5),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                Text("Пароль", style: TextStyle(fontSize: 16)),
                SizedBox(height: 5),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: "Пароль",
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value!;
                            });
                          },
                        ),
                        Text("Запомнить", style: TextStyle(fontSize: 14)),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ForgotPassword()),
                        );
                      },
                      child: Text(
                        "Забыл пароль?",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _login(context),
                  child: Text("Войти"),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),

                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: Divider(thickness: 1, color: Colors.grey)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text("или", style: TextStyle(color: Colors.grey)),
                    ),
                    Expanded(child: Divider(thickness: 1, color: Colors.grey)),
                  ],
                ),
                SizedBox(height: 30),
                ElevatedButton.icon(
                  onPressed: () {
                    // Логика для кнопки "Продолжить с Google"
                  },
                  icon: Icon(Icons.login, color: Colors.red),
                  label: Text("Продолжить с Google"),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    side: BorderSide(color: Colors.grey),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    // Логика для кнопки "Продолжить с Apple"
                  },
                  icon: Icon(Icons.apple, color: Colors.black),
                  label: Text("Продолжить с Apple"),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    side: BorderSide(color: Colors.grey),
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Future<User?> signInWithGoogle() async {
    // Инициализация GoogleSignIn
    final GoogleSignIn googleSignIn = GoogleSignIn();

    // Попытка войти через Google
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      return null; // Если вход был отменен пользователем
    }

    // Получаем данные для аутентификации
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // Создаем учетные данные для Firebase
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Входим в Firebase с этими учетными данными
    final UserCredential userCredential =
    await FirebaseAuth.instance.signInWithCredential(credential);

    return userCredential.user;
  }


  Future<User?> signInWithApple() async {
    // Запрашиваем данные для авторизации через Apple
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
    );

    // Создаем учетные данные для Firebase
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );

    // Входим в Firebase с этими учетными данными
    final userCredential = await FirebaseAuth.instance.signInWithCredential(oauthCredential);
    return userCredential.user;
  }







  // Форма регистрации
  Widget _registrationForm() {
    return Expanded (
        child:  Container (  padding: EdgeInsets.symmetric(horizontal: 30.0),
      decoration: BoxDecoration(
        color: Colors.white, // Цвет фона контейнера
      ),
    child:  Column(
      children: [
        Align(
          alignment: Alignment.bottomLeft,
          child: Text("Почта", style: TextStyle(fontSize: 16), textAlign: TextAlign.left),
        ),
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: "Email",
            border: const OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 16),
        Align(
          alignment: Alignment.bottomLeft,
          child: Text("Пароль", style: TextStyle(fontSize: 16), textAlign: TextAlign.left)
        ),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            labelText: "Password",
            border: const OutlineInputBorder(),
          ),
          obscureText: true,
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Text("Дата рождения", style: TextStyle(fontSize: 16), textAlign: TextAlign.left),
        ),
        TextField(
          controller: _birthdayController,
          decoration: InputDecoration(
            labelText: "Дата рождения",
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () async {
            try {
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
                email: _emailController.text.trim(),
                password: _passwordController.text.trim(),
              );
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => MyHomePage(toggleTheme: widget.toggleTheme)),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Error: $e")),
              );
            }
          },
          child: Text("Register"),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),

          ),
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: Divider(thickness: 1, color: Colors.grey)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text("или", style: TextStyle(color: Colors.grey)),
            ),
            Expanded(child: Divider(thickness: 1, color: Colors.grey)),
          ],
        ),
        SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: () async {
            // Регистрация через Google
            User? user = await signInWithGoogle();

            if (user != null) {
              // Если регистрация через Google прошла успешно
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => MyHomePage(toggleTheme: widget.toggleTheme)),
              );
            } else {
              // Ошибка или отмена входа
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Ошибка входа через Google")),
              );
            }
          },
          icon: Icon(Icons.login, color: Colors.red),
          label: Text("Продолжить с Google"),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 50),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            side: BorderSide(color: Colors.grey),
          ),
        ),
        SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: () async {
            // Вход через Apple
            User? user = await signInWithApple();

            if (user != null) {
              // Если вход успешен, переходим на главную страницу
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => MyHomePage(toggleTheme: widget.toggleTheme)),
              );
            } else {
              // Ошибка или отмена входа
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Ошибка входа через Apple")),
              );
            }
          },
          icon: Icon(Icons.apple, color: Colors.black),
          label: Text("Продолжить с Apple"),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(double.infinity, 50),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            side: BorderSide(color: Colors.grey),
          ),
        )
      ],
    ),
    ),
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
      backgroundColor: isDarkMode ? Colors.black : Colors.white, // Фон зависит от темы
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
                fontSize: screenWidth * 0.07, // Размер шрифта зависит от ширины экрана
                fontWeight: FontWeight.bold, // Толстый шрифт
              ),
            ),
            SizedBox(height: screenHeight * 0.03), // Отступ между текстом и следующим элементом
            Text(
              "Пожалуйста, введите свой адрес электронной почты для сброса пароля",
              style: TextStyle(
                fontSize: screenWidth * 0.04, // Размер шрифта зависит от ширины экрана
                fontWeight: FontWeight.normal, // Обычный шрифт
              ),
            ),
            SizedBox(height: screenHeight * 0.05), // Отступ перед текстфилдом
            Text("Введите почту"),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: screenHeight * 0.05), // Отступ перед кнопкой
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
                  await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Ссылка для сброса пароля отправлена на ваш email")),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Ошибка: $e")),
                  );
                }
              },
              child: Text("Отправить запрос"),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(screenWidth * 0.9, 50), // Кнопка займет 90% ширины экрана
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

  Future<void> _addToFirestore() async {
    final text = _controller.text;
    if (text.isNotEmpty) {
      try {
        await FirebaseFirestore.instance.collection('rill').add({
          'text': text,
          'userId': FirebaseAuth.instance.currentUser?.uid,
          'timestamp': Timestamp.now(),
        });
        _controller.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(LocaleKeys.text_added_to_firestore.tr())),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e")),
        );
      }
    }
  }

  Future<void> _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error logging out: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.add_text_to_firestore.tr()),
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: widget.toggleTheme,
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: LocaleKeys.enter_text.tr(),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _addToFirestore,
              child: Text(LocaleKeys.add_text_to_firestore.tr()),
            ),
            ElevatedButton(
              onPressed: () {
                context.setLocale(Locale('ru'));
              },
              child: Text(LocaleKeys.switch_language.tr()),
            ),
            ElevatedButton(
              onPressed: () {
                context.setLocale(Locale('en'));
              },
              child: Text("Switch to English"),
            ),
          ],
        ),
      ),
    );
  }
}
