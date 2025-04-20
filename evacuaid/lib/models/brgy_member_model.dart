class BrgyMemberModel {
  final String? id;
  final String firstName;
  final String lastName;
  final int contactNumber;
  final bool isFamilyHead;
  final DateTime dateRegistered;
  final DateTime birthday;

  const BrgyMemberModel({
    this.id,
    required firstName,
    required lastName,
    required contactNumber,
    required isFamilyHead,
    required dateRegistered,
    required birthday
  });

  toJson() {
    return {
     "firstName": firstName,
     "lastName": lastName,
     "contactNumber": contactNumber,
     "isFamilyHead": isFamilyHead,
     "dateRegistered": dateRegistered,
     "birthday": birthday,
    };
  }
}