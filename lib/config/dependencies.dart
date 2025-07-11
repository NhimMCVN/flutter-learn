import 'package:first_flutter_app/data/repositories/auth/auth_repository_remote.dart';
import 'package:first_flutter_app/data/repositories/note/note_repository.dart';
import 'package:first_flutter_app/data/repositories/note/note_repository_local.dart';
import 'package:first_flutter_app/data/services/api/api_client.dart';
import 'package:first_flutter_app/data/services/api/auth_api_client.dart';
import 'package:first_flutter_app/data/services/note/note_service_local.dart';
import 'package:first_flutter_app/data/services/shared_preferences_service.dart';
import 'package:first_flutter_app/ui/note/note_screen/view_models/note_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import '../data/repositories/auth/auth_repository.dart';
import 'environment.dart';

List<SingleChildWidget> get providersLocal {
  return [
    Provider(
      create: (context) {
        final client = AuthApiClient(baseUrl: Environment.authApiBaseUrl);
        return client;
      },
    ),
    Provider(
      create: (context) {
        final client = ApiClient(baseUrl: Environment.notesApiBaseUrl);
        return client;
      },
    ),
    Provider(create: (context) => SharedPreferencesService()),
    ChangeNotifierProvider<AuthRepository>(
      create: (context) =>
          AuthRepositoryRemote(
                authApiClient: context.read(),
                sharedPreferencesService: context.read(),
              )
              as AuthRepository,
    ),
    Provider(
      create: (context) {
        return NoteServiceLocal(
          apiClient: context.read<ApiClient>(),
          authToken: '',
          sharedPreferencesService: context.read<SharedPreferencesService>(),
        );
      },
    ),
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
