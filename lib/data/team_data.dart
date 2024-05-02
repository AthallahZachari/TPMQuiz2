class Bio {
  String? name;
  String? nim;
  String? kelas;
  String? hobby;
  String? image;
  Bio({
    required this.name,
    required this.nim,
    required this.kelas,
    required this.hobby,
    required this.image,
  });
}

List<Bio> memberList = [
  Bio(
    name: 'Athallah Zachari',
    nim: '123210094',
    kelas: 'IF - H',
    hobby: 'Music, Gaming, Coding, Riding',
    image: 'profil.jpg',
  )
];
