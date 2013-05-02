package {

import flash.display.MovieClip;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.net.URLRequest;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.filesystem.File;
import flash.desktop.NativeApplication;
import flash.desktop.SystemIdleMode;
import flash.display.StageScaleMode;
import flash.system.Capabilities;
import flash.utils.Dictionary;

public class Main extends MovieClip {
  private var playStatus:Boolean = false;
  private var frames:Object = {
    "swipeleft": 1,
    "swipeleftDone": 20,
    "swipeRight": 21,
    "swipeRightDone": 40,
    "save": 41,
    "saveDone": 45,
    "about": 46,
    "aboutDone": 50
  }
  private var titleHeader = "Mellow Jingle ";
  private var playList:Array = ["001", "002", "003", "004", "005", "006", "007", "008", "009", "010", "011", "012", "013", "014", "015", "016", "017", "018", "019", "020", "021", "022", "023", "024", "025", "026", "027", "028", "029", "030", "031", "032", "033"];
  private var playIndex:int = 0;
  private var prevPlayIndex:int = 0;
  private var soundLoader:Sound;
  private var soundChannel:SoundChannel = new SoundChannel();
  private var TrackInformation:String;
  private var os = Capabilities.os;

  private var isDone:Boolean = false;

  NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;

  public function Main() {
    stage.scaleMode = StageScaleMode.NO_SCALE;
    var longerOne = stage.fullScreenWidth > stage.fullScreenHeight ? stage.fullScreenWidth : stage.fullScreenHeight;
    trace("os: " + os);
    trace("DPI: " + Capabilities.screenDPI);
    trace("width/height: " + width + "/" + height);
    trace("x/y: " + x + ":" + y);
    trace("stage.fullScreenWidth/Height: " + stage.fullScreenWidth + "/" + stage.fullScreenHeight);
    trace("stage.width/height: " + stage.width + "/" + stage.height);
    trace("stage.stageWidth/stage.stageHeight: " + stage.stageWidth + "/" + stage.stageHeight);

    if (Capabilities.screenDPI < 240) {
      scaleX = 0.5;
      scaleY = 0.5;
      x = stage.stageWidth * scaleX * scaleX;
      y = stage.stageHeight * scaleY * scaleY;
    }
    addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    addEventListener(Event.ENTER_FRAME, onEnterFrame);
  }

  public function onAddedToStage(e:Event) {
    gotoAndStop(frames["swipeleftDone"]);
    TrackInformation = TrackFrame.TrackText.TrackInformationText.htmlText;

    if (os.indexOf("iPhone") < 0) {
      SaveFrame.SaveMessageSymbol.iOSSaveMessageText.visible = false;
    } else {
      SaveFrame.SaveMessageSymbol.AndroidSaveMessageText.visible = false;
    }

    PlaySymbol.addEventListener(MouseEvent.MOUSE_DOWN, onPlaySymbolDown);
    PlaySymbol.addEventListener(MouseEvent.MOUSE_UP, onPlaySymbolUp);
    PlaySymbol.addEventListener(MouseEvent.RELEASE_OUTSIDE, onPlaySymbolUp);

    PreviousSymbol.addEventListener(MouseEvent.MOUSE_DOWN, onPreviousSymbolDown);
    PreviousSymbol.addEventListener(MouseEvent.MOUSE_UP, onPreviousSymbolUp);
    PreviousSymbol.addEventListener(MouseEvent.RELEASE_OUTSIDE, onPreviousSymbolUp);

    NextSymbol.addEventListener(MouseEvent.MOUSE_DOWN, onNextSymbolDown);
    NextSymbol.addEventListener(MouseEvent.MOUSE_UP, onNextSymbolUp);
    NextSymbol.addEventListener(MouseEvent.RELEASE_OUTSIDE, onNextSymbolUp);

    AboutSymbol.addEventListener(MouseEvent.MOUSE_DOWN, onAboutSymbolDown);
    AboutSymbol.addEventListener(MouseEvent.MOUSE_UP, onAboutSymbolUp);
    AboutSymbol.addEventListener(MouseEvent.RELEASE_OUTSIDE, onAboutSymbolUp);

    AboutFrame.addEventListener(MouseEvent.CLICK, onAboutFrameClick);

    SaveSymbol.addEventListener(MouseEvent.MOUSE_DOWN, onSaveSymbolDown);
    SaveSymbol.addEventListener(MouseEvent.MOUSE_UP, onSaveSymbolUp);
    SaveSymbol.addEventListener(MouseEvent.RELEASE_OUTSIDE, onSaveSymbolUp);

    SaveFrame.SaveMessageSymbol.DownloadSymbol.addEventListener(MouseEvent.MOUSE_DOWN, onDownloadSymbolDown);
    SaveFrame.SaveMessageSymbol.DownloadSymbol.addEventListener(MouseEvent.MOUSE_UP, onDownloadSymbolUp);
    SaveFrame.SaveMessageSymbol.DownloadSymbol.addEventListener(MouseEvent.RELEASE_OUTSIDE, onDownloadSymbolUp);

    // touch-Disable pressed symbols
    for each (var disabledSymbol in [
      AboutDownSymbol, PreviousDownSymbol, PlayDownSymbol, PauseDownSymbol, NextDownSymbol,
      SaveFrame.SaveMessageSymbol.DownloadDownSymbol,
      SaveFrame.SaveMessageSymbol.DoneSymbol,
      SaveFrame.SaveMessageSymbol.FailedSymbol]) {
      disabledSymbol.mouseEnabled = false;
      disabledSymbol.mouseChildren = false;
    }

    stage.addEventListener(Event.DEACTIVATE, onLeave);
    stage.addEventListener(Event.ACTIVATE, onComeBack);

    setCurrentJingle();
  }

  private function onLeave(e:Event) {
  }

  private function onComeBack(e:Event) {
  }

  private function setCurrentJingle() {
    var jinglePath = new URLRequest("./media/mp3_192/" + titleHeader + playList[playIndex] + ".mp3");
    TrackFrame.TrackText.TrackInformationText.htmlText = TrackInformation.replace(/\$track\$/g, playList[playIndex]);
    TrackOutFrame.TrackText.TrackInformationText.htmlText = TrackInformation.replace(/\$track\$/g, playList[prevPlayIndex]);

    soundLoader = new Sound(jinglePath);
  }

  private function onPlaySymbolDown(e:MouseEvent) {
    if (playStatus) {
      PauseDownSymbol.visible = true;
    } else {
      PlayDownSymbol.visible = true;
    }
  }

  private function onPlaySymbolUp(e:MouseEvent) {
    if (playStatus) {
      PauseDownSymbol.visible = false;
    } else {
      PlayDownSymbol.visible = false;
    }
    if (e.type == "mouseUp") {
      playStatus = !playStatus;
      setPlayStatus();
    }
  }

  private function onPreviousSymbolDown(e:MouseEvent) {
    PreviousDownSymbol.visible = true;
  }

  private function onPreviousSymbolUp(e:MouseEvent) {
    PreviousDownSymbol.visible = false;

    if (e.type == "mouseUp") {
      gotoAndPlay(frames["swipeleft"]);
      playStatus = true;
      setPlayStatus();
      playIndex = playIndex ? playIndex - 1 : playList.length - 1;
      setCurrentJingle();
      playCurrentTrack();
    }
  }

  private function onNextSymbolDown(e:MouseEvent) {
    NextDownSymbol.visible = true;
  }

  private function onNextSymbolUp(e:MouseEvent) {
    NextDownSymbol.visible = false;

    if (e.type == "mouseUp") {
      gotoAndPlay(frames["swipeRight"]);
      playStatus = true;
      setPlayStatus();
      playIndex = playIndex < playList.length - 1 ? playIndex + 1 : 0;
      setCurrentJingle();
      playCurrentTrack();
    }
  }

  private function setPlayStatus() {
    PlaySymbol.visible = !playStatus;
    PauseSymbol.visible = playStatus;

    if (playStatus) {
      PlaySymbol.removeEventListener(MouseEvent.MOUSE_DOWN, onPlaySymbolDown);
      PlaySymbol.removeEventListener(MouseEvent.MOUSE_UP, onPlaySymbolUp);
      PlaySymbol.removeEventListener(MouseEvent.RELEASE_OUTSIDE, onPlaySymbolUp);
      PauseSymbol.addEventListener(MouseEvent.MOUSE_DOWN, onPlaySymbolDown);
      PauseSymbol.addEventListener(MouseEvent.MOUSE_UP, onPlaySymbolUp);
      PauseSymbol.addEventListener(MouseEvent.RELEASE_OUTSIDE, onPlaySymbolUp);
      playCurrentTrack();
    } else {
      PlaySymbol.addEventListener(MouseEvent.MOUSE_DOWN, onPlaySymbolDown);
      PlaySymbol.addEventListener(MouseEvent.MOUSE_UP, onPlaySymbolUp);
      PlaySymbol.addEventListener(MouseEvent.RELEASE_OUTSIDE, onPlaySymbolUp);
      PauseSymbol.removeEventListener(MouseEvent.MOUSE_DOWN, onPlaySymbolDown);
      PauseSymbol.removeEventListener(MouseEvent.MOUSE_UP, onPlaySymbolUp);
      PauseSymbol.removeEventListener(MouseEvent.RELEASE_OUTSIDE, onPlaySymbolUp);
      pauseCurrentTrack();
    }
  }

  private function playCurrentTrack() {
    if (playStatus) {
      soundChannel.stop();
      soundChannel = soundLoader.play(0);
      soundChannel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
    } else {
      soundChannel.stop();
    }
  }

  private function pauseCurrentTrack() {
    soundChannel.stop();
  }

  private function onSoundComplete(e:Event) {
    playStatus = false;
    setPlayStatus();
  }

  private function onAboutSymbolDown(e:Event) {
    AboutDownSymbol.visible = true;
  }

  private function onAboutSymbolUp(e:MouseEvent) {
    AboutDownSymbol.visible = false;
    if (e.type == "mouseUp") {
      gotoAndPlay(frames["about"]);
    }
  }

  private function onSaveSymbolDown(e:Event) {
    isDone = false;
    SaveFrame.SaveMessageSymbol.DownloadSymbol.visible = true;
    SaveFrame.SaveMessageSymbol.DownloadDownSymbol.visible = false;
  }

  private function onSaveSymbolUp(e:MouseEvent) {
    if (e.type == "mouseUp") {
      gotoAndPlay(frames["save"]);
    }
  }

  private function onAboutFrameClick(e:Event) {
    AboutFrame.visible = false;
  }

  private function onDownloadSymbolDown(e:MouseEvent) {
    if (!isDone) {
      SaveFrame.SaveMessageSymbol.DownloadSymbol.alpha = 0;
      SaveFrame.SaveMessageSymbol.DownloadDownSymbol.visible = true;
    }
  }

  private function onDownloadSymbolUp(e:MouseEvent) {
    if (isDone) {
      onBackgroundUp(e);
    } else if (e.type == "mouseUp") {
      var source:File;
      var target:File;
      try {
        if (os.indexOf("iPhone") < 0) {
          // android
          source = File.applicationDirectory.resolvePath("./media/mp3_64/" + titleHeader + playList[playIndex] + ".mp3");
          if (File.documentsDirectory.resolvePath("./media/audio/ringtones/").exists) {
            target = File.documentsDirectory.resolvePath("./media/audio/ringtones/" + titleHeader + playList[playIndex] + ".mp3");
          } else {
            target = File.documentsDirectory.resolvePath("./Ringtones/" + titleHeader + playList[playIndex] + ".mp3");
          }
          source.copyTo(target, true);
        } else {
          // iOS
          source = File.applicationDirectory.resolvePath("./media/m4r_64/" + titleHeader + playList[playIndex] + ".m4r");
          target = File.documentsDirectory.resolvePath(titleHeader + playList[playIndex] + ".m4r");
          source.copyTo(target, true);
        }
      } catch (error:Error) {
        SaveFrame.SaveMessageSymbol.FailedSymbol.visible = true;
      }
      isDone = true;
      SaveFrame.SaveMessageSymbol.DoneSymbol.visible = true;
      SaveFrame.SaveMessageSymbol.DownloadSymbol.alpha = 1;
      SaveFrame.SaveMessageSymbol.DownloadSymbol.visible = false;
    } else {
      SaveFrame.SaveMessageSymbol.DownloadSymbol.visible = true;
    }
    SaveFrame.SaveMessageSymbol.DownloadDownSymbol.visible = false;
  }

  private function onEnterFrame(e:Event) {
    if (currentFrame == frames["swipeleftDone"] || currentFrame == frames["swipeRightDone"] || currentFrame == frames["saveDone"] || currentFrame == frames["aboutDone"]) {
      prevPlayIndex = playIndex;
      stop();
      if (currentFrame == frames["saveDone"] || currentFrame == frames["aboutDone"]) {
        stage.addEventListener(MouseEvent.MOUSE_UP, onBackgroundUp);
      }
    }
  }

  private function onBackgroundUp(e:MouseEvent) {
    if (isDone) {
      isDone = false;
    } else {
      gotoAndStop(frames["swipeleftDone"]);
      setCurrentJingle();
      stage.removeEventListener(MouseEvent.MOUSE_UP, onBackgroundUp);
      SaveFrame.SaveMessageSymbol.DownloadSymbol.visible = visible;
      SaveFrame.SaveMessageSymbol.DownloadDownSymbol.visible = false;
      SaveFrame.SaveMessageSymbol.DoneSymbol.visible = false;
      SaveFrame.SaveMessageSymbol.FailedSymbol.visible = false;
      SaveFrame.SaveMessageSymbol.DownloadSymbol.alpha = 1;
    }
  }
}

}