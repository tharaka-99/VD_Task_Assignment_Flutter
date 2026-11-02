import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String mobileNumber;
  final String? token;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.mobileNumber,
    this.token,
  });

  @override
  List<Object?> get props => [id, name, email, mobileNumber, token];
}

