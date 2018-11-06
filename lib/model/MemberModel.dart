class Member {
  String username;
  Null website;
  Null github;
  Null psn;
  String avatarNormal;
  Null bio;
  String url;
  Null tagline;
  Null twitter;
  int created;
  String avatarLarge;
  String avatarMini;
  Null location;
  Null btc;
  int id;

  Member(
      {this.username,
      this.website,
      this.github,
      this.psn,
      this.avatarNormal,
      this.bio,
      this.url,
      this.tagline,
      this.twitter,
      this.created,
      this.avatarLarge,
      this.avatarMini,
      this.location,
      this.btc,
      this.id});

  Member.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    website = json['website'];
    github = json['github'];
    psn = json['psn'];
    avatarNormal = json['avatar_normal'];
    bio = json['bio'];
    url = json['url'];
    tagline = json['tagline'];
    twitter = json['twitter'];
    created = json['created'];
    avatarLarge = json['avatar_large'];
    avatarMini = json['avatar_mini'];
    location = json['location'];
    btc = json['btc'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['website'] = this.website;
    data['github'] = this.github;
    data['psn'] = this.psn;
    data['avatar_normal'] = this.avatarNormal;
    data['bio'] = this.bio;
    data['url'] = this.url;
    data['tagline'] = this.tagline;
    data['twitter'] = this.twitter;
    data['created'] = this.created;
    data['avatar_large'] = this.avatarLarge;
    data['avatar_mini'] = this.avatarMini;
    data['location'] = this.location;
    data['btc'] = this.btc;
    data['id'] = this.id;
    return data;
  }
}
