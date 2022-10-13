import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:twitterclone/model/tweet_model.dart';


class FirestoreService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final tweetsCollection = FirebaseFirestore.instance.collection('tweets');

  Future<bool> addATweet({required String text}) async {
    try {
      var tweet = TweetModel(
          currentdatetime: DateTime.now().toLocal().toString(),
          tweet: text,
          userid: firebaseAuth.currentUser!.uid);

      try {
        await tweetsCollection.add(tweet.toMap()).then((value) async {
          await tweetsCollection.doc(value.id).update({'tweetid': value.id});
        });

        return true;
      } catch (e) {
        throw e.toString();
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<bool> updateATweet(
      {required String tweetid, required String tweetdata}) async {
    try {
      await firestore.collection('tweets').doc(tweetid).update(
          {'tweet': tweetdata, 'currentdatetime': DateTime.now().toString()});
      return true;
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> deleteATweet({required String tweetid}) async {
    await firestore.collection('tweets').doc(tweetid).delete();
  }
}
