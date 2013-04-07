﻿package {		import flash.display.MovieClip;	import flash.events.Event;	import flash.events.MouseEvent;	import flash.filters.GradientGlowFilter;	import flash.filters.BitmapFilterQuality;	import flash.filters.BitmapFilterType;		public class Main extends MovieClip {		var gradientGlow:GradientGlowFilter = new GradientGlowFilter();		var playStatus:Boolean = false;				public function Main() {			// constructor code			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);		}    		private function onAddedToStage(e:Event) {			gradientGlow.colors = [0xFFFFFF, 0xFFFF99, 0xFFFF00];			gradientGlow.alphas = [0, 0.52, 1];			gradientGlow.ratios = [0, 100];			gradientGlow.distance = 20;			gradientGlow.angle = 270;			gradientGlow.blurX = 30;			gradientGlow.blurY = 30;			gradientGlow.strength = 16;			gradientGlow.quality = BitmapFilterQuality.HIGH;			gradientGlow.type = BitmapFilterType.OUTER;						PlaySymbol.addEventListener(MouseEvent.MOUSE_DOWN, onPlaySymbolDown);			PlayButton.addEventListener(MouseEvent.MOUSE_DOWN, onPlaySymbolDown);			PlaySymbol.addEventListener(MouseEvent.MOUSE_UP, onPlaySymbolUp);			PlayButton.addEventListener(MouseEvent.MOUSE_UP, onPlaySymbolUp);		}				private function onPlaySymbolDown(e:MouseEvent) {			PlayButton.filters=[gradientGlow];		}				private function onPlaySymbolUp(e:MouseEvent) {			PlayButton.filters=[];			playStatus=!playStatus;			PlaySymbol.visible = !playStatus;			PauseSymbol.visible = playStatus;			if (playStatus) {				PlaySymbol.removeEventListener(MouseEvent.MOUSE_DOWN, onPlaySymbolDown);				PlaySymbol.removeEventListener(MouseEvent.MOUSE_UP, onPlaySymbolUp);				PauseSymbol.addEventListener(MouseEvent.MOUSE_DOWN, onPlaySymbolDown);				PauseSymbol.addEventListener(MouseEvent.MOUSE_UP, onPlaySymbolUp);			} else {				PlaySymbol.addEventListener(MouseEvent.MOUSE_DOWN, onPlaySymbolDown);				PlaySymbol.addEventListener(MouseEvent.MOUSE_UP, onPlaySymbolUp);				PauseSymbol.removeEventListener(MouseEvent.MOUSE_DOWN, onPlaySymbolDown);				PauseSymbol.removeEventListener(MouseEvent.MOUSE_UP, onPlaySymbolUp);			}		}			}	}