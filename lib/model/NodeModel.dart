class Node {
  String avatarLarge;
  String name;
  String avatarNormal;
  String title;
  String url;
  int topics;
  String footer;
  String header;
  String titleAlternative;
  String avatarMini;
  int stars;
  bool root;
  int id;
  String parentNodeName;

  Node(
      {this.avatarLarge,
      this.name,
      this.avatarNormal,
      this.title,
      this.url,
      this.topics,
      this.footer,
      this.header,
      this.titleAlternative,
      this.avatarMini,
      this.stars,
      this.root,
      this.id,
      this.parentNodeName});

  Node.fromJson(Map<String, dynamic> json) {
    avatarLarge = json['avatar_large'];
    name = json['name'];
    avatarNormal = json['avatar_normal'];
    title = json['title'];
    url = json['url'];
    topics = json['topics'];
    footer = json['footer'];
    header = json['header'];
    titleAlternative = json['title_alternative'];
    avatarMini = json['avatar_mini'];
    stars = json['stars'];
    root = json['root'];
    id = json['id'];
    parentNodeName = json['parent_node_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['avatar_large'] = this.avatarLarge;
    data['name'] = this.name;
    data['avatar_normal'] = this.avatarNormal;
    data['title'] = this.title;
    data['url'] = this.url;
    data['topics'] = this.topics;
    data['footer'] = this.footer;
    data['header'] = this.header;
    data['title_alternative'] = this.titleAlternative;
    data['avatar_mini'] = this.avatarMini;
    data['stars'] = this.stars;
    data['root'] = this.root;
    data['id'] = this.id;
    data['parent_node_name'] = this.parentNodeName;
    return data;
  }
}