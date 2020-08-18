import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coding_blocks_junior/app/locator.dart';
import 'package:coding_blocks_junior/models/user_profile.dart';
import 'package:coding_blocks_junior/services/session.dart';
import 'package:coding_blocks_junior/ui/views/login/view.dart';
import 'package:coding_blocks_junior/utils/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:stacked/stacked.dart';

class DashboardProfileViewModel extends FutureViewModel {
  SessionService sessionService = locator<SessionService>();
  final GlobalKey<FormBuilderState> _fbKey = GlobalKey<FormBuilderState>();
  UserProfile profile;
  BuildContext context;

  DashboardProfileViewModel({this.context});

  FirebaseUser get user => sessionService.user;
  get name => user.isAnonymous ? 'Hello, Anonymous' : user.displayName;
  get fbKey => _fbKey;


  void logout() async{
    await sessionService.logout();
    notifyListeners();
  }

  void login () async {
    showBottomSheet(
        elevation: 2,
        context: context,
        builder: (context) => LoginView(onClose: this.notifyListeners));
  }

  void saveProfile() async{
    if (!_fbKey.currentState.saveAndValidate())
      return ;

    final state = _fbKey.currentState.value;

    // update profile data
    await profile.snapshot.reference.updateData({
      'classGroup': state['classGroup']
    });

    // update user data
    await user.updateEmail(state['email']);

    Scaffold.of(context).showSnackBar(snackBarFromText('Saved Successfully!',));
  }

  @override
  Future futureToRun() async{
    if (user.isAnonymous) 
      return null;
    
    final userProfilesCollection = Firestore.instance.collection('user_profiles');
    
    final query = await userProfilesCollection
        .where("userId", isEqualTo: user.uid)
        .getDocuments();

    var snapshot;

    if (query.documents.length == 0) {
      final ref = await userProfilesCollection.add({
        "userId": user.uid
      });
      snapshot = await userProfilesCollection.document(ref.documentID);
    } else {
      snapshot = query.documents[0];
    }

    profile = UserProfile.fromSnapshot(snapshot);

    print(profile);
  }
}
