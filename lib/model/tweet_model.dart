import 'dart:convert';

class TweetModel {
  String? tweetid;
  String? tweet;
  String? currentdatetime;
  String? userid;
  TweetModel({
    this.tweetid,
    this.tweet,
    this.currentdatetime,
    this.userid,
  });

  TweetModel copyWith({
    String? tweetid,
    String? tweet,
    String? currentdatetime,
    String? userid,
  }) {
    return TweetModel(
      tweetid: tweetid ?? this.tweetid,
      tweet: tweet ?? this.tweet,
      currentdatetime: currentdatetime ?? this.currentdatetime,
      userid: userid ?? this.userid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tweetid': tweetid,
      'tweet': tweet,
      'currentdatetime': currentdatetime,
      'userid': userid,
    };
  }

  factory TweetModel.fromMap(Map<String, dynamic> map) {
    return TweetModel(
      tweetid: map['tweetid'],
      tweet: map['tweet'],
      currentdatetime: map['currentdatetime'],
      userid: map['userid'],
    );
  }

  String toJson() => json.encode(toMap());

  factory TweetModel.fromJson(String source) => TweetModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TweetModel(tweetid: $tweetid, tweet: $tweet, currentdatetime: $currentdatetime, userid: $userid)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is TweetModel &&
      other.tweetid == tweetid &&
      other.tweet == tweet &&
      other.currentdatetime == currentdatetime &&
      other.userid == userid;
  }

  @override
  int get hashCode {
    return tweetid.hashCode ^
      tweet.hashCode ^
      currentdatetime.hashCode ^
      userid.hashCode;
  }
}
