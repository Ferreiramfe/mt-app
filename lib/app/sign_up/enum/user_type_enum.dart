extension UserTypeEnumExtension on UserTypeEnum {
  static const Map types = <String, UserTypeEnum>{
    'STUDENT': UserTypeEnum.student,
    'PERSONAL_TRAINER': UserTypeEnum.personal_trainer
  };

  static UserTypeEnum getValue(String value) {
    if(types.containsKey(value)) {
      return types[value];
    }
    return UserTypeEnum.student;
  }

  String get name {
    return toString().toUpperCase();
  }
}

enum UserTypeEnum {
  student, personal_trainer
}