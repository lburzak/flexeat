import 'package:flexeat/state/product_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit() : super(const ProductState());

  void save() {

  }

  void reportPrice(int price) {

  }

  void addPackaging(int weight) {

  }

  void setName(String text) {
    emit(state.copyWith(productName: text));
  }
}