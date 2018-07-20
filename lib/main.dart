import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux_combine2/flutter_redux_combine2.dart';

enum Actions { IncrementMultiplier, IncrementBoth }

class IncrementCounterMultipliedAction {}

class IncrementCounterAction {}

AppState appReducer(AppState state, action) {
  return new AppState(
    count: counterReducers(state.count, state.multiplier, action),
    multiplier: multiplierReducer(state.multiplier, action),
  );
}

final counterReducers = combineReducers2<int, int>([
  new TypedReducer2<int, int, IncrementCounterMultipliedAction>(_incrementCounterMultipliedAction)
], [
  new TypedReducer<int, IncrementCounterAction>(_counterAction)
]);

int _incrementCounterMultipliedAction(
    int count, int multiplier, IncrementCounterMultipliedAction action) {
  if (action is IncrementCounterMultipliedAction) {
    return (count + 1) + multiplier;
  }

  return count;
}

int _counterAction(int count, dynamic action) {
  if (action is IncrementCounterAction) {
    return (count + 1);
  }

  return count;
}

int multiplierReducer(int state, dynamic action) {
  if (action == Actions.IncrementMultiplier) {
    return state + 1;
  }

  return state;
}

void main() {
  final store =
      new Store<AppState>(appReducer, initialState: new AppState(count: 0, multiplier: 0));

  runApp(new FlutterReduxApp(
    title: 'Flutter Redux Demo',
    store: store,
  ));
}

class AppState {
  final int count;
  final int multiplier;

  AppState({this.count, this.multiplier});
}

class FlutterReduxApp extends StatelessWidget {
  final Store<AppState> store;
  final String title;

  FlutterReduxApp({Key key, this.store, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new StoreProvider<AppState>(
      store: store,
      child: new MaterialApp(
        theme: new ThemeData.dark(),
        title: title,
        home: new Scaffold(
          appBar: new AppBar(
            title: new Text(title),
          ),
          body: new Center(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                new StoreConnector<AppState, VoidCallback>(
                  converter: (store) {
                    return () => store.dispatch(new IncrementCounterAction());
                  },
                  builder: (context, callback) {
                    return new RaisedButton(
                      onPressed: callback,
                      child: new Text("Increase count"),
                    );
                  },
                ),
                new StoreConnector<AppState, VoidCallback>(
                  converter: (store) {
                    return () => store.dispatch(new IncrementCounterMultipliedAction());
                  },
                  builder: (context, callback) {
                    return new RaisedButton(
                      onPressed: callback,
                      child: new Text("Increase Count with multiplier"),
                    );
                  },
                ),
                new Text(
                  'The count is:',
                ),
                new StoreConnector<AppState, String>(
                  converter: (store) => store.state.count.toString(),
                  builder: (context, count) {
                    return new Text(
                      count,
                      style: Theme.of(context).textTheme.display1,
                    );
                  },
                ),
                new StoreConnector<AppState, VoidCallback>(
                  converter: (store) {
                    return () => store.dispatch(Actions.IncrementMultiplier);
                  },
                  builder: (context, callback) {
                    return new RaisedButton(
                      onPressed: callback,
                      child: new Text("Increment multiplier"),
                    );
                  },
                ),
                new Text(
                  'The multiplier is at:',
                ),
                new StoreConnector<AppState, String>(
                  converter: (store) => store.state.multiplier.toString(),
                  builder: (context, multiplier) {
                    return new Text(
                      multiplier,
                      style: Theme.of(context).textTheme.display1,
                    );
                  },
                ),
                new StoreConnector<AppState, VoidCallback>(
                  converter: (store) {
                    return () {
                      store.dispatch(Actions.IncrementMultiplier);
                      store.dispatch(Actions.IncrementMultiplier);
                      store.dispatch(Actions.IncrementMultiplier);
                      store.dispatch(new IncrementCounterMultipliedAction());
                    };
                  },
                  builder: (context, callback) {
                    return new RaisedButton(
                      onPressed: callback,
                      child: new Text("Increment both"),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
