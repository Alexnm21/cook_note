import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  late StreamSubscription<AuthState> authSubscription;
  UserBloc() : super(UserInitial()) {
    on<LoggedIn>((event, emit) {
      emit(UserLoggedIn(user: event.user));
    });
    on<LoggedOut>((event, emit) {
      emit(UserLoggedOut());
    });

    init();
  }

  init() {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      add(LoggedIn(user: user));
    } else {
      add(LoggedOut());
    }
    listenAuthChanges();
  }

  listenAuthChanges() {
    authSubscription =
        Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      if (event == AuthChangeEvent.signedIn) {
        add(LoggedIn(user: data.session!.user));
      } else if (event == AuthChangeEvent.signedOut) {
        add(LoggedOut());
      }
    });
  }

  String getUserId() {
    if (state is UserLoggedIn) {
      return (state as UserLoggedIn).user.id;
    }
    throw Exception('User not logged in');
  }

  String getUsername() {
    if (state is UserLoggedIn) {
      return (state as UserLoggedIn).user.email ?? '';
    }
    throw Exception('User not logged in');
  }

  void logout() {
    add(LoggedOut());
    Supabase.instance.client.auth.signOut();
  }

  @override
  Future<void> close() {
    authSubscription.cancel();
    return super.close();
  }
}
