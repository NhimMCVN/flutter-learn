import 'package:first_flutter_app/data/repositories/note/note_repository.dart';
import 'package:first_flutter_app/data/repositories/note/note_repository_local.dart';
import 'package:first_flutter_app/data/services/note/note_service_local.dart';
import 'package:first_flutter_app/ui/note/todo_screen/view_models/note_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../data/repositories/auth/auth_repository.dart';
import '../data/repositories/auth/auth_repository_dev.dart';

List<SingleChildWidget> get providersLocal {
  return [
    ChangeNotifierProvider.value(value: AuthRepositoryDev() as AuthRepository),
    Provider(create: (_) => NoteServiceLocal()),
    Provider<NoteRepository>(
      create: (context) =>
          NoteRepositoryLocal(context.read<NoteServiceLocal>()),
    ),
    ChangeNotifierProvider(
      create: (context) =>
          NoteViewModel(noteRepository: context.read<NoteRepository>()),
    ),
  ];
}
