import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatdemo/AppData.dart';
import 'package:chatdemo/custom_widgets/custom_raised_button.dart';
import 'package:image_picker/image_picker.dart';
import '../custom_widgets/index.dart';
import '../utils/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'authentication/index.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var _usernameController = TextEditingController();
  var _emailController = TextEditingController();
  var _phonenumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _usernameController.text = AppData.instance.currentUserdata.meta.name;
    _emailController.text = AppData.instance.currentUserdata.meta.email;
    _phonenumberController.text = AppData.instance.currentUserdata.meta.phone;
  }

  @override
  Widget build(BuildContext context) {
    var verticalspace = 15.0;
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Profile'),
        actions: <Widget>[
          // new FlatButton(
          //     child: new Text('Logout',
          //         style: new TextStyle(fontSize: 17.0, color: black)),
          //     onPressed: signOut)
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(left: verticalspace, right: verticalspace),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 50),
            profilePic(),
            SizedBox(height: 30),
            CustomtextField(
              controller: _usernameController,
              textInputAction: TextInputAction.next,
              hinttext: "Name",
              onFieldSubmitted: (_) {
                FocusScope.of(context).nextFocus();
              },
            ),
            SizedBox(height: verticalspace),
            CustomtextField(
              controller: _emailController,
              hinttext: "Email",
              textInputAction: TextInputAction.none,
              enabled: false,
              onFieldSubmitted: (_) {
                FocusScope.of(context).nextFocus();
              },
            ),
            SizedBox(height: verticalspace),
            CustomtextField(
              controller: _phonenumberController,
              textInputAction: TextInputAction.done,
              hinttext: "Phone Number",
              onFieldSubmitted: (_) {
                FocusScope.of(context).unfocus();
              },
            ),
            SizedBox(height: verticalspace),
            CustomRaisedButton(
              text: "Update",
              buttonColor: sky,
              textColor: white,
              borderRadius: 8.0,
              fontSize: 20.0,
              onPressed: () {
                _onUpdatePress(context);
              },
              // onCustomButtonPressed: _onUpdatePress(context),
              context: context,
            )
          ],
        ),
      ),
    );
  }

  _onUpdatePress(BuildContext context) async {
    if (_image != null) {
      var url = await AppData.instance.uploadFile(_image);

      var userData = AppData.instance.currentUserdata;
      userData.meta.name = _usernameController.text;
      userData.meta.nameLowercase = _usernameController.text.toLowerCase();
      userData.meta.phone = _phonenumberController.text;
      userData.meta.photoUrl = url;
      AppData.instance.updateProfile(userData);
    } else {
      var userData = AppData.instance.currentUserdata;
      userData.meta.name = _usernameController.text;
      userData.meta.nameLowercase = _usernameController.text.toLowerCase();
      userData.meta.phone = _phonenumberController.text;

      AppData.instance.updateProfile(userData);
    }
  }

  Widget profilePic() {
    return new Hero(
      tag: 'hero',
      child: Align(
        alignment: Alignment.center,
        child: SizedBox(
            width: 150,
            height: 150,
            child: InkWell(
              onTap: () {
                getImage();
              },
              child: Stack(
                children: <Widget>[
                  _image != null
                      ? ClipOval(
                          child: Image.file(
                            _image,
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset('assets/defaultavatar.jpg');
                            },
                          ),
                        )
                      : ClipOval(
                          child: CachedNetworkImage(
                            imageUrl:
                                AppData.instance.currentUserdata.meta.photoUrl,
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Image.asset('assets/defaultavatar.jpg'),
                          ),
                        ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Icon(
                      Icons.edit,
                      color: Colors.black,
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }

  signOut() async {
    AppData.instance.currentUserId = "";
    AppData.instance.dispose();
    BlocProvider.of<AuthenticationBloc>(context).add(
      AuthenticationLoggedOut(),
    );
  }

  // Code for Image Picker:
  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile.path);
    });
  }
}
