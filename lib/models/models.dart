// User Model
class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String role; // 'user' | 'admin' | 'staff'
  final String? avatarUrl;
  final String? token;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
    this.avatarUrl,
    this.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] ?? '',
        fullName: json['fullName'] ?? '',
        email: json['email'] ?? '',
        role: json['role'] ?? 'user',
        avatarUrl: json['avatarUrl'],
        token: json['token'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'fullName': fullName,
        'email': email,
        'role': role,
        'avatarUrl': avatarUrl,
        'token': token,
      };
}

// Facility Model
class FacilityModel {
  final String id;
  final String name;
  final String address;
  final String type; // 'belediye' | 'banka' | 'ptt' | 'noter' | 'hastane'
  final double rating;
  final bool isOpen;
  final String openHours;
  final int estimatedWaitMinutes;
  final List<DepartmentModel> departments;
  final String? imageUrl;

  FacilityModel({
    required this.id,
    required this.name,
    required this.address,
    required this.type,
    required this.rating,
    required this.isOpen,
    required this.openHours,
    required this.estimatedWaitMinutes,
    required this.departments,
    this.imageUrl,
  });
}

// Department Model
class DepartmentModel {
  final String id;
  final String name;
  final String facilityId;
  final String icon;
  final List<StaffModel> staff;
  final int currentQueueLength;

  DepartmentModel({
    required this.id,
    required this.name,
    required this.facilityId,
    required this.icon,
    required this.staff,
    required this.currentQueueLength,
  });
}

// Staff Model
class StaffModel {
  final String id;
  final String name;
  final String title;
  final String departmentId;
  final double rating;
  final int currentQueueLength;
  final int estimatedWaitMinutes;
  final bool isAvailable;
  final String? avatarUrl;

  StaffModel({
    required this.id,
    required this.name,
    required this.title,
    required this.departmentId,
    required this.rating,
    required this.currentQueueLength,
    required this.estimatedWaitMinutes,
    required this.isAvailable,
    this.avatarUrl,
  });
}

// Queue Entry Model
class QueueEntryModel {
  final String id;
  final String userId;
  final String staffId;
  final String staffName;
  final String facilityName;
  final String departmentName;
  int position;
  int estimatedWaitMinutes;
  String status; // 'waiting' | 'called' | 'completed' | 'cancelled'
  final DateTime joinedAt;

  QueueEntryModel({
    required this.id,
    required this.userId,
    required this.staffId,
    required this.staffName,
    required this.facilityName,
    required this.departmentName,
    required this.position,
    required this.estimatedWaitMinutes,
    required this.status,
    required this.joinedAt,
  });
}

// Notification Model
class NotificationModel {
  final String id;
  final String title;
  final String message;
  final String type; // 'queue' | 'appointment' | 'update' | 'message'
  final DateTime time;
  bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.time,
    required this.isRead,
  });
}

// Chat Message Model
class ChatMessageModel {
  final String id;
  final String content;
  final bool isUser;
  final DateTime time;

  ChatMessageModel({
    required this.id,
    required this.content,
    required this.isUser,
    required this.time,
  });
}

// Chat Session Model
class ChatSessionModel {
  final String id;
  final String userId;
  final List<ChatMessageModel> messages;
  final DateTime createdAt;

  ChatSessionModel({
    required this.id,
    required this.userId,
    required this.messages,
    required this.createdAt,
  });
}
