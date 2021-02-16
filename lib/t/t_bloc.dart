import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

t_bloc() => runApp(_App());

class _MCubit extends Cubit<String> {
  _MCubit() : super("inti_");
  void ttt() {}
  void inc() => emit('$state a');
  void dec() => emit(
      (state.length > 1) ? state.substring(0, state.length - 1) : 'exhausted_');
}

class _Mbloc extends Bloc<int, String> {
  int i = 100;
  _Mbloc() : super('initb_');

  @override
  Stream<String> mapEventToState(int event) async* {
    for (var j = 0; j < event; j++) {
      var fs = Future.delayed(Duration(seconds: j), () {
        i++;
        var s = 'event$i';
        print('generate: $s');
        return s;
      });
      yield await fs;
    }
    /*
    i += event;
    print('input: $event');
    print('input: $event, now $i');
    var fs = Future.delayed(Duration(seconds: 10), () => 'event $i');
    yield await fs;
    */
    // Future.delayed(Duration({seconds: 1}, (x)=)
  }
}

class _App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // var c = _MCubit();
    // var b = _Mbloc();

    // var bp = BlocProvider(create: (x) => c, child: _Mwidget(c: c, b: null));
    // var bp = BlocProvider(create: (x) => b, child: _Mwidget(c: null, b: b));
    // var bp = BlocProvider(create: (x) => b, child: _Mwidget(c: c, b: b));
    // var bp = _Mwidget(c: c, b: b);

    var bp = MultiBlocProvider(providers: [
      BlocProvider<_MCubit>(create: (ctx) => _MCubit()),
      BlocProvider<_Mbloc>(create: (ctx) => _Mbloc()),
    ], child: _Mwidget());
    return bp;
  }
}

class _Mwidget extends StatelessWidget {
  // final _MCubit c;
  // final _Mbloc b;
  // _Mwidget({this.c, this.b});
  // _Mwidget();

  @override
  Widget build(BuildContext context) {
    // var c = BlocProvider.of<_MCubit>(context);
    // var b = BlocProvider.of<_Mbloc>(context);
    var c = context.read<_MCubit>();
    var b = context.read<_Mbloc>();

    var appBar = AppBar(
      title: Text("bloc cubit"),
    );
    // var c1 =        BlocBuilder<_MCubit, String>(builder: (ctx, s) => Text(s), cubit: c);
    var c1 = Builder(
      builder: (ctx) {
        // final c = context.read<_MCubit>();
        final c = context.watch<_MCubit>().state;
        // var c = context.read<_MCubit>().state;
        print('---');
        return Text('${c}');
      },
    );

    var b1 = BlocBuilder<_Mbloc, String>(
        cubit: b,
        builder: (ctx, s) {
          // var s = ctx.read<_MCubit>().state;
          // var s = ctx.read<_Mbloc>().state;
          return Text('_b_ $s');
        });

    var body = Column(children: [c1, b1]);
    var btnInc = FloatingActionButton(
        // onPressed: () => context.read<_MCubit>().inc(), child: Icon(Icons.add));
        onPressed: () {
          c.inc();
          b.add(8);
        },
        child: Icon(Icons.add));
    var btnDec = FloatingActionButton(
        // onPressed: () => context.read<_MCubit>().dec(),
        onPressed: () => c.dec(),
        child: Icon(Icons.remove));
    var fltBtns = Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [btnInc, btnDec],
    );
    var home = Scaffold(
      appBar: appBar,
      body: body,
      floatingActionButton: fltBtns,
    );
    var app = MaterialApp(home: home);
    return app;
  }
}
