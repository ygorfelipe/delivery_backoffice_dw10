import '../../models/payment_type_model.dart';

abstract class PaymentTypeRepository {
  //! o parametro bool, é para podermos fazer um filtro de se ele esta ativo ou não
  Future<List<PaymentTypeModel>> findAll(bool? enabled);
  Future<void> save(PaymentTypeModel model);
  Future<PaymentTypeModel> findById(int id);
}
