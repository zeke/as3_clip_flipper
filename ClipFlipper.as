package {
  import flash.display.*
  import com.sikelianos.Flipper
    
  public class ClipFlipper extends MovieClip {

    public function ClipFlipper() {
      var front = new Front();
      var back = new Back();
      var flipper = new Flipper(front, back);
      addChild(flipper);
    }
    
  }
}