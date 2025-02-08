import '../global/global.dart';

class ApiConstants {
  static const String baseUrl = apiBaseUrl;

  /// Auth
  static const String signup = "/auth/signup"; // POST
  static const String login = "/auth/login"; // POST
  static const String changePassword = "/auth/change-password"; // PUT

  /// User
  static const String userDetails = "/user/details"; // GET
  static const String users = "/user/users"; // GET
  static const String updateProfile = "/user/update-profile"; // PUT

  /// Chat
  static const String chats = "/chat/chats?receiver="; // GET
  static const String sendMessage = "/chat/send-message"; // post
  static const String deleteMessage =
      "/chat/delete-message?messageId="; // DELETE
}
