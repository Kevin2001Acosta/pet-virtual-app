//Modelo de registro
class UserRegister {
  final String name;
  final String email;
  final String password;
  final String petName;
 
  UserRegister({
    required this.name, 
    required this.email,
    required this.password,
    required this.petName, });

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'password': password,
        'petName': petName,
        
      };
}

//Modelo de login
class UserLogin {
  final String email;
  final String password;
 
  UserLogin({
    required this.email,
    required this.password });

  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,  
      };
}
