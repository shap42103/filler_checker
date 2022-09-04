(function() {
  // ------
  // common
  // ------
  // 特殊文字をエスケープ
  function sanitize_(text) {
    return text.replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/'/g, '&apos;')
      .replace(/"/g, '&quot;');
  }
  // ------
  // ログ出力関係
  // ------
  function log_(name, state) {
    console.log(name + state);
  }
  // 音声認識サーバへの音声データの供給開始処理が開始した時
  function feedDataResumeStarted() {
    log_(this.name, "EVENT: feedDataResumeStarted()");
  }
  // 音声認識サーバへの音声データの供給開始処理が完了した時
  function feedDataResumeEnded() {
    log_(this.name, "EVENT: feedDataResumeEnded()");
  }
  // 音声認識サーバへの音声データの供給終了処理が開始した時
  function feedDataPauseStarted() {
    log_(this.name, "EVENT: feedDataPauseStarted()");
    this.startTime = new Date().getTime();
  }
  // 音声認識サーバへの音声データの供給終了処理が完了した時
  function feedDataPauseEnded(reason) {
    log_(this.name, "EVENT: feedDataPauseEnded(): reason[code[" + reason.code + "] message[" + reason.message + "]]");
  }
  // 認識処理が開始された時
  function resultCreated(sessionId) {
    log_(this.name, "EVENT: resultCreated(): sessionId[" + sessionId + "]");
  }
  // 認識処理中
  function resultUpdated(result) {
    log_(this.name, "EVENT: resultUpdated(): result[" + result + "]");
  }
  // 認識処理が確定した時
  function resultFinalized(result) {
    log_(this.name, "EVENT: resultFinalized(): result[" + result + "]");
    responsed_from_API(result);
    result = Result.parse(result);
    let text = (result.text) ? sanitize_(result.text) : (result.code != 'o' && result.message) ? "(" + result.message + ")" : "(なし)";
    let duration = (this.audio.name) ? result.duration : this.audio.samples / this.audio.samplesPerSec * 1000;
    let elapsedTime = new Date().getTime() - this.startTime;
    let confidence = result.confidence;
    let rt = ((duration > 0) ? (elapsedTime / duration).toFixed(2) : "-") + " (" + (elapsedTime / 1000).toFixed(2) + "/" + ((duration > 0) ? (duration / 1000).toFixed(2) : "-") + ")";
    let cf = (confidence >= 0.0) ? confidence.toFixed(2) : "-";
    log_(this.name, text + " (RT: " + rt + ") (CF: " + cf + ")");
  }
  // メッセージの出力が要求された時
  function TRACE(message) {
    log_(this.name || "", message);
  }
  // ------
  // main
  // ------
  let audio = document.getElementById("recording_audio");
  let startButton = document.getElementById("start-recording");
  let stopButton = document.getElementById("stop-recording");
  let showResultButton = document.getElementById("show-result");
  let inProgressButton = document.getElementById("in-progress");
  let recordingTheme = document.getElementById("recording_theme_title");
  let recordingLength = document.getElementById("recording_length");
  let audioTag = document.getElementById('audio-tag');
  let recordingText = document.getElementById("recording_text");

  // 音声認識ライブラリのプロパティ要素の設定
  Hrp.serverURLElement = "https://acp-api.amivoice.com/v1/recognize";
  Hrp.grammarFileNamesElement = Hrp.grammarFileNames;
  Hrp.profileIdElement = Hrp.profileId;
  Hrp.profileWordsElement = Hrp.profileWords;
  Hrp.segmenterPropertiesElement = Hrp.segmenterProperties;
  Hrp.keepFillerTokenElement = Hrp.keepFillerToken;
  Hrp.resultUpdatedIntervalElement = Hrp.resultUpdatedInterval;
  Hrp.extensionElement = Hrp.extension;
  Hrp.authorizationElement = Hrp.authorization;
  Hrp.codecElement = Hrp.codec;
  Hrp.resultTypeElement = Hrp.resultType;
  Hrp.resultEncodingElement = Hrp.resultEncoding;
  Hrp.serviceAuthorizationElement = Hrp.serviceAuthorization;
  Hrp.voiceDetectionElement = Hrp.voiceDetection;
  Hrp.audioElement = audio; // Hrp.audio; // audio(画面要素)のままでもいいかも
  Hrp.name = "";

  // 音声認識ライブラリのイベントハンドラの設定
  Hrp.feedDataResumeStarted = feedDataResumeStarted;
  Hrp.feedDataResumeEnded = feedDataResumeEnded;
  Hrp.feedDataPauseStarted = feedDataPauseStarted;
  Hrp.feedDataPauseEnded = feedDataPauseEnded;
  Hrp.resultCreated = resultCreated;
  Hrp.resultUpdated = resultUpdated;
  Hrp.resultFinalized = resultFinalized;
  Hrp.TRACE = TRACE;

  // 録音ライブラリのプロパティ要素の設定
  Recorder.maxRecordingTimeElement = Recorder.maxRecordingTime;

  recordingTheme.onchange = function() {
    if (recordingTheme.value) {
      startButton.classList.add("btn-danger");
      startButton.classList.remove("btn-outline-danger");
    } else {
      startButton.classList.remove("btn-danger");
      startButton.classList.add("btn-outline-danger");
    };
  };

  function responsed_from_API(result) {
    recordingText.value = result;
    if (recordingText.value) {
      showResultButton.classList.remove("display-none");
      inProgressButton.classList.add("display-none");
    };
  };

  startButton.onclick = function(e) {
    if (!Hrp.isActive()) {
      if (Hrp.grammarFileNamesElement.value != "") {
        if (audio.files[0]) {
          // アップロードファイルを解析
          Hrp.feedDataResume(audio.files[0]);
          startButton.classList.add("display-none");
          audioTag.classList.remove("display-none");
          inProgressButton.classList.remove("display-none");
          audioTag.src = URL.createObjectURL(audio.files[0]);
        } else {
          // 録音して解析
          if (!recordingTheme.value) return;
          Hrp.feedDataResume();
          startButton.classList.add("display-none");
          stopButton.classList.remove("display-none");
          recordingTheme.disabled = true;
        }
      }
    }
  };

  stopButton.onclick = function() {
    inProgressButton.classList.remove("display-none");
    stopButton.classList.add("display-none");
    audioTag.classList.remove("display-none");
    if (Hrp.isActive()) {
      Hrp.feedDataPause();
    }
  };
  showResultButton.onclick = function() {
    recordingLength.value = audioTag.duration;
    recordingTheme.disabled = false;
  };

  audio.update = function(f) {
    audio.file = f || null;
    if (audio.file) {
      if (!audio.file.name) {
        audioTag.src = URL.createObjectURL(audio.file);
        let recording_voice = document.getElementById("recording_voice");
        const reader = new FileReader();
        reader.onload = (event) => {
          const base64Text = event.currentTarget.result;
          recording_voice.value = base64Text;
        }
        reader.readAsDataURL(audio.file);
      }
    }
  };
  audio.input = audio.appendChild(document.createElement("input"));
  audio.input.type = "file";
  audio.input.style.display = "none";
  audio.input.onclick = function(e) {
    e.stopPropagation();
  };
  audio.input.onchange = function(e) {
    audio.update(audio.input.files && audio.input.files[0]);
  };
  audio.onkeyup = function(e) {
    if (e.keyCode == 13 || e.keyCode == 32) {
      audio.input.click();
    } else
    if (e.keyCode == 27) {
      this.blur();
    }
  };
  audio.update();

  let draggingTarget = null;
  let draggingState = false;
  function dragenter(e) {
    e.stopPropagation();
    e.preventDefault();
    e.dataTransfer.dropEffect = "copy";
    draggingState = false;
  }
  function dragover(e) {
    e.stopPropagation();
    e.preventDefault();
    e.dataTransfer.dropEffect = "copy";
    if (!draggingTarget) {
      draggingTarget = audio;
      draggingTarget.classList.add("dropping");
    }
    draggingState = true;
  }
  function dragleave(e) {
    e.stopPropagation();
    e.preventDefault();
    e.dataTransfer.dropEffect = "copy";
    if (draggingTarget && draggingState) {
      draggingTarget.classList.remove("dropping");
      draggingTarget = null;
    }
    draggingState = true;
  }
  function drop(e) {
    e.stopPropagation();
    e.preventDefault();
    if (draggingTarget) {
      draggingTarget.classList.remove("dropping");
      draggingTarget = null;
    }
    audio.update(e.dataTransfer.files[0]);
  }
  window.addEventListener("dragenter", dragenter);
  window.addEventListener("dragover", dragover);
  window.addEventListener("dragleave", dragleave);
  window.addEventListener("drop", drop);
  audio.onchange = function(){
    if (audio.files[0]) {
      startButton.innerHTML = '音声を分析する';
      recordingTheme.disabled = true;
      startButton.disabled = false;
      startButton.classList.add("btn-danger");
      startButton.classList.remove("btn-outline-danger");
    }
  };

})();
