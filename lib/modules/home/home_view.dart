import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:twitterclone/model/tweet_model.dart';
import 'package:twitterclone/modules/home/add_tweet_view.dart';
import 'package:twitterclone/modules/home/edit_tweet_view.dart';
import 'package:twitterclone/modules/welcome/welcome_view.dart';
import 'package:twitterclone/service/firestore_service.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final noimage =
      'https://images.unsplash.com/photo-1494790108377-be9c29b29330?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80';

  final FirestoreService firestoreService = FirestoreService();

  Future<void> logout() async {
    FirebaseAuth.instance.signOut();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User Signed out successfully')));
      Future.delayed(
        const Duration(seconds: 2),
        () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const WelcomeView(),
          ));
        },
      );
    }
  }

  Future<void> addATweet(BuildContext context, String tweet) async {
    try {
      await firestoreService.addATweet(text: tweet);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tweet Added Successfully')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  Future<void> editATweet(
      BuildContext context, String updatedTweet, String tweetID) async {
    try {
      await firestoreService.updateATweet(
          tweetdata: updatedTweet, tweetid: tweetID);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tweet Updated Successfully')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  Future<void> deleteATweet(BuildContext context, String tweetID) async {
    try {
      await firestoreService.deleteATweet(tweetid: tweetID);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tweet Deleted Successfully')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: FittedBox(
          child: CircleAvatar(
            maxRadius: 8,
            backgroundImage: NetworkImage(
              FirebaseAuth.instance.currentUser!.photoURL ?? noimage,
            ),
          ),
        ),
        title: Text(FirebaseAuth.instance.currentUser!.email!),
        actions: [
          IconButton(
            onPressed: () async => logout(),
            icon: const Icon(
              Icons.logout,
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (c) => WillPopScope(onWillPop: () async {
              return false;
            }, child: AddTweetView(
              onClickAdd: (tweet) {
                addATweet(context, tweet);
              },
            )),
          );
        },
        child: const Icon(Icons.add_outlined),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Tweets',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                )),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('tweets').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text(snapshot.error.toString());
                } else if (snapshot.hasData) {
                  final data = snapshot.data;
                  if (data != null) {
                    var docs = data.docs
                        .map((e) => TweetModel.fromMap(
                            e.data() as Map<String, dynamic>))
                        .toList();
                    docs.sort(
                      (a, b) {
                        final atime = DateTime.parse(a.currentdatetime!).microsecondsSinceEpoch;

                        final btime = DateTime.parse(b.currentdatetime!).microsecondsSinceEpoch;

                        return atime.compareTo(btime);
                      },
                    );

                    if (docs.isEmpty) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: const Center(child: Text("NO Tweets")),
                      );
                    } else {
                      return Scrollbar(
                        thickness: 8,
                        thumbVisibility: true,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          
                          child: ListView.builder(
                            itemCount: docs.length,
                            shrinkWrap: true,
                            
                            padding: const EdgeInsets.only(bottom: 60),
                            itemBuilder: (mcontext, index) {
                              final tweet = docs[index];

                              final ftime = DateFormat("MMMM d h:m:s").format(
                                  DateTime.parse(tweet.currentdatetime!)
                                      .toLocal());
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  elevation: 10,
                                  shadowColor: Colors.blueAccent,
                                  child: ListTile(
                                    title: Text(tweet.tweet ?? ""),
                                    subtitle: Text(ftime.toString()),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (c) => WillPopScope(
                                                  onWillPop: () async {
                                                    return false;
                                                  },
                                                  child: EditTweetView(
                                                    currentTweetText:
                                                        tweet.tweet ?? "",
                                                    onClickEdit: (utweet) {
                                                      editATweet(context, utweet,
                                                          tweet.tweetid!);
                                                    },
                                                  )),
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Colors.green,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () async => deleteATweet(
                                            context,
                                            tweet.tweetid!,
                                          ),
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    }
                  } else {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: const Center(child: Text("NO Tweets")),
                    );
                  }
                }
                return const SizedBox.shrink();
              },
            ),
          )
        ],
      ),
    );
  }
}
