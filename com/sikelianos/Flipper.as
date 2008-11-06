package com.sikelianos {
  import flash.display.*
  import flash.geom.*
  import flash.events.*
	import flash.filters.*
  import com.sikelianos.*
  import fl.transitions.easing.Regular

  public class Flipper extends MovieClip {
    var front_tweener:DistortionTweener
    var back_tweener:DistortionTweener
    var front:MovieClip
    var back:MovieClip
    var front_holder:Sprite
    var back_holder:Sprite
    var w:Number
    var h:Number
    var stretch:Number
    var left_edge:Number
    var right_edge:Number
    
    // Parameters
    var flip_time:Number // total time to flip clip, in seconds
    var vertical_stretchiness:Number // 0 is none, 1 is too much
    var circular_flipping:Boolean // if set to false, clip will flip back and forth
    var drop_shadow:Boolean
    
    public function Flipper($front, $back, $flip_time=.5, $vertical_stretchiness=.3, $circular_flipping=true, $drop_shadow=true) {
      front = $front
      back = $back
      flip_time = $flip_time
      vertical_stretchiness = $vertical_stretchiness
      circular_flipping = $circular_flipping
      drop_shadow = $drop_shadow
      addEventListener(Event.ADDED_TO_STAGE, init)
    }

    public function init(e:Event) {      
      x = y = 100
      
      useHandCursor = true;
      buttonMode = true;
      addEventListener(MouseEvent.CLICK, startFlipToBack)
      
      front_holder = new MovieClip();
      back_holder = new MovieClip();
      
      addChild(front)
      addChild(back);
      addChild(front_holder);
      addChild(back_holder);
      back_holder.visible = false
      
      // Dimensions of the front image
      w = front.width
      h = front.height
      
      // Amount to stretch the image vertically during flipping
      stretch = h*vertical_stretchiness

      // These points, just left and right of the middle of the image, are used to determine how
      // much the clips will 'squeeze' before appearing to flip over. We don't want to use the exact middle 
      // because the clip appears to be moving quickly when it crosses the middle.
      // The shorter the flip_time, the larger the gap
      var gap = (flip_time>=1) ? w/10/flip_time : w/10
      left_edge = w/2 - gap
      right_edge = w/2 + gap
      
      // Front tweener starts off flat. Back tweener starts of tweaked
      front_tweener = new DistortionTweener(front_holder, front, new Point(0, 0), new Point(w, 0), new Point(w, h), new Point(0, h), 5)
      back_tweener = new DistortionTweener(back_holder, back, new Point(left_edge, stretch), new Point(right_edge, -stretch), new Point(right_edge, h+stretch), new Point(left_edge, h-stretch), 5)
      
      if (drop_shadow) { dropShadow() }
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

    public function startFlipToBack(e:MouseEvent) {
      removeEventListener(MouseEvent.CLICK, startFlipToBack)
      front_tweener.addEventListener(Event.COMPLETE, finishFlipToBack);
      front_tweener.tweenTo(new Point(left_edge, -stretch), new Point(right_edge, stretch), new Point(right_edge, h-stretch), new Point(left_edge, h+stretch), Regular.easeIn, flip_time/2);
    }
    
    public function finishFlipToBack(e:Event):void {
      swapFrontAndBackVisibility();
      front_tweener.removeEventListener(Event.COMPLETE, finishFlipToBack);
      back_tweener.tweenTo(new Point(0, 0), new Point(w, 0), new Point(w, h), new Point(0, h), Regular.easeOut, flip_time/2);
      back_tweener.addEventListener(Event.COMPLETE, enableFrontFlipping);
    }
    
    public function startFlipToFront(e:MouseEvent) {
      removeEventListener(MouseEvent.CLICK, startFlipToFront)
      back_tweener.addEventListener(Event.COMPLETE, finishFlipToFront);
      if (circular_flipping) {
        back_tweener.tweenTo(new Point(left_edge, -stretch), new Point(right_edge, stretch), new Point(right_edge, h-stretch), new Point(left_edge, h+stretch), Regular.easeIn, flip_time/2);
        front_tweener.tweenTo(new Point(left_edge, stretch), new Point(right_edge, -stretch), new Point(right_edge, h+stretch), new Point(left_edge, h-stretch), Regular.easeIn, .001);        
      } else {
        back_tweener.tweenTo(new Point(left_edge, stretch), new Point(right_edge, -stretch), new Point(right_edge, h+stretch), new Point(left_edge, h-stretch), Regular.easeIn, flip_time/2);  
      }
    }
    
    public function finishFlipToFront(e:Event):void {
      swapFrontAndBackVisibility();
      back_tweener.removeEventListener(Event.COMPLETE, finishFlipToFront);
      front_tweener.tweenTo(new Point(0, 0), new Point(w, 0), new Point(w, h), new Point(0, h), Regular.easeOut, flip_time/2);
      front_tweener.addEventListener(Event.COMPLETE, enableBackFlipping);
      if (circular_flipping) {
        back_tweener.tweenTo(new Point(left_edge, stretch), new Point(right_edge, -stretch), new Point(right_edge, h+stretch), new Point(left_edge, h-stretch), Regular.easeIn, .001);  
      }
    }
        
    public function enableFrontFlipping(e:Event) {
      addEventListener(MouseEvent.CLICK, startFlipToFront)
      back_tweener.removeEventListener(Event.COMPLETE, enableFrontFlipping); 
    }
    
    public function enableBackFlipping(e:Event) {
      addEventListener(MouseEvent.CLICK, startFlipToBack) 
      front_tweener.removeEventListener(Event.COMPLETE, enableBackFlipping)
      // removeEventListener(MouseEvent.CLICK, startFlipToFront)
    }
    
    public function swapFrontAndBackVisibility() {
      front_holder.visible = !front_holder.visible
      back_holder.visible = !back_holder.visible
    }
    
  }

}