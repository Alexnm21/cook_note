import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/models/ingredient.dart';

part 'ingredient_list_event.dart';
part 'ingredient_list_state.dart';

class IngredientListBloc
    extends Bloc<IngredientListEvent, IngredientListState> {
  IngredientListBloc() : super(IngredientListState()) {
    on<IngredientListEvent>((event, emit) {});
  }
}
