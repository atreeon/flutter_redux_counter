import 'package:redux/redux.dart';

Reducer2<StateOut, StateIn2> combineReducers2<StateOut, StateIn2>(
    Iterable<Reducer2<StateOut, StateIn2>> reducers2, Iterable<Reducer<StateOut>> reducers) {
  return (StateOut state, StateIn2 stateIn2, dynamic action) {
    for (final reducer in reducers2) {
      state = reducer(state, stateIn2, action);
    }

    for (final reducer in reducers) {
      state = reducer(state, action);
    }

    return state;
  };
}

abstract class ReducerClass2<StateCore, StateIn> {
  StateCore call(StateCore stateCore, StateIn stateIn, dynamic action);
}

class TypedReducer2<StateCore, StateIn, Action> implements ReducerClass2<StateCore, StateIn> {
  final StateCore Function(StateCore stateCore, StateIn stateIn, Action action) reducer;

  TypedReducer2(this.reducer);

  @override
  StateCore call(StateCore stateCore, StateIn stateIn, dynamic action) {
    if (action is Action) {
      return reducer(stateCore, stateIn, action);
    }

    return stateCore;
  }
}

typedef StateOut Reducer2<StateOut, StateIn2>(StateOut state, StateIn2 stateIn2, dynamic action);
