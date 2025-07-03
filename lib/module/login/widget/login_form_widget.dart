import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../generated/l10n.dart';
import '../../../presentation/colors.dart';
import '../../home/my_home_page.dart';
import '../bloc/login_bloc.dart';
import '../bloc/login_event.dart';
import '../bloc/login_state.dart';
import '../screen/forgot_inform_screen.dart';
import '../screen/registration_screen.dart';
import 'button_basic.dart';
import 'custom_divider.dart';
import 'custom_text.dart';
import 'text_filed.dart';

class LoginFormWidget extends StatefulWidget {
  const LoginFormWidget({super.key});

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  bool _isSubmitting = false;

  late final LoginBloc _bloc;

  @override
  void initState() {
    _bloc = GetIt.I<LoginBloc>();
    super.initState();
  }

  @override
  void dispose() {
    _bloc.close();
    _emailController.dispose();
    _passwordController.dispose();
    _birthdayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LoginBloc, LoginState>(
        bloc: _bloc,
        listener: (context, state) {
          if (state is LoginLoading) {
            setState(() {
              _isSubmitting = true;
            });
          } else if (state is LoginSuccess) {
            setState(() {
              _isSubmitting = false;
            });

            Navigator.pushReplacement(
              context,
              MaterialPageRoute<void>(
                builder: (_) => const MyHomePage(toggleTheme: null),
              ),
            );
          } else if (state is LoginFailure) {
            setState(() {
              _isSubmitting = false;
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: BlocBuilder<LoginBloc, LoginState>(
          bloc: _bloc,
          builder: (context, state) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 64),
                      const CustomText(text: 'LOGIN'),
                      const SizedBox(height: 64),
                      CustomText3(text: S.of(context).emailAdderss),
                      const SizedBox(height: 5),
                      CustomTextField(controller: _emailController),
                      const SizedBox(height: 16),
                      CustomText3(text: S.of(context).password),
                      const SizedBox(height: 5),
                      CustomTextField(
                        controller: _passwordController,
                        isPasswordField: true,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push<void>(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (_) => const ForgotInfoScreen(),
                                ),
                              );
                            },
                            child: CustomText2(
                              text: S.of(context).forgotYourPassword,
                              underline: true,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ReusableButton(
                        text: _isSubmitting ? 'Loading...' : S.of(context).login,
                        onPressed: _isSubmitting
                            ? null
                            : () {
                          _bloc.add(LoginWithEmailEvent(
                            _emailController.text.trim(),
                            _passwordController.text.trim(),
                          ));
                        },

                      ),

                      const SizedBox(height: 20),
                      DividerWithText(text: S.of(context).or),
                      const SizedBox(height: 30),
                      CustomButtonRegist(
                        text: S.of(context).continueWithGoogle,
                        image: const AssetImage('assets/images/google.png'),
                        onPressed: () {
                          _bloc.add(const LoginWithGoogleEvent());
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomButtonRegist(
                        text: S.of(context).continueWithApple,
                        icon: Icons.apple,
                        onPressed: () {
                          _bloc.add(const LoginWithAppleEvent());
                        },
                      ),
                      const SizedBox(height: 40),
                      GestureDetector(
                        onTap: () {
                          Navigator.push<void>(
                            context,
                            MaterialPageRoute<void>(
                              builder: (_) => const RegistrationScreen(),
                            ),
                          );
                        },
                        child: const CustomText2(
                          text: 'Create My Profile',
                          underline: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
