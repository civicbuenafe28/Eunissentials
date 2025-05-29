import 'package:objectbox/objectbox.dart';

@Entity()
@Sync()
class User {
  @Id()
  int id;

  String username;
  String email;
  String passwordHash;
  String profilePictureUrl;
  double walletBalance;

  User({
    this.id = 0,
    required this.username,
    required this.email,
    required this.passwordHash,
    this.profilePictureUrl = '',
    this.walletBalance = 0.0,
  });
}
