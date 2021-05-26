import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vbetcom/Common/Global.dart';
import 'package:vbetcom/Views/Login/LoginView.dart';

import 'Widgets.dart';

const double MARGINNORMAL = 16;
const double CHIPBORDERRADIUS = 30;
const double MARGINSMALL = 8;
const double PADDINGSMALL = 8;

enum HorizontalStepState { SELECTED, UNSELECTED }

enum Type { TOP, BOTTOM }

class HorizontalStep {
  final String title;
  final Widget widget;
  bool isValid;
  HorizontalStepState state;

  HorizontalStep({
    @required this.title,
    @required this.widget,
    this.state = HorizontalStepState.UNSELECTED,
    this.isValid,
  });
}

class HorizontalStepper extends StatefulWidget {
  final List<HorizontalStep> steps;
  final Color selectedColor;
  final double circleRadius;
  final Color unSelectedColor;
  final Color selectedOuterCircleColor;
  final TextStyle textStyle;
  final Color leftBtnColor;
  final Color rightBtnColor;
  final Type type;
  final VoidCallback onComplete;
  final Color btnTextColor;

  HorizontalStepper({
    this.steps,
    this.selectedColor,
    this.circleRadius,
    this.unSelectedColor,
    this.selectedOuterCircleColor,
    this.textStyle,
    this.type = Type.TOP,
    @required this.leftBtnColor,
    @required this.rightBtnColor,
    this.btnTextColor,
    @required this.onComplete,
  });

  @override
  State<StatefulWidget> createState() => HorizontalStepperState(
    steps: this.steps,
    selectedColor: selectedColor,
    unSelectedColor: unSelectedColor,
    circleRadius: circleRadius,
    selectedOuterCircleColor: selectedOuterCircleColor,
    textStyle: textStyle,
    type: type,
    leftBtnColor: leftBtnColor,
    rightBtnColor: rightBtnColor,
    onComplete: onComplete,
    btnTextColor: btnTextColor,
  );
}

class HorizontalStepperState extends State<StatefulWidget> {
  final List<HorizontalStep> steps;
  final Color selectedColor;
  final Color unSelectedColor;
  final double circleRadius;
  final TextStyle textStyle;
  final Type type;
  final Color leftBtnColor;
  final Color rightBtnColor;
  final VoidCallback onComplete;
  final Color btnTextColor;

  Color selectedOuterCircleColor;
  PageController controller;
  int currentStep = 0;

  HorizontalStepperState({
    this.steps,
    this.selectedColor,
    this.circleRadius,
    this.unSelectedColor,
    this.selectedOuterCircleColor,
    this.textStyle,
    this.type,
    this.leftBtnColor,
    this.rightBtnColor,
    this.onComplete,
    this.btnTextColor,
  });

  @override
  void initState() {
    controller = PageController();
    controller.addListener(() {
      if (!steps[currentStep].isValid) {
        controller.jumpToPage(currentStep);
      }
    });
    super.initState();
  }

  void changeStatus(int index) {
    if (isForward(index)) {
      markAsCompletedForPrecedingSteps();
    } else {
      markAsUnselectedToSucceedingSteps();
    }
    setState(() {
      currentStep = index;
      steps[index].state = HorizontalStepState.SELECTED;
    });
  }

  void markAsUnselectedToSucceedingSteps() {
    for (int i = steps.length - 1; i >= currentStep; i--) {
      steps[i].state = HorizontalStepState.UNSELECTED;
    }
  }

  void markAsCompletedForPrecedingSteps() {
    for (int i = 0; i <= currentStep; i++) {
      steps[i].state = HorizontalStepState.SELECTED;
    }
  }

  bool isLast(int index) {
    return steps.length - 1 == index;
  }

  void goToNextPage() {
    if (isLast(currentStep)) {
      onComplete.call();
    }
    if (currentStep < steps.length - 1) {
      currentStep++;
      setState(() {});
      controller.jumpToPage(currentStep);
    }
  }

  void goToPreviousPage() {
    if (currentStep > 0) {
      currentStep--;
      controller.jumpToPage(currentStep);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: type == Type.TOP
          ? getTopTypeWidget(width)
          : getBottomTypeWidget(width),
    );
  }

  List<Widget> getBottomTypeWidget(double width) {
    return [
      getPageWidgets(),
      getIndicatorWidgets(width),
      SizedBox(
        height: MARGINSMALL,
      ),
      getTitleWidgets(),
      getButtons()
    ];
  }

  Widget getPageWidgets() {
    return Expanded(
      child: PageView(
        controller: controller,
        onPageChanged: (index) => setState(() {
          changeStatus(index);
        }),
        children: getPages(),
      ),
    );
  }

  Widget getTitleWidgets() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: getTitles(),
    );
  }

  Widget getIndicatorWidgets(double width) {
    return Container(
      width: width,
      padding: const EdgeInsets.only(
        left: 24,
        right: 24,
        top: PADDINGSMALL,
      ),
      child: Container(
          child:
      Column(
      children: [
    Center(
    child: Container(
    width: 100,
    child:Row(
      children: getStepCircles(),
    ))),]))
          // Column(
          //   children: <Widget>[
          //     Row(
          //       children: getStepCircles(),
          //     )
          //   ],
          //)),
    );
  }

  List<Widget> getTopTypeWidget(double width) {
    return [
      getIndicatorWidgets(width),
      SizedBox(
        height: MARGINSMALL,
      ),
      getTitleWidgets(),
      getPageWidgets(),
      getButtons()

    ];
  }

  Widget getButtons() {
    return Column(
      children: [
        (currentStep==0)?
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            getThemeButton("Next", themeGreen, context, true, (){
              steps[currentStep].isValid ? goToNextPage() : null;
            }),
          ],
        ):Container(),
        (currentStep==1)?
        Padding(padding: EdgeInsets.only(left: 20,right: 20),child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: getThemeButton("Back", themeGreen, context, true, (){
                goToPreviousPage();
              }),
            ),
            SizedBox(width: 5,),
            Expanded(
              child:getThemeButton("Next", themeGreen, context, true, (){
                steps[currentStep].isValid ? goToNextPage() : null;
              }),
            )
          ],
        ),):Container(),

        Container(
          margin: EdgeInsets.only(bottom: 16, top: 13),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: GestureDetector(
                  child: Text(
                    "Already have an account? Sign in",
                    style: GoogleFonts.openSans(
                        color: themeWhite
                    ),
                  ),
                  onTap: () async {
                    var result = await Navigator.push(context, MaterialPageRoute(
                        builder: (context)=>LoginView()
                    ));

                  },
                ),
              )
            ],
          ),
        ),
      ],
    );

  }

  List<Widget> getTitles() {
    return steps
        .map((e) => Flexible(
      child: Text(
        e.title,
        style: textStyle ??
            TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
      ),
    ))
        .toList();
  }

  List<Widget> getStepCircles() {
    List<Widget> widgets = [];
    steps.asMap().forEach((key, value) {
      widgets.add(StepCircle(value,key, circleRadius, selectedColor,
          unSelectedColor, selectedOuterCircleColor));
      if (key != steps.length - 1) {
        widgets.add(StepLine(
          steps[key + 1],
          selectedColor,
          unSelectedColor,
        ));
      }
    });
    return widgets;
  }

  List<Widget> getPages() {
    return steps.map((e) => e.widget).toList();
  }

  bool isForward(int index) {
    return index > currentStep;
  }
}

class StepLine extends StatelessWidget {
  final HorizontalStep step;
  final Color selectedColor;
  final Color unSelectedColor;

  StepLine(
      this.step,
      this.selectedColor,
      this.unSelectedColor,
      );

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
          margin: const EdgeInsets.only(
            left: 4,
            right: 4,
          ),
          height: 2,
          color:unSelectedColor,
          // color: step.state == HorizontalStepState.SELECTED
          //     ? selectedColor
          //     : unSelectedColor,
        ));
  }
}

class StepCircle extends StatelessWidget {
  final HorizontalStep step;
  final int value;
  final double circleRadius;
  final Color selectedColor;
  final Color unSelectedColor;
  final Color selectedOuterCircleColor;

  StepCircle(
      this.step,
      this.value,
      this.circleRadius,
      this.selectedColor,
      this.unSelectedColor,
      this.selectedOuterCircleColor,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: circleRadius,
      width: circleRadius,
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: getColor(),
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(circleRadius),
        ),
      ),
      child:
      Container(
            decoration: BoxDecoration(
              color: step.state == HorizontalStepState.SELECTED
                  ? selectedColor
                  : Colors.transparent,
              borderRadius: BorderRadius.all(
                Radius.circular(
                  circleRadius,
                ),
              ),
            ),
                child: Center(child: Text((value+1).toString(),style: TextStyle(fontSize: 13, color: step.state == HorizontalStepState.SELECTED
                    ? Colors.white
                    : unSelectedColor,),),),
      ),

    );
  }

  Color getColor() {
    if (step.state == HorizontalStepState.SELECTED) {
      return selectedOuterCircleColor != null
          ? selectedOuterCircleColor
          : selectedColor;
    }
    return unSelectedColor;
  }
}