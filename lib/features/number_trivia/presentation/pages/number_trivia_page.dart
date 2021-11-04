import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' as widgets;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trivial_number/features/number_trivia/presentation/bloc/bloc/number_trivia_bloc.dart';
import 'package:trivial_number/features/number_trivia/presentation/widgets/widgets.dart';
import '../../../../injection_container.dart';

class NumberTriviaPage extends StatelessWidget {
  const NumberTriviaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Trivia'),
      ),
      body: SingleChildScrollView(
        child: buildBody(context),
      ),
    );
  }

  FutureBuilder<void> buildBody(BuildContext context) {
    return FutureBuilder<void>(
        future: sl.isReady<SharedPreferences>(),
        builder: (context, snapShot) {
          if (snapShot.connectionState == ConnectionState.done) {
            sl<SharedPreferences>().setString('DEMO', 'OK');
            return BlocProvider(
              create: (_) => sl<NumberTriviaBloc>(),
              child: temp(context),
            );
          } else {
            return const Text('TEST');
          }
        });
  }

  Widget temp(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 10,
            ),
            //Top Half
            BlocBuilder<NumberTriviaBloc, NumberTriviaState>(
                builder: (context, state) {
              if (state is Empty) {
                return const MessageDisplay(message: 'Start searching');
              } else if (state is Loading) {
                return const LoadingWidget();
              } else if (state is Loaded) {
                return TriviaDisplay(
                  numberTrivia: state.trivia,
                );
              } else if (state is Error) {
                return MessageDisplay(message: state.toString());
              } else {
                return Container();
              }
            }),

            const SizedBox(
              height: 20,
            ),
            //Bottom half
            const TriviaControls(),
          ],
        ),
      ),
    );
  }
}

class TriviaControls extends StatefulWidget {
  const TriviaControls({
    Key? key,
  }) : super(key: key);

  @override
  widgets.State<TriviaControls> createState() => _TriviaControlsState();
}

class _TriviaControlsState extends widgets.State<TriviaControls> {
  final controller = TextEditingController();
  late String inputStr;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
              border: OutlineInputBorder(), hintText: 'Input a number'),
          onChanged: (value) {
            inputStr = value;
          },
          onSubmitted: (_) {
            dispatchConcrete();
          },
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                child: Text('Search'),
                onPressed: dispatchConcrete,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
                child: ElevatedButton(
              child: Text('Get random trivia'),
              onPressed: dispatchRandom,
            ))
          ],
        )
      ],
    );
  }

  void dispatchConcrete() {
    controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context)
        .add(GetTriviaForConcreteNumber(inputStr));
  }

  void dispatchRandom() {
    controller.clear();
    BlocProvider.of<NumberTriviaBloc>(context).add(GetTriviaForRandomNumber());
  }
}
