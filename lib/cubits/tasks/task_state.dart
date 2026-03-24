part of 'task_cubit.dart';

abstract class TaskState {}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoadedSuccess extends TaskState {
  final List<Map<String, dynamic>> tasks;
  TaskLoadedSuccess(this.tasks);
}

class TaskLoadedFailed extends TaskState {
  final String error;
  TaskLoadedFailed(this.error);
}
