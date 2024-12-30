import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Provider/profile_provider.dart';
import 'package:provider/provider.dart';
import '../Provider/auth_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../server_config.dart';

enum FilterOption { arabic, english }

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    bool isauth = Provider.of<Auth>(context, listen: false).isauth;
    final localization = AppLocalizations.of(context);
    const ip = Serverconfig.ip;
    const host = '$ip:8000';

    final profile = Provider.of<Profile>(context, listen: false).profile[0];
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            FutureBuilder(
              future:
                  Provider.of<Profile>(context, listen: false).fetchingdata(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Container(
                    color: Colors.amber[50],
                    width: double.infinity,
                    height: MediaQuery.sizeOf(context).height * 0.32,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 41.5),
                          child: CircleAvatar(
                            backgroundImage: profile.profileImage != null
                                ? CachedNetworkImageProvider(
                                    'http://$host/${profile.profileImage}',
                                  )
                                : const AssetImage('assets/images/holder.jpg')
                                    as ImageProvider,
                            radius: MediaQuery.sizeOf(context).height * 0.06,
                          ),
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "${profile.name}",
                              style: GoogleFonts.robotoCondensed(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (isauth)
                              IconButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/edit_profile');
                                },
                                icon: const Icon(Icons.mode_edit_outline),
                              )
                          ],
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                const Icon(
                                  Icons.wallet,
                                  size: 23,
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  localization!.wallet,
                                  style: GoogleFonts.robotoCondensed(
                                    fontSize: 24,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  profile.pocket != null
                                      ? "${profile.pocket} ${localization.sdollar}"
                                      : "0",
                                  style: GoogleFonts.robotoCondensed(
                                    fontSize: 16,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
            const SizedBox(
              height: 40,
            ),
            Container(
              width: MediaQuery.sizeOf(context).width * 0.55,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                border:
                    Border.all(width: 1, color: Theme.of(context).primaryColor),
                borderRadius: BorderRadius.circular(5),
              ),
              child: ListTile(
                onTap: () => Navigator.of(context)
                    .pushNamedAndRemoveUntil('/tabs', (route) => false),
                leading: const Icon(
                  color: Colors.black,
                  Icons.home,
                  size: 26,
                ),
                title: Text(
                  localization!.home,
                  style: GoogleFonts.robotoCondensed(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Container(
              width: MediaQuery.sizeOf(context).width * 0.55,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                border:
                    Border.all(width: 1, color: Theme.of(context).primaryColor),
                borderRadius: BorderRadius.circular(5),
              ),
              child: ListTile(
                onTap: () {
                  Navigator.pushNamed(context, '/orders');
                },
                leading: const Icon(
                  color: Colors.black,
                  Icons.wallet_travel_sharp,
                  size: 26,
                ),
                title: Text(
                  localization.oreders,
                  style: GoogleFonts.robotoCondensed(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Container(
              width: MediaQuery.sizeOf(context).width * 0.55,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                border:
                    Border.all(width: 1, color: Theme.of(context).primaryColor),
                borderRadius: BorderRadius.circular(5),
              ),
              child: PopupMenuButton(
                onSelected: (FilterOption selectedlocal) {
                  if (selectedlocal == FilterOption.arabic) {
                    Provider.of<Auth>(context, listen: false).changeLocal(
                      const Locale('ar', ''),
                    );
                  } else {
                    Provider.of<Auth>(context, listen: false).changeLocal(
                      const Locale('en', ''),
                    );
                  }
                },
                icon: const Icon(
                  Icons.flag_circle_outlined,
                  color: Colors.red,
                  size: 30,
                ),
                itemBuilder: (_) => [
                  const PopupMenuItem(
                    value: FilterOption.arabic,
                    child: Text('🇸🇾'),
                  ),
                  const PopupMenuItem(
                    value: FilterOption.english,
                    child: Text('🇬🇧'),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () async {
                var whatsapp = "+963933000741";
                var whatsappURl = "whatsapp://send?phone=$whatsapp";
                if (await canLaunchUrl(Uri.parse(whatsappURl))) {
                  await launchUrl(
                    Uri.parse(whatsappURl),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('whatsapp not installed')));
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.green,
                ),
                width: MediaQuery.sizeOf(context).width * 0.5,
                child: ListTile(
                  leading: const Icon(
                    FontAwesomeIcons.whatsapp,
                    color: Colors.white,
                    size: 20,
                  ),
                  title: Text(
                    localization.clickheretocontactus,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.19,
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/');
                Provider.of<Auth>(context, listen: false).logout();
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
              label: Text(
                localization.logout,
                style: GoogleFonts.robotoCondensed(
                  fontSize: 22,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
