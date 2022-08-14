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
    let type = "";
    if (state.lastIndexOf("EVENT: ", 0) != -1) {
      type = "event"
    } else if (state.lastIndexOf("INFO: ", 0) != -1) {
      type = "info"
    } else if (state.lastIndexOf("ERROR: ", 0) != -1) {
      type = "error";
    }
    console.log(name + state);
  }
  // 音声認識サーバへの接続処理が開始した時
  function connectStarted() {
    log_(this.name, "EVENT: connectStarted()");
  }
  // 音声認識サーバへの接続処理が完了した時
  function connectEnded() {
    log_(this.name, "EVENT: connectEnded()");
  }
  // 音声認識サーバからの切断処理が開始した時
  function disconnectStarted() {
    log_(this.name, "EVENT: disconnectStarted()");
  }
  // 音声認識サーバからの切断処理が完了した時
  function disconnectEnded() {
    log_(this.name, "EVENT: disconnectEnded()");
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
  }
  // 音声認識サーバへの音声データの供給終了処理が完了した時
  function feedDataPauseEnded(reason) {
    log_(this.name, "EVENT: feedDataPauseEnded(): reason[code[" + reason.code + "] message[" + reason.message + "]]");
  }
  // 発話区間の始端が検出された時
  function utteranceStarted(startTime) {
    log_(this.name, "EVENT: utteranceStarted(): endTime[" + startTime + "]");
  }
  // 発話区間の終端が検出された時
  function utteranceEnded(endTime) {
    log_(this.name, "EVENT: utteranceEnded(): endTime[" + endTime + "]");
  }
  // 各種イベントが通知された時
  function eventNotified(eventId, eventMessage) {
    log_(this.name, "EVENT: eventNotified(): eventId[" + eventId + "] eventMessage[" + eventMessage + "]");
  }
  // メッセージの出力が要求された時
  function TRACE(message) {
    log_(this.name || "", message);
  }
  // ------ 
  // 音声認識処理関係
  // ------
  // 認識処理が開始された時
  function resultCreated() {
    log_(this.name, "EVENT: resultCreated()");
    this.startTime = new Date().getTime();
  }
  // 認識処理中
  function resultUpdated(result) {
    log_(this.name, "EVENT: resultUpdated(): result[" + result + "]");
    result = Result.parse(result);
  }
  // 認識処理が確定した時
  function resultFinalized(result) {
    log_(this.name, "EVENT: resultFinalized(): result[" + result + "]");
    let finalResult = Result.parse(result);
    let text = (finalResult.text) ? sanitize_(finalResult.text) : (finalResult.code != 'o' && finalResult.message) ? "<font color=\"gray\">(" + finalResult.message + ")</font>" : "<font color=\"gray\">(なし)</font>"; // 結合テキストがあれば返す、なければメッセージ、それもなければなし
    let duration = finalResult.duration;
    let elapsedTime = new Date().getTime() - this.startTime;
    let confidence = finalResult.confidence;
    let rt =
      ((duration > 0) ? (elapsedTime / duration).toFixed(2) : "-") +
      " (" + (elapsedTime / 1000).toFixed(2) +
      "/" +
      ((duration > 0) ? (duration / 1000).toFixed(2) : "-") + ")";
    let cf = (confidence >= 0.0) ? confidence.toFixed(2) : "-"; // toFixed(x) 小数点x桁になるよう四捨五入
    log_(this.name, text + " <font color=\"darkgray\">(RT: " + rt + ") (CF: " + cf + ")</font>");
  }

  // ------
  // main
  // ------
  // 画面要素の取得
  let startButton = document.getElementById("start-recording");
  let stopButton = document.getElementById("stop-recording");
  let recordingTheme = document.getElementById("recording_theme_title");

  // 音声認識ライブラリのプロパティ要素の設定
  Wrp.serverURLElement = "wss://acp-api.amivoice.com/v1/";
  Wrp.grammarFileNamesElement = Wrp.grammarFileNames;
  Wrp.profileIdElement = Wrp.profileId;
  Wrp.profileWordsElement = Wrp.profileWords;
  Wrp.segmenterPropertiesElement = Wrp.segmenterProperties;
  Wrp.keepFillerTokenElement = Wrp.keepFillerToken;
  Wrp.resultUpdatedIntervalElement = Wrp.resultUpdatedInterval;
  Wrp.extensionElement = Wrp.extension;
  Wrp.authorizationElement = Wrp.authorization;
  Wrp.codecElement = Wrp.codec;
  Wrp.resultTypeElement = Wrp.resultType;
  Wrp.checkIntervalTimeElement = Wrp.checkIntervalTime;
  Wrp.issuerURLElement = "https://acp-api.amivoice.com/issue_service_authorization";
  Wrp.name = "";

  // 音声認識ライブラリのイベントハンドラの設定
  Wrp.connectStarted = connectStarted;
  Wrp.connectEnded = connectEnded;
  Wrp.disconnectStarted = disconnectStarted;
  Wrp.disconnectEnded = disconnectEnded;
  Wrp.feedDataResumeStarted = feedDataResumeStarted;
  Wrp.feedDataResumeEnded = feedDataResumeEnded;
  Wrp.feedDataPauseStarted = feedDataPauseStarted;
  Wrp.feedDataPauseEnded = feedDataPauseEnded;
  Wrp.utteranceStarted = utteranceStarted;
  Wrp.utteranceEnded = utteranceEnded;
  Wrp.resultCreated = resultCreated;
  Wrp.resultUpdated = resultUpdated;
  Wrp.resultFinalized = resultFinalized;
  Wrp.eventNotified = eventNotified;
  Wrp.TRACE = TRACE;

  // 録音ライブラリのプロパティ要素の設定
  Recorder.maxRecordingTimeElement = Recorder.maxRecordingTime;

  // 録音開始／停止ボタンによる発火イベント
  startButton.onclick = function() {
    if (!Wrp.isActive()) {
      if (Wrp.grammarFileNamesElement.value != "") {
        Wrp.feedDataResume();
        startButton.classList.add("display-none");
        stopButton.classList.remove("display-none");
        recordingTheme.disabled = true;
      }
    }
  };
  stopButton.onclick = function() {
    startButton.classList.remove("display-none");
    stopButton.classList.add("display-none");
    recordingTheme.disabled = false;
    if (Wrp.isActive()) {
      Wrp.feedDataPause();
    }
  };
})();
