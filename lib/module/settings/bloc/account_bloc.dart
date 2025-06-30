import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../repository/setting_repository.dart';

part 'account_event.dart';
part 'account_state.dart';

@injectable
class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final SettingRepositoryI _repository;

  AccountBloc(this._repository) : super(const AccountState()) {
    on<LoadAccountData>(_onLoadAccountData);
    on<UpdateAccountData>(_onUpdateAccountData);
  }

  Future<void> _onLoadAccountData(
      LoadAccountData event, Emitter<AccountState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final data = await _repository.getUserData();
      emit(state.copyWith(
        name: data['name'] ?? '',
        email: data['email'] ?? '',
        phone: data['phone'] ?? '',
        password: data['password'] ?? '',
        avatarUrl: data['avatarUrl'] ?? '',
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onUpdateAccountData(
      UpdateAccountData event, Emitter<AccountState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      await _repository.saveUserData(
        name: event.name,
        email: event.email,
        phone: event.phone,
        password: event.password,
      );
      emit(state.copyWith(
        name: event.name,
        email: event.email,
        phone: event.phone,
        password: event.password,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
