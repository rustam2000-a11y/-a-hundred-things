// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Flutter Example App`
  String get title {
    return Intl.message(
      'Flutter Example App',
      name: 'title',
      desc: '',
      args: [],
    );
  }

  /// `Сategories`
  String get category {
    return Intl.message(
      'Сategories',
      name: 'category',
      desc: '',
      args: [],
    );
  }

  /// `delete`
  String get delete {
    return Intl.message(
      'delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Account settings`
  String get accountSettings {
    return Intl.message(
      'Account settings',
      name: 'accountSettings',
      desc: '',
      args: [],
    );
  }

  /// `Edit profile`
  String get editProfile {
    return Intl.message(
      'Edit profile',
      name: 'editProfile',
      desc: '',
      args: [],
    );
  }

  /// `Application language`
  String get applicationLanguage {
    return Intl.message(
      'Application language',
      name: 'applicationLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Push notifications`
  String get pushNotifications {
    return Intl.message(
      'Push notifications',
      name: 'pushNotifications',
      desc: '',
      args: [],
    );
  }

  /// `Theme`
  String get theme {
    return Intl.message(
      'Theme',
      name: 'theme',
      desc: '',
      args: [],
    );
  }

  /// `About Us`
  String get aboutUs {
    return Intl.message(
      'About Us',
      name: 'aboutUs',
      desc: '',
      args: [],
    );
  }

  /// `Privacy policy`
  String get privacyPolicy {
    return Intl.message(
      'Privacy policy',
      name: 'privacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Terms of use`
  String get termsOfUse {
    return Intl.message(
      'Terms of use',
      name: 'termsOfUse',
      desc: '',
      args: [],
    );
  }

  /// `Type`
  String get type {
    return Intl.message(
      'Type',
      name: 'type',
      desc: '',
      args: [],
    );
  }

  /// `Enter a name`
  String get enterAName {
    return Intl.message(
      'Enter a name',
      name: 'enterAName',
      desc: '',
      args: [],
    );
  }

  /// `Descriptionа`
  String get description {
    return Intl.message(
      'Descriptionа',
      name: 'description',
      desc: '',
      args: [],
    );
  }

  /// `Start now`
  String get startNow {
    return Intl.message(
      'Start now',
      name: 'startNow',
      desc: '',
      args: [],
    );
  }

  /// `Register or login to learn more about our application.`
  String get registerOrLoginToLearnMoreAboutOurApplication {
    return Intl.message(
      'Register or login to learn more about our application.',
      name: 'registerOrLoginToLearnMoreAboutOurApplication',
      desc: '',
      args: [],
    );
  }

  /// `Mail`
  String get mail {
    return Intl.message(
      'Mail',
      name: 'mail',
      desc: '',
      args: [],
    );
  }

  /// `Remember`
  String get remember {
    return Intl.message(
      'Remember',
      name: 'remember',
      desc: '',
      args: [],
    );
  }

  /// `Forgot your password?`
  String get forgotYourPassword {
    return Intl.message(
      'Forgot your password?',
      name: 'forgotYourPassword',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `or`
  String get or {
    return Intl.message(
      'or',
      name: 'or',
      desc: '',
      args: [],
    );
  }

  /// `Continue with Google`
  String get continueWithGoogle {
    return Intl.message(
      'Continue with Google',
      name: 'continueWithGoogle',
      desc: '',
      args: [],
    );
  }

  /// `Continue with Apple`
  String get continueWithApple {
    return Intl.message(
      'Continue with Apple',
      name: 'continueWithApple',
      desc: '',
      args: [],
    );
  }

  /// `Date of birth`
  String get dateOfBirth {
    return Intl.message(
      'Date of birth',
      name: 'dateOfBirth',
      desc: '',
      args: [],
    );
  }

  /// `Please enter your email address to reset your password`
  String get pleaseEnterYourEmailAddressToResetYourPassword {
    return Intl.message(
      'Please enter your email address to reset your password',
      name: 'pleaseEnterYourEmailAddressToResetYourPassword',
      desc: '',
      args: [],
    );
  }

  /// `Enter your email`
  String get enterYourEmail {
    return Intl.message(
      'Enter your email',
      name: 'enterYourEmail',
      desc: '',
      args: [],
    );
  }

  /// `A password reset link has been sent to your email.`
  String get aPasswordResetLinkHasBeenSentToYourEmail {
    return Intl.message(
      'A password reset link has been sent to your email.',
      name: 'aPasswordResetLinkHasBeenSentToYourEmail',
      desc: '',
      args: [],
    );
  }

  /// `Send request`
  String get sendRequest {
    return Intl.message(
      'Send request',
      name: 'sendRequest',
      desc: '',
      args: [],
    );
  }

  /// `Change`
  String get change {
    return Intl.message(
      'Change',
      name: 'change',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Enter name`
  String get enterName {
    return Intl.message(
      'Enter name',
      name: 'enterName',
      desc: '',
      args: [],
    );
  }

  /// `Number`
  String get number {
    return Intl.message(
      'Number',
      name: 'number',
      desc: '',
      args: [],
    );
  }

  /// `Enter number`
  String get enterNumber {
    return Intl.message(
      'Enter number',
      name: 'enterNumber',
      desc: '',
      args: [],
    );
  }

  /// `Enter your password`
  String get enterYourPassword {
    return Intl.message(
      'Enter your password',
      name: 'enterYourPassword',
      desc: '',
      args: [],
    );
  }

  /// `Categories`
  String get ategories {
    return Intl.message(
      'Categories',
      name: 'ategories',
      desc: '',
      args: [],
    );
  }

  /// `Email Adderss`
  String get emailAdderss {
    return Intl.message(
      'Email Adderss',
      name: 'emailAdderss',
      desc: '',
      args: [],
    );
  }

  /// `NEXT`
  String get next {
    return Intl.message(
      'NEXT',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `Open Email`
  String get openEmail {
    return Intl.message(
      'Open Email',
      name: 'openEmail',
      desc: '',
      args: [],
    );
  }

  /// `Apple Sign In Error`
  String get appleSignInError {
    return Intl.message(
      'Apple Sign In Error',
      name: 'appleSignInError',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ru'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
