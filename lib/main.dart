import 'package:bommc/app.dart';
import 'package:bommc/application/cubit/form_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MultiBlocProvider(
      providers: [BlocProvider(create: (context) => FormCubit())],
      child: App()));
}
