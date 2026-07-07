
import '../../domain/model/value-objects/consultations_inbox_result.dart';

class ConsultationsInboxState {
  final bool isLoading;
  final String? errorMessage;
  final ConsultationsInboxResult? result;
  final String searchTerm;

  const ConsultationsInboxState({
    this.isLoading = true,
    this.errorMessage,
    this.result,
    this.searchTerm = '',
  });

  ConsultationsInboxState copyWith({
    bool? isLoading,
    String? errorMessage,
    ConsultationsInboxResult? result,
    String? searchTerm,
  }) {
    return ConsultationsInboxState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      result: result ?? this.result,
      searchTerm: searchTerm ?? this.searchTerm,
    );
  }
}
