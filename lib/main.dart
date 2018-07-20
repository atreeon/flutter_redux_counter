import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

enum Actions { IncrementCounter, IncrementMultiplier, IncrementBoth }

AppState appReducer(AppState state, action) {
  return new AppState(
    count: counterReducer(state.count, state.multiplier, action),
    multiplier: multiplierReducer(state.multiplier, action),
  );
}

//counter Reducer needs to get access to state.multiplier
int counterReducer(int count, int multiplier, dynamic action) {
  if (action == Actions.IncrementCounter) {
    return (count + 1) + multiplier;
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
                    // Return a `VoidCallback`, which is a fancy name for a function
                    // with no parameters. It only dispatches an Increment action.
                    return () => store.dispatch(Actions.IncrementCounter);
                  },
                  builder: (context, callback) {
                    return new RaisedButton(
                      // Attach the `callback` to the `onPressed` attribute
                      onPressed: callback,
                      child: new Text("Increase count"),
                    );
                  },
                ),

                // new RaisedButton(
                //     child: new Text("Increase count"),
                //     onPressed: () =>
                //         StoreProvider.of<AppState>(context).dispatch(Actions.IncrementCounter)),
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
                    // Return a `VoidCallback`, which is a fancy name for a function
                    // with no parameters. It only dispatches an Increment action.
                    return () => store.dispatch(Actions.IncrementMultiplier);
                  },
                  builder: (context, callback) {
                    return new RaisedButton(
                      // Attach the `callback` to the `onPressed` attribute
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
                    // Return a `VoidCallback`, which is a fancy name for a function
                    // with no parameters. It only dispatches an Increment action.
                    return () {
                      store.dispatch(Actions.IncrementMultiplier);
                      store.dispatch(Actions.IncrementMultiplier);
                      store.dispatch(Actions.IncrementMultiplier);
                      store.dispatch(Actions.IncrementCounter);
                    };
                  },
                  builder: (context, callback) {
                    return new RaisedButton(
                      // Attach the `callback` to the `onPressed` attribute
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
