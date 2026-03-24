part of 'subtask_cubit.dart';

abstract class SubTaskState {}

class SubTaskInitial extends SubTaskState {}

class SubTaskLoading extends SubTaskState {}

class SubTaskLoadedSuccess extends SubTaskState {
  final List<Map<String, dynamic>> subTasks;
  SubTaskLoadedSuccess(this.subTasks);
}

class SubTaskLoadedFailed extends SubTaskState {
  final String error;
  SubTaskLoadedFailed(this.error);
}
