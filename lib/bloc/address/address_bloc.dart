import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:matrix/models/address.dart';
import 'package:matrix/services/address_repository.dart';
import './bloc.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  @override
  AddressState get initialState => AddressLoading();

  @override
  Stream<AddressState> mapEventToState(
    AddressEvent event,
  ) async* {
    if (event is LoadAddresss) {
      yield* _mapLoadAddresssToState(event.userId);
    }
  }

  Stream<AddressState> _mapLoadAddresssToState(String userId) async* {
    yield AddressLoading();
    try {
      final AddressRepository repository = AddressRepository();

      yield AddressLoading();
      final Stream<List<AddressModel>> data = repository.streamAddress(userId);
      yield AddressLoaded(data: data);
    } catch (e) {
      yield AddressFailed();
    }
  }
}

