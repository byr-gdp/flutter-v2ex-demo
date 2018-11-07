import './MemberModel.dart';
import './NodeModel.dart';

/**
 * 帖子详情接口：https://www.v2ex.com/api/topics/show.json?id=504530
 */

class TopicDetailModel {
  Node node;
  Member member;
  String lastReplyBy;
  int lastTouched;
  String title;
  String url;
  int created;
  String content;
  String contentRendered;
  int lastModified;
  int replies;
  int id;

  TopicDetailModel(
      {this.node,
      this.member,
      this.lastReplyBy,
      this.lastTouched,
      this.title,
      this.url,
      this.created,
      this.content,
      this.contentRendered,
      this.lastModified,
      this.replies,
      this.id});

  TopicDetailModel.fromJson(Map<String, dynamic> json) {
    node = json['node'] != null ? new Node.fromJson(json['node']) : null;
    member =
        json['member'] != null ? new Member.fromJson(json['member']) : null;
    lastReplyBy = json['last_reply_by'];
    lastTouched = json['last_touched'];
    title = json['title'];
    url = json['url'];
    created = json['created'];
    content = json['content'];
    contentRendered = json['content_rendered'];
    lastModified = json['last_modified'];
    replies = json['replies'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.node != null) {
      data['node'] = this.node.toJson();
    }
    if (this.member != null) {
      data['member'] = this.member.toJson();
    }
    data['last_reply_by'] = this.lastReplyBy;
    data['last_touched'] = this.lastTouched;
    data['title'] = this.title;
    data['url'] = this.url;
    data['created'] = this.created;
    data['content'] = this.content;
    data['content_rendered'] = this.contentRendered;
    data['last_modified'] = this.lastModified;
    data['replies'] = this.replies;
    data['id'] = this.id;
    return data;
  }
}
