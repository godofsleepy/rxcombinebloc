import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxcombinebloc/home_bloc.dart';
import 'package:rxcombinebloc/remote.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => HomeBloc(remote: Remote())
        ..add(
          GetGames(1),
        ),
      child: Scaffold(
        body: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
          if (state.status == HomeStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == HomeStatus.success) {
            return ListView.separated(
              itemBuilder: (ctx, index) {
                return ListTile(
                  leading: ClipOval(
                    child: Image.network(
                      state.games[index].backgroundImage,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    state.games[index].name,
                  ),
                );
              },
              separatorBuilder: (_, i) => const SizedBox(
                height: 8,
              ),
              itemCount: state.games.length,
            );
          } else {
            return Container();
          }
        }),
      ),
    );
  }
}
