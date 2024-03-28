import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:practice1/login.dart';
import 'package:practice1/note.dart';
import 'package:flutter/material.dart';

void main() {
 runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyAppPage(),
    );
  }
}

class MyAppPage extends StatefulWidget {
  const MyAppPage({super.key});

  @override
  State<MyAppPage> createState() => _MyAppPageState();
}
int index = 0;
List<Map<String , dynamic>> datalist = [];
List<Map<String , dynamic>> favolist = [];
List<Map<String , dynamic>> searchList = [];
bool loginStates = false;
bool splash = false;

final bot1 = BottomNavigationBarItem(icon: Icon(Icons.home),label: 'home',backgroundColor: Colors.blue);
final bot2 = BottomNavigationBarItem(icon: Icon(Icons.search),label: 'search',backgroundColor: Colors.blue);
final bot3 = BottomNavigationBarItem(icon: Icon(Icons.favorite),label: 'favorite',backgroundColor: Colors.blue);
final bot4 = BottomNavigationBarItem(icon: Icon(Icons.settings),label: 'Edit',backgroundColor: Colors.blue);
final bot5 = BottomNavigationBarItem(icon: Icon(Icons.login),label: 'sign',backgroundColor: Colors.blue);
SnackBar snackBar(String title) {
  return SnackBar(content: Text(title),backgroundColor: Colors.blue,);
}
TextField normal(String title , TextEditingController controller) {
  return TextField(style: TextStyle(fontSize: 20.0),controller: controller,
  decoration: InputDecoration(labelText: title,labelStyle: TextStyle(fontSize: 20.0)),);
}
final email = TextEditingController();
final password = TextEditingController();
final signEmail = TextEditingController();
final signPassword = TextEditingController();
final up = TextEditingController();
final low = TextEditingController();
final num = TextEditingController();
final spc = TextEditingController();
final upL = TextEditingController();
final lowL = TextEditingController();
final numL = TextEditingController();
final spcL = TextEditingController();
final limit = TextEditingController();
final web = TextEditingController();
final webPassword = TextEditingController();
final editEmail = TextEditingController();
final editPassword = TextEditingController();
final search = TextEditingController();
String random(String? up , String? low , String? num , String? spc , int? uP , int? loW , int? nuM , int? spC , int? limit){
  up ??= '';
  low ??= '';
  num ??= '';
  spc ??='';
  uP ??= 0;
  loW??= 0;
  nuM??=0;
  spC??= 0;
  limit ??=0;
  final random = Random();
  String all = up + low + num + spc;
  String now = '';
  int UpI = 0;
  int lowI = 0;
  int spcI = 0;
  int numI = 0;
  for(int i = 0 ; i < limit ; i++){
    int noW = random.nextInt(all.length);
    String checker = all[noW];
    if(checker.toUpperCase() == checker && UpI <= uP){
      now += checker;
      UpI ++;
    } else if (checker.toLowerCase() == checker && lowI <= loW){
      now += checker;
      lowI ++;
    } else if (RegExp(r'[0123456789]').hasMatch(checker) && numI <= nuM){
      now += checker;
      numI++;
    } else if(RegExp('[~!@#\$%^&*(<>,./?\'\")_+\[\]\\|]').hasMatch(checker) && spcI <= spC){
      now += checker;
      spcI++;
    }
  }
  return now;
}
class _MyAppPageState extends State<MyAppPage> {
  void refresh() async {
    final data = await n().readAllLoginNote();
    final favo = await n().readAllLoginFavo();
    datalist = data;
    favolist = favo;
    loginStates = await l().isLogin();
    print(await l().isLogin());
  }
  TextButton logoutbtn(){
    return TextButton(
      onPressed: ()async {
      await l().logout();
      await n().logout();
      setState(() {
        loginStates = false;
        index = 0;
      });
    refresh();
    },
    child: Text('logout'),
    );
  }
  void initState() {
    super.initState();
    refresh();
  }
void reSearch() async {
  setState(() async {
    searchList = await n().search(search.text);
  });
}
  @override
  Widget build(BuildContext context) {
TextField forLimit(String title , TextEditingController controller , RegExp regExp) {
  return TextField(
    controller: controller,
    inputFormatters: [FilteringTextInputFormatter.allow(regExp)],
    decoration: InputDecoration(
        labelStyle: TextStyle(fontSize: 20.0),
        labelText: title
    ),
  );
}

void showFrom(TextEditingController web , TextEditingController password , int? id){
      refresh();
      if(id!=null){
        final data = datalist.firstWhere((element) => element['_id'] == id);
        web.text = data['_web'];
        password.text = data['_password'];
      }
      showModalBottomSheet(
          isScrollControlled: true,
          elevation: 5,
          context: context,
          builder: (_){
            return Scaffold(
                body: Container(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      children: [
                        normal('web', web),
                        normal('password', password),
                        TextButton(onPressed: (){
                          showModalBottomSheet(isScrollControlled: true,context: context, builder: (context){
                            return Scaffold(
                              body: Column(
                                children: [
                                  forLimit('which up', up , RegExp('[A-Z]')),
                                  normal('up limit', upL),
                                  forLimit('which low', low ,RegExp('[a-z]')),
                                  normal('low limit', lowL),
                                  forLimit('which num', num ,RegExp('[0-9]')),
                                  normal('num limit', numL),
                                  forLimit('which spc', spc,RegExp('[~!@#\$%^&*(<>,./?\'\")_+\[\]\\|]')),
                                  normal('spc limit', spcL),
                                  normal('limit' , limit),
                                  Expanded(child: SizedBox()),
                                  ElevatedButton(onPressed: (){
                                    password.text = random(up.text,
                                        low.text,
                                        num.text,
                                        spc.text,
                                        int.tryParse(upL.text),
                                        int.tryParse(lowL.text),
                                        int.tryParse(numL.text),
                                        int.tryParse(spcL.text),
                                        int.tryParse(limit.text)
                                    );
                                    Navigator.pop(context);
                                  }, child: Text('ger'),)
                                ],
                              ),
                            );
                          });
                        },child: Text('random password')),
                        Expanded(child: SizedBox()),
                        ElevatedButton(onPressed: ()async {
                          Navigator.pop(context);
                          if(id == null){
                            await n().insertNote(web.text, webPassword.text);
                          } else {
                            await n().Update(web.text, webPassword.text, id);
                          }
                          refresh();
                          web.text = '';
                          webPassword.text ='';
                        }, child: Text(id == null ? 'create' : 'update'))
                      ],
                    ),
                  ),
                )
            );
          });
      refresh();
    }
final bottoms = BottomNavigationBar(
  items: [bot1 , bot2 , bot3 , bot4 , bot5],
  currentIndex: index,
  onTap: (Index)async {
    if(Index == 0 || Index == 4){
      setState(() {
        index = Index;
      });
    } else if (await l().isLogin() == true){
      setState(() {
        index = Index;
      });
    } else{
      ScaffoldMessenger.of(context).showSnackBar(snackBar('login first'));
    }
  },
);
AppBar appBar (String title) {
  return AppBar(
    title: Text(title),
    actions: [loginStates == true ? logoutbtn() : SizedBox()],
    backgroundColor: Colors.blue,
  );
}
    Timer(
      Duration(seconds: 3), (){
        setState(() {
      splash = true;
        });
     }
    );
final favoPage = Scaffold(
  appBar: appBar('favorite'),
  body: Container(
    child: Padding(
      padding: EdgeInsets.all(30),
      child: ListView.builder(
          itemCount: favolist.length,
          itemBuilder: (context , index){
        bool click = favolist[index]['_favorite'] == 1;
        return Card(
          color: Colors.blue,
          child: ListTile(
            title: Text(favolist[index]['_web']),
            subtitle: Text(favolist[index]['_password']),
            trailing: SizedBox(width: 144.0,child: Row(
              children: [
                IconButton(onPressed: ()async {
                  await n().deleteNote(datalist[index]['_id']);
                  refresh();
                }, icon: Icon(Icons.delete)),
                IconButton(onPressed: ()async{
                  showFrom(web, webPassword, datalist[index]['_id']);
                  refresh();
                }, icon: Icon(Icons.edit)),
                IconButton(onPressed: ()async{
                  if(click){
                    await n().removeFavo(datalist[index]['_id']);
                    refresh();
                  } else {
                    await n().addFavorite(datalist[index]['_id']);
                    refresh();
                  }
                }, icon: Icon(click == true ? Icons.favorite : Icons.favorite_border))
              ],
            ),),
          ),
        );
      }),
    ),
  ),
  bottomNavigationBar: bottoms,
);
final searchBar = TextField(
  controller: search,
  style: TextStyle(fontSize: 20.0),
  decoration: InputDecoration(
    labelText: 'search',
    labelStyle: TextStyle(fontSize: 20.0)
  ),
  onChanged: (String a){
    reSearch();
  },
);
final noteBtn = FloatingActionButton(onPressed: (){
  showFrom(web, webPassword, null);
  refresh();
},child: Icon(Icons.add),);
final notePage = Scaffold(
  appBar: appBar('note'),
  body: Container(
    child:Padding(
      padding: EdgeInsets.all(30),
      child: ListView.builder(
        itemCount: datalist.length,
        itemBuilder: (BuildContext , index){
        bool click = datalist[index]['_favorite'] == 1;
        return Card(
          color: Colors.blue,
          child: ListTile(
            title: Text(datalist[index]['_web']),
            subtitle: Text(datalist[index]['_password']),
            trailing: SizedBox(width: 144.0,
            child: Row(
              children: [
                IconButton(onPressed: ()async {
                  await n().deleteNote(datalist[index]['_id']);
                  refresh();
                }, icon: Icon(Icons.delete)),
                IconButton(onPressed: ()async{
                  showFrom(web, webPassword, datalist[index]['_id']);
                  refresh();
                }, icon: Icon(Icons.edit)),
                IconButton(onPressed: ()async{
                  if(click){
                    await n().removeFavo(datalist[index]['_id']);
                    refresh();
                  } else {
                    await n().addFavorite(datalist[index]['_id']);
                    refresh();
                  }
        }, icon: Icon(click == true ? Icons.favorite : Icons.favorite_border))
              ],
            ),),
          ),
        );
      }),
    ),
  ),
  floatingActionButton: noteBtn,
  bottomNavigationBar: bottoms,
);
final loginBtn = ElevatedButton(onPressed: ()async {
  if(await l().matchEmail(email.text, password.text)){
    await l().login(email.text);
    await n().login(email.text);
    // print(loginStates);
    refresh();
  } else {
    ScaffoldMessenger.of(context).showSnackBar(snackBar('email not exists'));
  }
}, child: Text('login'));
final loginPage = Scaffold(
  appBar: appBar('login'),
  body: Container(
    child: Padding(
      padding: EdgeInsets.all(30),
      child: Column(
        children: [
          normal('email', email),
          normal('password', password),
          Expanded(child: SizedBox()),
          loginBtn,
          SizedBox(height: 100,)
        ],
      ),
    ),
  ),
  bottomNavigationBar: bottoms,
);
final Splash = Scaffold(
  body: Center(child: Icon(Icons.arrow_forward),),
);
final SignBtn = ElevatedButton(onPressed: ()async {
  if(await l().matchEmail(signEmail.text, signPassword.text)){
    ScaffoldMessenger.of(context).showSnackBar(snackBar('email already exists'));
  } else {
  await l().Sign(signEmail.text, signPassword.text);
  // await n().Sign(signEmail.text);
  ScaffoldMessenger.of(context).showSnackBar(snackBar('Sign finished you\'ll be logout and going login Page'));
  Timer(
    Duration(seconds: 3),(){
      setState(() async {
        await n().logout();
        await l().logout();
        loginStates = false;
        index = 0;
      });
   }
  );
  }
}, child: Text('sign'));
final SignPage = Scaffold(
  appBar: appBar('Sign'),
  body: Container(
    child: Padding(
      padding: EdgeInsets.all(30),
      child: Column(
        children: [
          normal('email', signEmail),
          normal('password', signPassword),
          Expanded(child: SizedBox()),
          SignBtn,
          SizedBox(height: 100.0,)
        ],
      ),
    ),
  ),
  bottomNavigationBar: bottoms,
);
final EditBtn = ElevatedButton(onPressed: ()async{
  if(await l().onlyEmail(editEmail.text)){
    ScaffoldMessenger.of(context).showSnackBar(snackBar('email already exists'));
  } else {
    await n().EditEmail(editEmail.text);
    Timer(Duration(seconds: 3),()async{await l().Update(editEmail.text, editPassword.text);});
    ScaffoldMessenger.of(context).showSnackBar(snackBar('Edit Finished'));
  }
}, child: Text('update'));
final EditPage = Scaffold(
  appBar: appBar('Edit'),
  body: Container(
    child: Padding(
      padding: EdgeInsets.all(30),
      child: Column(
        children: [
          normal('email', editEmail),
          normal('password', editPassword),
          Expanded(child: SizedBox()),
          EditBtn,
          SizedBox(height: 100.0,)
        ],
      ),
    ),
  ),
  bottomNavigationBar: bottoms,
);
final SearchPage = Scaffold(
  appBar: appBar('search'),
  body:Stack(
    children: [
      Column(
      children: [
        Padding(padding: EdgeInsets.all(30),child: searchBar,),
        Expanded(child:
        Padding(
          padding: EdgeInsets.all(30),
          child: ListView.builder(
              itemCount: searchList.length,
              itemBuilder: (context , index){
                bool click = searchList[index]['_favorite'] == 1;
                return Card(
                  color: Colors.blue,
                  child: ListTile(
                    title: Text(searchList[index]['_web']),
                    subtitle: Text(searchList[index]['_password']),
                    trailing: SizedBox(width: 144.0,
                      child: Row(
                        children: [
                          IconButton(onPressed: ()async {
                            await n().deleteNote(searchList[index]['_id']);
                            searchList = await n().search(search.text);
                            refresh();
                            reSearch();
                          }, icon: Icon(Icons.delete)),
                          IconButton(onPressed: ()async {
                            showFrom(web , webPassword , searchList[index]['_id']);
                            searchList = await n().search(search.text);
                            refresh();
                            reSearch();
                          }, icon: Icon(Icons.edit)),
                          IconButton(onPressed: ()async {
                            if(click){
                            await n().removeFavo(searchList[index]['_id']);
                            searchList = await n().search(search.text);
                            } else {
                              await n().addFavorite(searchList[index]['_id']);
                            searchList = await n().search(search.text);
                            refresh();
                            reSearch();
                            }
                            refresh();
                            reSearch();
                          }, icon: Icon(click ? Icons.favorite : Icons.favorite_border))
                        ],
                      ),
                    ),
                  ),
                );
              }),
            )
          ),
        ],
        ),
    ],
  ),
  bottomNavigationBar: bottoms,
);
    return (splash == false)
        ? Splash
        :(index == 4 && splash == true)
        ? SignPage
        : (loginStates == true && index == 0)
        ? notePage
        : (loginStates == true && index == 3)
        ? EditPage
        : (loginStates == true && index == 2)
        ? favoPage
        : (loginStates == true && index == 1)
        ? SearchPage
        : loginPage;
  }
}
//left search

