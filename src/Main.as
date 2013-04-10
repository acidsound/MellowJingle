﻿package {import flash.display.MovieClip;import flash.events.Event;import flash.events.MouseEvent;import flash.filters.BitmapFilterQuality;import flash.filters.DropShadowFilter;import flash.net.URLRequest;import flash.media.Sound;import flash.media.SoundChannel;public class Main extends MovieClip {  private var dropShadow:DropShadowFilter = new DropShadowFilter();  private var dropInnerShadow:DropShadowFilter = new DropShadowFilter();  private var playStatus:Boolean = false;  private var titleHeader = "Nostalgic Jingle ";  private var playList:Array;  private var playIndex:int = 0;  private var soundLoader:Sound = new Sound();  private var soundChannel:SoundChannel = new SoundChannel();  public function Main() {    // constructor code    addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);    playList = [      "001",      "002",      "003",      "004",      "005",      "006",      "007",      "008",      "009",      "010",      "011",      "012",      "013",      "014",      "015",      "016",      "017",      "018",      "019",      "020",      "021",      "022",      "023",      "024",      "025",      "026",      "027",      "028",      "029",      "030",      "031",      "032",      "033"    ];  }  private function onAddedToStage(e:Event) {    dropShadow.blurX = 60;    dropShadow.blurY = 60;    dropShadow.strength = 2.4;    dropShadow.quality = BitmapFilterQuality.HIGH;    dropShadow.angle = 270;    dropShadow.distance = 5;    dropShadow.color = 0xFFFFFF;    dropInnerShadow.blurX = 60;    dropInnerShadow.blurY = 60;    dropInnerShadow.strength = 2.4;    dropInnerShadow.quality = BitmapFilterQuality.HIGH;    dropInnerShadow.angle = 270;    dropInnerShadow.distance = 5;    dropInnerShadow.inner = true;    dropInnerShadow.color = 0xFFFFFF;    PlaySymbol.addEventListener(MouseEvent.MOUSE_DOWN, onPlaySymbolDown);    PlaySymbol.addEventListener(MouseEvent.MOUSE_UP, onPlaySymbolUp);    PreviousSymbol.addEventListener(MouseEvent.MOUSE_DOWN, onPreviousSymbolDown);    PreviousSymbol.addEventListener(MouseEvent.MOUSE_UP, onPreviousSymbolUp);    setCurrentJingle();  }  private function setCurrentJingle() {    var jinglePath = new URLRequest("./media/mp3_192/" + titleHeader + playList[playIndex] + ".mp3");    soundLoader.load(jinglePath);  }  private function onPlaySymbolDown(e:MouseEvent) {    PlaySymbol.filters = [dropShadow, dropInnerShadow];    PauseSymbol.filters = [dropShadow, dropInnerShadow];  }  private function onPlaySymbolUp(e:MouseEvent) {    PlaySymbol.filters = [];    PauseSymbol.filters = [];    playStatus = !playStatus;    PlaySymbol.visible = !playStatus;    PauseSymbol.visible = playStatus;    if (playStatus) {      PlaySymbol.removeEventListener(MouseEvent.MOUSE_DOWN, onPlaySymbolDown);      PlaySymbol.removeEventListener(MouseEvent.MOUSE_UP, onPlaySymbolUp);      PauseSymbol.addEventListener(MouseEvent.MOUSE_DOWN, onPlaySymbolDown);      PauseSymbol.addEventListener(MouseEvent.MOUSE_UP, onPlaySymbolUp);      playCurrentTrack();    } else {      PlaySymbol.addEventListener(MouseEvent.MOUSE_DOWN, onPlaySymbolDown);      PlaySymbol.addEventListener(MouseEvent.MOUSE_UP, onPlaySymbolUp);      PauseSymbol.removeEventListener(MouseEvent.MOUSE_DOWN, onPlaySymbolDown);      PauseSymbol.removeEventListener(MouseEvent.MOUSE_UP, onPlaySymbolUp);      pauseCurrentTrack();    }  }  private function onPreviousSymbolDown(e:MouseEvent) {    PreviousSymbol.filters = [dropShadow, dropInnerShadow];		onPlaySymbolUp(e);		playIndex = playIndex ? playIndex-1 : playIndex;		setCurrentJingle();  }  private function onPreviousSymbolUp(e:MouseEvent) {    PreviousSymbol.filters = [];  }  private function playCurrentTrack() {    if (playStatus) {      soundChannel.stop();      soundChannel = soundLoader.play(0);    } else {      soundChannel.stop();    }  }  private function pauseCurrentTrack() {    soundChannel.stop();  }}}