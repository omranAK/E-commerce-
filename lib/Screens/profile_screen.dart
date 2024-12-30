// ignore_for_file: prefer_if_null_operators, body_might_complete_normally_nullable
import 'package:flutter/material.dart';
import 'package:project_2/Provider/profile_provider.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../server_config.dart';

class ProfileScreen extends StatefulWidget {
  static const routename = '/edit_profile';
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    const ip = Serverconfig.ip;
    const host = '$ip:8000';
    ProfileData profile = Provider.of<Profile>(context).profile[0];
    final Map<String, String> data = {
      'email': profile.email!,
      'name': profile.name!,
      'prof_image': profile.profileImage != null ? profile.profileImage! : '',
      'phone': profile.phonnumber!
    };
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: const BorderSide(color: Colors.white),
                ),
                backgroundColor: Theme.of(context).primaryColor),
            onPressed: () {
              if (!_formKey.currentState!.validate()) {
                return;
              }
              _formKey.currentState!.save();
              Provider.of<Profile>(context, listen: false)
                  .editprofile(data)
                  .then((value) => Provider.of<Profile>(context, listen: false)
                      .fetchingdata());
            },
            child: Text(
              localization!.save,
              style: const TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  Consumer<Profile>(builder: (context, value, child) {
                    value.selectedimage != null
                        ? data['prof_image'] = value.selectedimage!.path
                        : data['prof_image'] = profile.profileImage != null
                            ? profile.profileImage!
                            : '';
                    return CircleAvatar(
                      backgroundImage: value.selectedimage != null
                          ? FileImage(File(value.selectedimage!.path))
                          : profile.profileImage != null
                              ? CachedNetworkImageProvider(
                                  'http://$host/${profile.profileImage}')
                              : const AssetImage('assets/images/holder.jpg')
                                  as ImageProvider,
                      radius: 50,
                    );
                  }),
                  Positioned(
                    bottom: -12,
                    right: 0,
                    child: IconButton(
                      onPressed: () async {
                        Provider.of<Profile>(context, listen: false)
                            .pickImage();
                      },
                      icon: const Icon(
                        Icons.camera_alt,
                        color: Colors.black,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Text(
              '${profile.name}',
              style: const TextStyle(fontSize: 25),
            ),
            const SizedBox(
              height: 15,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.8,
                    child: TextFormField(
                      initialValue: profile.name,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(top: 15),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).primaryColor),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Colors.black,
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return localization.invalidname;
                        }
                      },
                      onSaved: (newValue) {
                        data['name'] = newValue!;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.8,
                    child: TextFormField(
                      initialValue: profile.email,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(top: 15),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).primaryColor),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        prefixIcon: const Icon(
                          Icons.email,
                          color: Colors.black,
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty || !value.contains('@')) {
                          return localization.invalidemail;
                        }
                      },
                      onSaved: (newValue) {
                        data['email'] = newValue!;
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.8,
                    child: TextFormField(
                      keyboardType: TextInputType.phone,
                      initialValue: profile.phonnumber,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(top: 15),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Theme.of(context).primaryColor),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        prefixIcon: const Icon(
                          Icons.phone_android,
                          color: Colors.black,
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty ||
                            value.length < 10 && value.length > 10) {
                          return localization.invalidphone;
                        }
                      },
                      onSaved: (newValue) {
                        data['phone'] = newValue!;
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
