import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:note_app/utils/model/note.dart';
import 'package:note_app/view_model/list_tag_view_model.dart';
import 'package:note_app/view_model/list_tb_note_view_model.dart';
import 'package:note_app/view_model/note_view_model.dart';
import 'package:provider/provider.dart';

class BaseView<T extends BaseModel> extends StatefulWidget {
  final Widget Function(BuildContext context, T model, Widget child) builder;
  final Function(T) onModelReady;

  BaseView({this.builder, this.onModelReady});

  @override
  _BaseViewState<T> createState() => _BaseViewState<T>();
}

class _BaseViewState<T extends BaseModel> extends State<BaseView<T>> {
  T model = dependencyAssembler<T>();

  @override
  void initState() {
    if (widget.onModelReady != null) {
      widget.onModelReady(model);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
      create: (context) => model,
      child: Consumer<T>(builder: widget.builder),
    );
  }
}

GetIt dependencyAssembler = GetIt.instance;

void setupDependencyAssembler() {
//  dependencyAssembler.registerLazySingleton(() => API());
  dependencyAssembler.registerFactory(() => NoteViewModel());
  //dependencyAssembler.registerFactory(() => NoteViewModel.withFullInfo(pass));
  dependencyAssembler.registerFactory(() => TagCreatedModel());
  dependencyAssembler.registerFactory(() => NoteCreatedModel());
}
