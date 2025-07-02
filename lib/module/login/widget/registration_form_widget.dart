import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../generated/l10n.dart';
import '../../home/my_home_page.dart';
import '../bloc/registration_bloc.dart';
import '../bloc/registration_event.dart';
import '../bloc/registration_state.dart';
import 'button_basic.dart';
import 'custom_divider.dart';
import 'custom_text.dart';
import 'text_filed.dart';

class RegistrationFormWidget extends StatefulWidget {
  const RegistrationFormWidget({super.key});

  @override
  State<RegistrationFormWidget> createState() => _RegistrationFormWidgetState();
}

class _RegistrationFormWidgetState extends State<RegistrationFormWidget> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  late final RegistrationBloc _bloc;

  @override
  void initState() {
    _bloc = GetIt.I<RegistrationBloc>();
    super.initState();
  }

  @override
  void dispose() {
    _bloc.close();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<RegistrationBloc, RegistrationState>(
        bloc: _bloc,
        listener: (context, state) {
          if (state is RegistrationSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute<void>(
                builder: (_) => MyHomePage(toggleTheme: () {}),
              ),
            );
          } else if (state is RegistrationFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: BlocBuilder<RegistrationBloc, RegistrationState>(
          bloc: _bloc,
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 64),
                  const CustomText(text: 'Create a profile'),
                  const SizedBox(height: 64),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: CustomText3(text: S.of(context).emailAdderss),
                  ),
                  const SizedBox(height: 4),
                  CustomTextField(controller: _emailController),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: CustomText3(text: S.of(context).password),
                  ),
                  const SizedBox(height: 4),
                  CustomTextField(
                    controller: _passwordController,
                    isPasswordField: true,
                  ),
                  const SizedBox(height: 16),
                  const Align(
                    alignment: Alignment.bottomLeft,
                    child: CustomText3(text: 'Name'),
                  ),
                  const SizedBox(height: 4),
                  CustomTextField(controller: _nameController),
                  const SizedBox(height: 18),
                  ReusableButton(
                    text: state is RegistrationLoading
                        ? '...'
                        : S.of(context).next,
                    onPressed: state is RegistrationLoading
                        ? null
                        : () {
                      _bloc.add(RegisterWithEmailEvent(
                        _emailController.text.trim(),
                        _passwordController.text.trim(),
                        _nameController.text.trim(),
                      ));
                    },
                  ),
                  const SizedBox(height: 20),
                  DividerWithText(text: S.of(context).or),
                  const SizedBox(height: 20),
                  CustomButtonRegist(
                    text: S.of(context).continueWithGoogle,
                    image: const AssetImage('assets/images/google.png'),
                    onPressed: () {
                      _bloc.add( RegisterWithGoogleEvent());
                    },
                  ),
                  const SizedBox(height: 15),
                  CustomButtonRegist(
                    text: S.of(context).continueWithApple,
                    icon: Icons.apple,
                    onPressed: () {
                      _bloc.add( RegisterWithAppleEvent());
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
