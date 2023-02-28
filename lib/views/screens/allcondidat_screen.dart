// ignore_for_file: depend_on_referenced_packages
import 'package:driving_getx/database/models/condidats.dart';
import 'package:driving_getx/logic/controllers/auth_controller.dart';
import 'package:driving_getx/logic/controllers/condidatcontroller.dart';
import 'package:driving_getx/main/utils/AppConstant.dart';
import 'package:driving_getx/main/utils/SDColors.dart';
import 'package:driving_getx/main/utils/SDStyle.dart';
import 'package:driving_getx/views/screens/condidat_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

class ListeAllCondidat extends StatefulWidget {
  const ListeAllCondidat({super.key});

  @override
  State<ListeAllCondidat> createState() => _ListeAllCondidatState();
}

class _ListeAllCondidatState extends State<ListeAllCondidat> {
  final AuthController authController = Get.put(AuthController());
  final CondidatController controller = Get.put(CondidatController());

  static const URLpic = 'https://smdev.tn/storage/condidat_pic/';
  double expandHeight = 200;

  late List<Condidat> Allcondidats = [];
  late List<Condidat> searchedForCharacters;
  final _searchTextController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await controller.getListCondidat();
      Allcondidats = controller.listeAll.value;
      /*  setState(() {}); */
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return _flexibleWidget(innerBoxIsScrolled);
            },
            body: controller.obx(
              (state) {
                return build_List_condidat();
              },
              onLoading: showLoadingIndicator(),
            )));
  }

  List<Widget> _flexibleWidget(innerBoxIsScrolled) {
    return <Widget>[
      SliverAppBar(
        expandedHeight: expandHeight,
        floating: true,
        automaticallyImplyLeading: false,
        forceElevated: innerBoxIsScrolled,
        pinned: true,
        titleSpacing: 0,
        backgroundColor: innerBoxIsScrolled ? db6_colorPrimary : sdPrimaryColor,
        actionsIconTheme: IconThemeData(opacity: 0.0),
        title: Row(children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 8, 0),
            child: Text("Sm-Dev",
                style: boldTextStyle(
                    color: db6_white, size: 15, fontFamily: fontBold)),
          ),
          Spacer(),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              Get.toNamed('/all_condidat');
            },
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Get.toNamed('/add_condidat');
            },
          )
        ]),
        flexibleSpace: FlexibleSpaceBar(
          background: Container(
            height: 200,
            margin: EdgeInsets.only(top: 70),
            color: sdPrimaryColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 2, 16, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                              child: Padding(
                                padding: EdgeInsets.only(right: 4),
                                child: Icon(Icons.article_outlined,
                                    color: db6_white, size: 16),
                              ),
                            ),
                            TextSpan(
                              text: 'Liste des condidats',
                              style: boldTextStyle(
                                  size: 17,
                                  color: Colors.white,
                                  letterSpacing: 0.5),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                _buildSearchField(),
              ],
            ),
          ),
        ),
      )
    ];
  }

  Widget _buildSearchField() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              color: white),
          alignment: Alignment.center,
          child: TextField(
            controller: _searchTextController,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              fillColor: db6_white,
              hintText: "Recherche",
              hintStyle: TextStyle(fontSize: 10),
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search),
              contentPadding: EdgeInsets.only(
                  left: 20.0, bottom: 11.0, top: 8.0, right: 50.0),
            ),
            onChanged: (searchedCondidat) {
              addSearchedFOrItemsToSearchedList(searchedCondidat);
            },
          )),
    );
  }

  void addSearchedFOrItemsToSearchedList(String searchedCharacter) {
    searchedForCharacters = Allcondidats.where((condidat) =>
        condidat.nom!.toLowerCase().startsWith(searchedCharacter)).toList();
    Allcondidats = _searchTextController.text.isEmpty
        ? controller.listeAll.value
        : searchedForCharacters;
    setState(() {});
  }

  Widget showLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        color: sdPrimaryColor,
      ),
    );
  }

  Widget build_List_condidat() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            //padding: EdgeInsets.only(bottom: 16),
            itemCount: _searchTextController.text.isEmpty
                ? Allcondidats.length
                : searchedForCharacters.length,
            //shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CondidatInfoScreen(
                        thisCondidat: _searchTextController.text.isEmpty
                            ? Allcondidats[index]
                            : searchedForCharacters[index],
                      ),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(left: 16, right: 16, top: 16),
                  padding:
                      EdgeInsets.only(left: 8, right: 0, top: 16, bottom: 16),
                  decoration: boxDecorations(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(shape: BoxShape.circle),
                        height: 45,
                        width: 45,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: FadeInImage(
                            fit: BoxFit.cover,
                            placeholder: AssetImage('images/app/loading.gif'),
                            image: Image.network(
                                    URLpic +
                                        (Allcondidats[index].photo! == ''
                                            ? 'unknown_profile.png'
                                            : Allcondidats[index].photo!),
                                    height: 35,
                                    width: 10)
                                .image,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                                Allcondidats[index].nom! +
                                    ' ' +
                                    Allcondidats[index].prenom!,
                                style: boldTextStyle(size: 13)),
                            Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                                  'Tel : ' +
                                      (Allcondidats[index].num_tel ?? " --"),
                                  style: secondaryTextStyle(size: 10)),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 5 * 1.5, // 30 px padding
                                        vertical: 10 / 5, // 5 px padding
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 233, 108, 108),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Text(
                                        "N° ToT : " +
                                            Allcondidats[index]
                                                .nbr_heur_total!
                                                .nb_heur_total!,
                                        style: secondaryTextStyle(
                                            size: 6, color: Colors.white),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 5 * 1.5, // 30 px padding
                                        vertical: 10 / 5, // 5 px padding
                                      ),
                                      decoration: BoxDecoration(
                                        color: kPrimaryColor,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Text(
                                        "N° Aff : " +
                                            Allcondidats[index]
                                                .nb_heur_affecter!
                                                .nb_heur_affecter!,
                                        style: secondaryTextStyle(
                                            size: 6, color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ))
                          ],
                        ),
                      ),
                      SizedBox(width: 20),
                      Container(height: 40, color: sdViewColor, width: 1),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 5 * 1.5, // 30 px padding
                                vertical: 10 / 5, // 5 px padding
                              ),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                "Examen : " +
                                    Allcondidats[index]
                                        .detail_examen!
                                        .type_examen!,
                                style: secondaryTextStyle(
                                    size: 8, color: Colors.black),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 5 * 1.5, // 30 px padding
                                vertical: 10 / 5, // 5 px padding
                              ),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                Allcondidats[index].detail_examen!.date_examen!,
                                style: secondaryTextStyle(
                                    size: 8, color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            color: kPrimaryColor,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CondidatInfoScreen(
                                    thisCondidat:
                                        _searchTextController.text.isEmpty
                                            ? Allcondidats[index]
                                            : searchedForCharacters[index],
                                  ),
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.navigate_next_outlined,
                              size: 20,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}




























/* // ignore: must_be_immutable
class ListeAllCondidat extends GetView<ListeCondidatController> {
 
}
 */