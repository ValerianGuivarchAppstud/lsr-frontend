
import 'package:flutter/material.dart';
import 'package:lsr/view/modules/roll/RollView.dart';

import '../../../utils/Injector.dart';
import '../../widgets/StatRow.dart';
import 'RollPresenter.dart';
import 'RollState.dart';
import 'RollWidget.dart';


class RollPage extends StatefulWidget {
  RollPage({required Key key}) : super(key: key);

  @override
  _RollPageState createState() => _RollPageState();
}



class _RollPageState extends State<RollPage> with RollView {
  late RollPresenter presenter;
  late TextEditingController noteFieldController;

  @override
  void initState() {
    super.initState();
    noteFieldController  = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    presenter = /*(widget.initPresenter != null
        ? widget.initPresenter(this)
        : */RollPresenter(
        view: this, interactor: Injector.of(context).sheetService);
//    presenter.triggerLoad();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    tearDown(); // from RollView
    presenter.tearDown();
    noteFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery
        .of(context)
        .size;
    return StreamBuilder<RollState>(
      stream: presenter.stream,
      initialData: presenter.latest,
      builder: (context, rollState) {
        return Scaffold(
          body: Container(
            height: size.height,
            width: size.width,
            color: Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: RollWidget(
                key: Key("RollState"),
                character: rollState.data?.character,
                loading: rollState.data?.showLoading ?? true,
                error: rollState.data?.error,
                size: size,
                noteFieldController: noteFieldController,
              presenter : presenter),
        )
        )
        );
      },
    );
  }
}
