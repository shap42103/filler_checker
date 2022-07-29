(function() {
  // <!--
  function log_(n, s) {
    console.log(n + s);
    var color = "";
    if (s.lastIndexOf("EVENT: ", 0) != -1) {
//    color = "green";
    } else
    if (s.lastIndexOf("INFO: ", 0) != -1) {
//    color = "blue";
    } else
    if (s.lastIndexOf("ERROR: ", 0) != -1) {
      color = "red";
    } else {
      color = "black";
    }
    if (color) {
      if (messages.childNodes.length >= 20) {
        messages.removeChild(messages.lastChild);
      }
      messages.insertBefore(document.createElement("div"), messages.firstChild).innerHTML = n + s;
      messages.firstChild.style.borderBottom = "1px #ddd solid";
      messages.firstChild.style.color = color;
    }
  }
  function sanitize_(s) {
    return s.replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/'/g, '&apos;')
            .replace(/"/g, '&quot;');
  }
  // -->
  // 音声認識サーバへの接続処理が開始した時に呼び出されます。
  function connectStarted() {
    log_(this.name, "EVENT: connectStarted()");
  }

  // 音声認識サーバへの接続処理が完了した時に呼び出されます。
  function connectEnded() {
    log_(this.name, "EVENT: connectEnded()");
  }

  // 音声認識サーバからの切断処理が開始した時に呼び出されます。
  function disconnectStarted() {
    log_(this.name, "EVENT: disconnectStarted()");
  }

  // 音声認識サーバからの切断処理が完了した時に呼び出されます。
  function disconnectEnded() {
    log_(this.name, "EVENT: disconnectEnded()");
    // ボタンの制御
    resumePauseButton.innerHTML = "録音の開始";
    resumePauseButton.disabled = false;
    resumePauseButton.classList.remove("sending");
  }

  // 音声認識サーバへの音声データの供給開始処理が開始した時に呼び出されます。
  function feedDataResumeStarted() {
    log_(this.name, "EVENT: feedDataResumeStarted()");
  }

  // 音声認識サーバへの音声データの供給開始処理が完了した時に呼び出されます。
  function feedDataResumeEnded() {
    log_(this.name, "EVENT: feedDataResumeEnded()");
    // ボタンの制御
    resumePauseButton.innerHTML = "<br><br>音声データの録音中...<br><br><span class=\"supplement\">クリック → 録音の停止</span>";
    resumePauseButton.disabled = false;
    resumePauseButton.classList.add("sending");
  }

  // 音声認識サーバへの音声データの供給終了処理が開始した時に呼び出されます。
  function feedDataPauseStarted() {
    log_(this.name, "EVENT: feedDataPauseStarted()");
  }

  // 音声認識サーバへの音声データの供給終了処理が完了した時に呼び出されます。
  function feedDataPauseEnded(reason) {
    log_(this.name, "EVENT: feedDataPauseEnded(): reason[code[" + reason.code + "] message[" + reason.message + "]]");
  }

  // 発話区間の始端が検出された時に呼び出されます。
  function utteranceStarted(startTime) {
    log_(this.name, "EVENT: utteranceStarted(): endTime[" + startTime + "]");
  }

  // 発話区間の終端が検出された時に呼び出されます。
  function utteranceEnded(endTime) {
    log_(this.name, "EVENT: utteranceEnded(): endTime[" + endTime + "]");
  }

  // 認識処理が開始された時に呼び出されます。
  function resultCreated() {
    log_(this.name, "EVENT: resultCreated()");
    this.recognitionResultText.innerHTML = "...";
    this.recognitionResultInfo.innerHTML = "";
    this.startTime = new Date().getTime();
  }

  // 認識処理中に呼び出されます。
  function resultUpdated(result) {
    log_(this.name, "EVENT: resultUpdated(): result[" + result + "]");
    result = Result.parse(result);
    var text = (result.text) ? sanitize_(result.text) : "...";
    this.recognitionResultText.innerHTML = text;
  }

  // 認識処理が確定した時に呼び出されます。
  function resultFinalized(result) {
    log_(this.name, "EVENT: resultFinalized(): result[" + result + "]");
    result = Result.parse(result);
    var text = (result.text) ? sanitize_(result.text) : (result.code != 'o' && result.message) ? "<font color=\"gray\">(" + result.message + ")</font>" : "<font color=\"gray\">(なし)</font>";
    var duration = result.duration;
    var elapsedTime = new Date().getTime() - this.startTime;
    var confidence = result.confidence;
    var rt = ((duration > 0) ? (elapsedTime / duration).toFixed(2) : "-") + " (" + (elapsedTime / 1000).toFixed(2) + "/" + ((duration > 0) ? (duration / 1000).toFixed(2) : "-") + ")";
    var cf = (confidence >= 0.0) ? confidence.toFixed(2) : "-";
    this.recognitionResultText.innerHTML = text;
    this.recognitionResultInfo.innerHTML = "RT: " + rt + "<br>CF: " + cf;
    log_(this.name, text + " <font color=\"darkgray\">(RT: " + rt + ") (CF: " + cf + ")</font>");
  }

  // 各種イベントが通知された時に呼び出されます。
  function eventNotified(eventId, eventMessage) {
    log_(this.name, "EVENT: eventNotified(): eventId[" + eventId + "] eventMessage[" + eventMessage + "]");
  }

  // メッセージの出力が要求された時に呼び出されます。
  function TRACE(message) {
    log_(this.name || "", message);
  }

  // 画面要素の取得
  var issuerURL = document.getElementById("issuerURL");
  var sid = document.getElementById("sid");
  var spw = document.getElementById("spw");
  var epi = document.getElementById("epi");
  var issueButton = document.getElementById("issueButton");
  var grammarFileNames = document.getElementsByClassName("grammarFileNames");
  var recognitionResultText = document.getElementsByClassName("recognitionResultText");
  var recognitionResultInfo = document.getElementsByClassName("recognitionResultInfo");

  // 画面要素の初期化
  issuerURL.value = "https://acp-api.amivoice.com/issue_service_authorization";
  serverURL.value = "wss://acp-api.amivoice.com/v1/";
  grammarFileNames[0].value = Wrp.grammarFileNames;
  profileId.value = Wrp.profileId;
  profileWords.value = Wrp.profileWords;
  segmenterProperties.value = Wrp.segmenterProperties;
  keepFillerToken.value = Wrp.keepFillerToken;
  resultUpdatedInterval.value = Wrp.resultUpdatedInterval;
  extension.value = Wrp.extension;
  authorization.value = Wrp.authorization;
  codec.value = Wrp.codec;
  resultType.value = Wrp.resultType;
  checkIntervalTime.value = Wrp.checkIntervalTime;
  maxRecordingTime.value = Recorder.maxRecordingTime;

  // 音声認識ライブラリのプロパティ要素の設定
  Wrp.serverURLElement = serverURL;
  Wrp.grammarFileNamesElement = grammarFileNames[0];
  Wrp.profileIdElement = profileId;
  Wrp.profileWordsElement = profileWords;
  Wrp.segmenterPropertiesElement = segmenterProperties;
  Wrp.keepFillerTokenElement = keepFillerToken;
  Wrp.resultUpdatedIntervalElement = resultUpdatedInterval;
  Wrp.extensionElement = extension;
  Wrp.authorizationElement = authorization;
  Wrp.codecElement = codec;
  Wrp.resultTypeElement = resultType;
  Wrp.checkIntervalTimeElement = checkIntervalTime;
  Wrp.issuerURLElement = issuerURL;
  Wrp.sidElement = sid;
  Wrp.spwElement = spw;
  Wrp.epiElement = epi;
  Wrp.name = "";
  Wrp.recognitionResultText = recognitionResultText[0];
  Wrp.recognitionResultInfo = recognitionResultInfo[0];

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
  Recorder.maxRecordingTimeElement = maxRecordingTime;

  // 音声認識ライブラリ／録音ライブラリのメソッドの画面要素への登録
  resumePauseButton.onclick = function() {
    // 音声認識サーバへの音声データの供給中かどうかのチェック
    if (Wrp.isActive()) {
      // 音声認識サーバへの音声データの供給中の場合...
      // 音声認識サーバへの音声データの供給の停止
      Wrp.feedDataPause();

      // ボタンの制御
      resumePauseButton.disabled = true;
    } else {
      // 音声認識サーバへの音声データの供給中でない場合...
      // グラマファイル名が指定されているかどうかのチェック
      if (Wrp.grammarFileNamesElement.value != "") {
        // グラマファイル名が指定されている場合...
        // 音声認識サーバへの音声データの供給の開始
        Wrp.feedDataResume();

        // ボタンの制御
        resumePauseButton.disabled = true;
      } else {
        // グラマファイル名が指定されていない場合...
        // (何もしない)
      }
    }
  };
  issueButton.onclick = Wrp.issue;

  var issue_options = document.querySelectorAll(".issue_options");
  function toggle_issue_options() {
    issue_options[0].style.display = (issue_options[0].style.display === "") ? "none" : "";
    for (var i = 1; i < issue_options.length; i++) {
      issue_options[i].style.display = issue_options[0].style.display;
    }
  }
  var toggle_issue_optionss = document.querySelectorAll(".toggle_issue_options");
  for (var i = 0; i < toggle_issue_optionss.length; i++) {
    toggle_issue_optionss[i].onclick = toggle_issue_options;
    toggle_issue_optionss[i].style.cursor = "pointer";
  }

  var options = document.querySelectorAll(".options");
  function toggle_options() {
    options[0].style.display = (options[0].style.display === "") ? "none" : "";
    for (var i = 1; i < options.length; i++) {
      options[i].style.display = options[0].style.display;
    }
  }
  var toggle_optionss = document.querySelectorAll(".toggle_options");
  for (var i = 0; i < toggle_optionss.length; i++) {
    toggle_optionss[i].onclick = toggle_options;
    toggle_optionss[i].style.cursor = "pointer";
  }

  version.innerHTML = Wrp.version;
})();
