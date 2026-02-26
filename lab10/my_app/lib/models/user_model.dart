class UserModel {
  final int? id; // id เป็น int? เพราะตอนสร้างใหม่ (POST) อาจยังไม่มี id [cite: 73, 151]
  final String email;
  final String username;
  final String password;
  final NameModel name; // เชื่อมไปยังคลาส NameModel [cite: 71, 155]
  final AddressModel address; // เชื่อมไปยังคลาส AddressModel [cite: 72, 156]
  final String phone;

  UserModel({
    this.id,
    required this.email,
    required this.username,
    required this.password,
    required this.name,
    required this.address,
    required this.phone,
  });

  // ใช้แปลง JSON จาก API มาเป็น Dart Object [cite: 13, 76, 167]
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      name: NameModel.fromJson(json['name'] ?? {}), // ดึงข้อมูล name ที่ซ้อนอยู่ [cite: 85, 173]
      address: AddressModel.fromJson(json['address'] ?? {}), // ดึงข้อมูล address ที่ซ้อนอยู่ [cite: 86, 174]
      phone: json['phone'] ?? '',
    );
  }

  // ใช้แปลง Dart Object กลับเป็น JSON เพื่อส่งขึ้น API [cite: 14, 90, 178]
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'email': email,
      'username': username,
      'password': password,
      'name': name.toJson(), // แปลง NameModel เป็น JSON [cite: 97, 187]
      'address': address.toJson(), // แปลง AddressModel เป็น JSON [cite: 98, 188]
      'phone': phone,
    };
    if (id != null) data['id'] = id; // ส่ง id ไปเฉพาะกรณีที่ไม่เป็น null [cite: 180]
    return data;
  }
}

// --- คลาสย่อยสำหรับจัดการข้อมูลที่ซ้อนกัน ---

class NameModel {
  final String firstname;
  final String lastname;

  NameModel({required this.firstname, required this.lastname});

  factory NameModel.fromJson(Map<String, dynamic> json) {
    return NameModel(
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'firstname': firstname,
    'lastname': lastname,
  };
}

class AddressModel {
  final String city;
  final String street;
  final int number;
  final String zipcode;
  final GeoLocationModel geolocation;

  AddressModel({
    required this.city,
    required this.street,
    required this.number,
    required this.zipcode,
    required this.geolocation,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      city: json['city'] ?? '',
      street: json['street'] ?? '',
      // ป้องกัน Error หาก API ส่งตัวเลขมาเป็นรูปแบบอื่น [cite: 119, 121, 221]
      number: (json['number'] is num) ? (json['number'] as num).toInt() : 0,
      zipcode: json['zipcode'] ?? '',
      geolocation: GeoLocationModel.fromJson(json['geolocation'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    'city': city,
    'street': street,
    'number': number,
    'zipcode': zipcode,
    'geolocation': geolocation.toJson(),
  };
}

class GeoLocationModel {
  final String lat;
  final String long;

  GeoLocationModel({required this.lat, required this.long});

  factory GeoLocationModel.fromJson(Map<String, dynamic> json) {
    return GeoLocationModel(
      // แปลงค่าเป็น String เสมอเพื่อความเสถียร [cite: 125, 127, 239]
      lat: (json['lat'] ?? '').toString(),
      long: (json['long'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'lat': lat,
    'long': long,
  };
}