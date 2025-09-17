import 'package:bloc_test/bloc_test.dart';
import 'package:cook_note/features/login/bloc/login_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('LoginBloc', () {
    late LoginBloc loginBloc;

    setUp(() {
      // Crear el bloc con la dependencia mock usando el helper
      loginBloc =
          LoginBloc(loginRepository: TestHelpers.createMockLoginRepository());
    });

    tearDown(() {
      loginBloc.close();
    });

    test('initial state is LoginState', () {
      expect(loginBloc.state, isA<LoginState>());
    });

    blocTest<LoginBloc, LoginState>(
      'emits [LoginState] when SetLoginView is added',
      build: () => loginBloc,
      act: (bloc) => bloc.setLoginView(true),
      expect: () => [
        isA<LoginState>().having(
          (state) => state.loginView,
          'loginView',
          true,
        ),
      ],
    );

    test('loginWithEmailAndPassword returns null on error', () async {
      // Este test demuestra cómo el bloc puede ser probado
      // sin depender de Supabase real
      final result = await loginBloc.loginWithEmailAndPassword(
        'test@example.com',
        'password',
      );

      // En un test real, podrías mockear el comportamiento de Supabase
      // y verificar que el bloc maneja correctamente los errores
      expect(result, isNull);
    });
  });
}
