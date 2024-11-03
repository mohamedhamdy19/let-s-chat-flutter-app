class Message {
  String message, time, id;

  Message(this.message, this.time, this.id);

  factory Message.fromJson(jsonData) {
    return Message(jsonData['message'], jsonData['time'], jsonData['id']);
  }
}

class User {
  String username;
  User(this.username);
  factory User.fromJson(jsonData) {
    return User(jsonData["username"]);
  }
}
