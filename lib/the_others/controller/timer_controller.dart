import 'dart:async';

class TimerController {
  Timer? _timer;

  void executeAfter(Function timeElapsed, int milliseconds){
    stop();

    _timer = Timer(Duration(milliseconds: milliseconds), (){
      timeElapsed.call();
    });
  }

  void executePeriodically(Function timeElapsed, int milliseconds){
    stop();
    
    _timer = Timer.periodic(Duration(milliseconds: milliseconds), (t) {
      timeElapsed.call();
    });
  }

  void stop(){
    if(_timer != null){
      _timer!.cancel();
      _timer = null;
    }
  }
}