part of 'category_form_bloc.dart';

final class CategoryFormState extends BaseState {
  CategoryFormState({
    super.status = BaseStatus.initial,
    super.message,
    this.categoryId,
    this.type = CategoryType.expense,
    this.iconCode = 'category',
    this.colorValue = 0xFF1B6B4A,
    this.isEditing = false,
    this.saved = false,
    this.initialName,
    this.errorCode,
  });

  final String? categoryId;
  final CategoryType type;
  final String iconCode;
  final int colorValue;
  final bool isEditing;
  final bool saved;
  final String? initialName;
  final CategoryErrorCode? errorCode;

  factory CategoryFormState.initial({CategoryType type = CategoryType.expense}) {
    return CategoryFormState(type: type);
  }

  CategoryFormState copyWith({
    BaseStatus? status,
    String? message,
    String? categoryId,
    CategoryType? type,
    String? iconCode,
    int? colorValue,
    bool? isEditing,
    bool? saved,
    String? initialName,
    CategoryErrorCode? errorCode,
    bool clearError = false,
  }) {
    return CategoryFormState(
      status: status ?? this.status,
      message: message ?? this.message,
      categoryId: categoryId ?? this.categoryId,
      type: type ?? this.type,
      iconCode: iconCode ?? this.iconCode,
      colorValue: colorValue ?? this.colorValue,
      isEditing: isEditing ?? this.isEditing,
      saved: saved ?? this.saved,
      initialName: initialName ?? this.initialName,
      errorCode: clearError ? null : errorCode ?? this.errorCode,
    );
  }

  @override
  List<Object?> get props => [
        ...super.props,
        categoryId,
        type,
        iconCode,
        colorValue,
        isEditing,
        saved,
        initialName,
        errorCode,
      ];
}
