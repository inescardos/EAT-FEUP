import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:uni/controller/local_storage/app_eat_at_feup_database.dart';
import 'package:uni/model/entities/meal_.dart';
import 'package:uni/utils/constants.dart';
import 'package:uni/view/Pages/EatingPlacesPages/general_eating_place_page.dart';
import 'package:uni/view/Widgets/eatAtFeup/eating_place_card.dart';

import '../../../controller/eat_at_feup/preferences.dart';
import '../../../model/app_state.dart';
import '../../../model/entities/eat_at_feup_preference.dart';
import '../../Widgets/navigation_drawer.dart';
import '../../Widgets/page_title.dart';
import '../EatingPlacesPages/eating_places_map.dart';
import '../general_page_view.dart';
import 'eat_at_feup_general_page_view.dart';


List<EatAtFeupPreference>  getPreferencesmm() {

  EatAtFeupDatabase preferencesDB = EatAtFeupDatabase();
  // List<EatAtFeupPreference> preferences = await preferencesDB.preferences();
  List<EatAtFeupPreference> preferences;
  preferencesDB.preferences().then((value) => preferences = value);
  return preferences;
}
List<EatAtFeupPreference>  getPreferences()  {
  final List<EatAtFeupPreference> preferences = [];
  preferences.add(EatAtFeupPreference(parseFoodType("vegetariano"), true, 0));
  preferences.add(EatAtFeupPreference(parseFoodType("carne"), true, 1));
  return preferences;
}

class EatAtFeupPreferencesPage extends StatefulWidget {
  const EatAtFeupPreferencesPage({Key key}) : super(key: key);

  @override
  _EatAtFeupPreferencesState createState() => _EatAtFeupPreferencesState();
}

class _EatAtFeupPreferencesState extends GeneralEatingPlacePageState {

  EatAtFeupDatabase preferencesDB;

  List<EatAtFeupPreference> preferences;

  final List<int> _items = List<int>.generate(5, (int index) => index);


  /*
  @override
  Widget getBody(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color oddItemColor = colorScheme.primary.withOpacity(0.05);
    final Color evenItemColor = colorScheme.primary.withOpacity(0.15);
    // getPreferences().then((value) => preferences = value);
    // if(preferences == null){
    // }
    // preferences = [];
    // preferences.add(EatAtFeupPreference(parseFoodType("vegetariano"), true, 0));
    // preferences.add(EatAtFeupPreference(parseFoodType("carne"), true, 1));




    return Scaffold(
      body: Center(
        child: ReorderableListView(
          buildDefaultDragHandles:false,  //Remove default drag handles
          padding: const EdgeInsets.symmetric(horizontal: 10),
          onReorder: (int oldIndex, int newIndex) {
            setState(() {
              if (oldIndex < newIndex) {
                newIndex -= 1;
              }
              final EatAtFeupPreference item = preferences.removeAt(oldIndex);
              for(var pref in preferences){
                if( newIndex <= pref.order &&  pref.order < oldIndex ) {
                  pref.order++;
                }else if( oldIndex < pref.order &&  pref.order <= newIndex ) {
                  pref.order--;
                }
              }
              preferences.insert(newIndex, item);
              preferences[newIndex].order = newIndex;
              preferencesDB.saveNewPreferences(preferences);
            });
          },
          children:
            preferences.map((task) => Container(
              key: ValueKey(task.order),
              decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  border: Border.all(width: 1, color: Colors.green)),
              child: ListTile(
                contentPadding: const EdgeInsets.all(10),
                leading: getFoodTypeIcon(task.foodType),
                title: Text(
                  '${task.foodType}',
                  style: const TextStyle(fontSize: 14),
                ),
                    trailing: ReorderableDragStartListener(index:task.order,child: const Icon(Icons.drag_indicator_outlined)),   //Wrap it inside drag start event listener
              ),
            ))
                .toList(),
          // ],
        ),
      ),
    );
  }

   */
  DateTime lastUpdateTime;
  DateFormat updateTimeFormat = DateFormat.jm();

  @override
  Widget getScaffold(BuildContext context, Widget body) {
    body = StoreConnector<AppState, List<EatAtFeupPreference>>(
        converter: (store) => store.state.content['eatAtFeupPreferences'],
        builder: (context, preferences) {
          // preferences.clear();
          // if(preferences.length != 5){
          //   preferences = EatAtFeupPreference.getDefaultPreferences();
          // }
          ReorderableListView rList;
          final List<Widget> widgetList = [];
          widgetList.add(PageTitle(name: 'Minhas Preferências'));
          Future.delayed(Duration(seconds: 2));
          if (preferences.isEmpty) {
            widgetList.add(Center(child: Text('\nNão tem preferências\n')));
          } else {
            rList = ReorderableListView(
              shrinkWrap: true,
              buildDefaultDragHandles:false,  //Remove default drag handles
              padding: const EdgeInsets.symmetric(horizontal: 10),
              onReorder: (int oldIndex, int newIndex) {
                setState(() {
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  final EatAtFeupPreference item = preferences.removeAt(
                      oldIndex);
                  for (var pref in preferences) {
                    if (newIndex <= pref.order && pref.order < oldIndex) {
                      pref.order++;
                    }
                    else if (oldIndex < pref.order && pref.order <= newIndex) {
                      pref.order--;
                    }
                  }
                    preferences.insert(newIndex, item);
                    preferences[newIndex].order = newIndex;
                }
                );
              }, children:  preferences.map((task) => Container(
              key: ValueKey(task.foodType),
              decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  border: Border.all(width: 1, color: Colors.green)),
              child: ListTile(
                contentPadding: const EdgeInsets.all(10),
                leading: getFoodTypeIcon(task.foodType),
                title: Text(
                  '${task.foodType}',
                  style: const TextStyle(fontSize: 14),
                ),
                trailing: ReorderableDragStartListener(index:task.order,child: const Icon(Icons.drag_indicator_outlined)),   //Wrap it inside drag start event listener
              ),
            ))
                .toList(),
            );
            lastUpdateTime = DateTime.now();
            widgetList.add(Column(children: <Widget>[rList]));
            widgetList.add(Text(
                'última atualização às ${updateTimeFormat.format(lastUpdateTime)}',
                textAlign: TextAlign.center));
          }
          return ListView(children: widgetList);
        });

    return Scaffold(
        appBar: buildAppBar(context),
        drawer: NavigationDrawer(parentContext: context),
        body: this.refreshState(context, body),
        floatingActionButton:
        Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          SizedBox(
            height: 20,
          ),
          FloatingActionButton(
              key: Key("create_reservation"),
              onPressed: () {  },
              child: const Icon(Icons.add))
        ]));
  }
}
