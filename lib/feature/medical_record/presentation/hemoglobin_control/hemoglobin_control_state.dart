class HemoglobinControlState {
  final bool isCreatingLevel;
  final String? createErrorMessage;

  const HemoglobinControlState({
    this.isCreatingLevel = false,
    this.createErrorMessage,
  });

  HemoglobinControlState copyWith({
    bool? isCreatingLevel,
    String? createErrorMessage,
  }) {
    return HemoglobinControlState(
      isCreatingLevel: isCreatingLevel ?? this.isCreatingLevel,
      createErrorMessage: createErrorMessage,
    );
  }
}
