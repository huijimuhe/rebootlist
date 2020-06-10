import 'package:flutter/material.dart';
import 'package:rebootlist/res/styles.dart';
import 'package:rebootlist/router/router.dart';
import 'package:rebootlist/state/app_state.dart';
import 'package:scoped_model/scoped_model.dart';

class TaskListPage extends StatefulWidget {
  TaskListPage({Key key}) : super(key: key);

  @override
  _TaskListPageState createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey _backdropKey = GlobalKey(debugLabel: 'Backdrop');

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppState>(
        builder: (BuildContext context, Widget child, AppState model) =>
            _build(context, model));
  }

  Widget _build(BuildContext context, AppState model) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).backgroundColor,
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Router.goBack(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 22,
              color: Theme.of(context).primaryColor,
            ),
          ),
          title: Container(
            child: Text(
              '记录列表',
              style: TextStyles.textMain14,
            ),
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.filter_list,
                size: 22,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
        body: _buildBody(context, model));
  }

  Widget _buildBody(BuildContext context, AppState model) {

  }
}
