import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lesson_flutter/pages/menu_selection.dart';

class Walkthrough extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);
    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );
    final introKey = GlobalKey<IntroductionScreenState>();

    void _onIntroEnd(context) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => MenuSelection()),
      );
    }

    Widget _buildImage(String assetName) {
      return Image.asset(
        'assets/$assetName.png',
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height - 100.0,
        fit: BoxFit.cover,
      );
    }

    return IntroductionScreen(
      key: introKey,
      pages: [
        PageViewModel(
          titleWidget: SizedBox.shrink(),
          decoration: PageDecoration(
            imagePadding: EdgeInsets.all(0.0),
            contentPadding: EdgeInsets.all(0.0),
            titlePadding: EdgeInsets.all(0.0),
          ),
          bodyWidget: _buildImage('walkthrough1'),
        ),
        PageViewModel(
          titleWidget: SizedBox.shrink(),
          decoration: PageDecoration(
            imagePadding: EdgeInsets.all(0.0),
            contentPadding: EdgeInsets.all(0.0),
            titlePadding: EdgeInsets.all(0.0),
          ),
          bodyWidget: _buildImage('walkthrough2'),
        ),
        PageViewModel(
          titleWidget: SizedBox.shrink(),
          decoration: PageDecoration(
            imagePadding: EdgeInsets.all(0.0),
            contentPadding: EdgeInsets.all(0.0),
            titlePadding: EdgeInsets.all(0.0),
          ),
          bodyWidget: _buildImage('walkthrough3'),
        ),
      ],
      onDone: () => _onIntroEnd(context),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipFlex: 0,
      nextFlex: 0,
      skip: const Text('Skip'),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }
}
