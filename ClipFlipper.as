package {
  import flash.display.*
  import flash.events.*
	import flash.filters.DropShadowFilter
	import flash.filters.BitmapFilterQuality
  import com.sikelianos.Flipper
    
  public class ClipFlipper extends MovieClip {

    public function ClipFlipper() {
      var front_clip = new Front();
      var back_clip = new Back();
      
      // params: ($front, $back, $flip_time=.5, $vertical_stretchiness=.3, $circular_flipping=true)
      var flipper = new Flipper(front_clip, back_clip, .4, .3, true);
      addChild(flipper);
      flipper.addEventListener(MouseEvent.ROLL_OVER, flipper.flip)
      flipper.addEventListener(MouseEvent.ROLL_OUT, flipper.flip)
      flipper.x = flipper.y = 100

      dropShadow();
    }
    
		private function dropShadow() {
      var color:Number = 0x000000;
      var angle:Number = 45;
      var alpha:Number = 1;
      var blurX:Number = 7;
      var blurY:Number = 7;
      var distance:Number = 6;
      var strength:Number = 0.5;
      var inner:Boolean = false;
      var knockout:Boolean = false;
      var quality:Number = BitmapFilterQuality.HIGH;
      var s:DropShadowFilter = new DropShadowFilter(distance, angle, color, alpha, blurX, blurY, strength, quality, inner, knockout);
      filters = [s];
		}
    
  }
}