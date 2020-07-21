import 'package:cloud_firestore/cloud_firestore.dart';

final pCollectionUsers = "users";
final pCollectionContacts = "contacts";
final pCollectionChannels = "channels";
final pPublicChannels = "public-channels";

final firestoreInstance = Firestore.instance;

final pChannelDetails = "details";
final pChannellastMessage = "lastMessage";
final pchannelmeta = "meta";
final pchannelmessages = "messages";
final pchannelRead = "read";
final pchannelUsers = "users";