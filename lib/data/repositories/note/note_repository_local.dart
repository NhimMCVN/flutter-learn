import 'package:first_flutter_app/data/repositories/models/note_model_ui.dart';
import 'package:first_flutter_app/data/services/models/note_model.dart';
import 'package:first_flutter_app/data/services/note/note_service_local.dart';
import 'package:first_flutter_app/utils/result.dart';

import 'note_repository.dart';

enum EnumStatus { Success, Error }

class NoteRepositoryLocal implements NoteRepository {
  final NoteServiceLocal _service;

  NoteRepositoryLocal(this._service);

  @override
  Future<dynamic> fetchListNote() async {
    try {
      final result = await _service.getListNote();
      List<NoteModelUI> list = [];
      if (result.data != null && result.data is List) {
        final dataList = result.data as List;

        for (int i = 0; i < dataList.length; i++) {
          try {
            final note = dataList[i];

            if (note is NoteModel) {
              list.add(NoteModelUI.fromModel(note));
            } else if (note is Map) {
              list.add(NoteModelUI.fromJson(Map<String, dynamic>.from(note)));
            } else {
              throw Exception('Unknown note type: ${note.runtimeType}');
            }
          } catch (e) {
            continue;
          }
        }
      }

      return list;
    } catch (e) {
      return EnumStatus.Error;
    }
  }

  @override
  Future<dynamic> createNote(NoteModelUI note) async {
    final newNote = NoteModel(
      description: note.description,
      amount: note.amount,
      date: note.date.millisecondsSinceEpoch / 1000,
      category: note.category.name,
      type: note.type,
    );
    final result = await _service.createNote(newNote);
    if (result.statusCode == 200) {
      return EnumStatus.Success;
    }
    return EnumStatus.Error;
  }

  @override
  Future<dynamic> deleteNote(String id) async {
    final result = await _service.deleteNote(id);
    if (result.statusCode == 200) {
      return EnumStatus.Success;
    }
    return EnumStatus.Error;
  }

  @override
  Future<dynamic> updateNote(String id, NoteModelUI note) async {
    final updatedNote = NoteModel(
      id: id,
      description: note.description,
      amount: note.amount,
      date: note.date.millisecondsSinceEpoch / 1000,
      category: note.category.name,
      type: note.type,
    );
    final result = await _service.updateNote(updatedNote);
    if (result.statusCode == 200) {
      return EnumStatus.Success;
    }
    return EnumStatus.Error;
  }

  @override
  Future<dynamic> fetchNoteById(String id) async {
    final result = await _service.getNoteById(id);
    dynamic note = result.data;
    if (result.statusCode == 200) {
      if (note is NoteModel) {
        return NoteModelUI.fromModel(note);
      } else if (note is Map) {
        return NoteModelUI.fromJson(Map<String, dynamic>.from(note));
      }
      throw Exception('Unknown note type');
    }
    return EnumStatus.Error;
  }
}
