let Hrp = function() {
  // public オブジェクト
  let hrp_ = {
    // public プロパティ
    version: "Hrp/1.0.04",
    serverURL: "",
    serverURLElement: undefined,
    grammarFileNames: "",
    grammarFileNamesElement: undefined,
    profileId: "",
    profileIdElement: undefined,
    profileWords: "",
    profileWordsElement: undefined,
    segmenterProperties: "",
    segmenterPropertiesElement: undefined,
    keepFillerToken: 1,
    keepFillerTokenElement: undefined,
    resultUpdatedInterval: "",
    resultUpdatedIntervalElement: undefined,
    extension: "",
    extensionElement: undefined,
    authorization: "",
    authorizationElement: undefined,
    codec: "",
    codecElement: undefined,
    resultType: "",
    resultTypeElement: undefined,
    resultEncoding: "",
    resultEncodingElement: undefined,
    serviceAuthorization: gon.api_key,
    serviceAuthorizationElement: undefined,
    voiceDetection: "",
    voiceDetectionElement: undefined,
    audio: null,
    audioElement: undefined,
    // public メソッド
    feedDataResume: feedDataResume_,
    feedDataPause: feedDataPause_,
    isActive: isActive_,
    // イベントハンドラ
    feedDataResumeStarted: undefined,
    feedDataResumeEnded: undefined,
    feedDataPauseStarted: undefined,
    feedDataPauseEnded: undefined,
    resultCreated: undefined,
    resultUpdated: undefined,
    resultFinalized: undefined,
    TRACE: undefined
  };
  // 送信関連
  let state_ = 0;
  let inDataBytes_ = 0;
  let reason_;
  let recorder_ = Recorder || null;
  if (recorder_) {
    // 録音ライブラリのプロパティの設定
    recorder_.downSampling = true;

    // 録音の開始処理が完了した時
    recorder_.resumeEnded = function(samplesPerSec) {
      if (state_ === 1) {
        state_ = 2;
        if (hrp_.feedDataResumeEnded) hrp_.feedDataResumeEnded();
      }
    };

    // 録音の開始処理が失敗した時または録音の停止処理が完了した時
    recorder_.pauseEnded = function(reason, waveFile) {
      if (state_ === 1) {
        state_ = 0;
        if (hrp_.feedDataPauseEnded) hrp_.feedDataPauseEnded(reason);
      } else
      if (state_ === 2) {
        if (hrp_.feedDataPauseStarted) hrp_.feedDataPauseStarted();
        if (waveFile) {
          feedDataPause__(reason, waveFile);
        } else {
          state_ = 0;
          if (hrp_.feedDataPauseEnded) hrp_.feedDataPauseEnded(reason);
        }
      } else
      if (state_ === 3) {
        if (waveFile) {
          feedDataPause__(reason, waveFile);
        } else {
          state_ = 0;
          if (hrp_.feedDataPauseEnded) hrp_.feedDataPauseEnded(reason);
        }
      }
    };
  }

  // 音声データの供給の開始
  function feedDataResume_(waveFile) {
    if (state_ !== 0) {
      if (hrp_.TRACE) hrp_.TRACE("ERROR: can't start feeding data to HTTP server (Invalid state: " + state_ + ")");
      return false;
    }
    // 音声データをアップロードしたとき
    if (waveFile !== void 0) {
      if (hrp_.feedDataPauseStarted) hrp_.feedDataPauseStarted();
      if (!window.XMLHttpRequest) {
        if (hrp_.TRACE) hrp_.TRACE("ERROR: can't start feeding data to HTTP server (Unsupported XMLHttpRequest class)");
        if (hrp_.feedDataPauseEnded) hrp_.feedDataPauseEnded({code: 2, message: "Unsupported XMLHttpRequest class"});
        return true;
      }
      state_ = 4;
      feedDataPause__(null, waveFile);
      return true;
    }
    if (hrp_.feedDataResumeStarted) hrp_.feedDataResumeStarted();
    if (!window.XMLHttpRequest) {
      if (hrp_.TRACE) hrp_.TRACE("ERROR: can't start feeding data to HTTP server (Unsupported XMLHttpRequest class)");
      if (hrp_.feedDataPauseEnded) hrp_.feedDataPauseEnded({code: 2, message: "Unsupported XMLHttpRequest class"});
      return true;
    }
    state_ = 1;
    reason_ = null;
    if (recorder_) {
      recorder_.TRACE = hrp_.TRACE;
      recorder_.resume();
    } else {
      state_ = 2;
      if (hrp_.feedDataResumeEnded) hrp_.feedDataResumeEnded();
    }
    return true;
  }

  // 音声データの供給の停止
  function feedDataPause_(reason, waveFile) {
    if (state_ !== 2) {
      if (hrp_.TRACE) hrp_.TRACE("ERROR: can't stop feeding data to HTTP server (Invalid state: " + state_ + ")");
      return false;
    }
    if (hrp_.feedDataPauseStarted) hrp_.feedDataPauseStarted();
    state_ = 3;
    if (recorder_) {
      recorder_.TRACE = hrp_.TRACE;
      recorder_.pause();
    } else {
      state_ = 4;
      feedDataPause__(reason, waveFile);
    }
    return true;
  }
  function feedDataPause__(reason, waveFile) {
    reason_ = reason;
    if (waveFile) {
      hrp_.audio = waveFile;
      if (hrp_.audioElement) {
        if (hrp_.audioElement.update) {
          hrp_.audioElement.update(hrp_.audio);
        } else {
          hrp_.audioElement.value = hrp_.audio;
        }
      }
    }
    if (hrp_.serverURLElement) hrp_.serverURL = hrp_.serverURLElement;
    if (hrp_.grammarFileNamesElement) hrp_.grammarFileNames = hrp_.grammarFileNamesElement;
    if (hrp_.profileIdElement) hrp_.profileId = hrp_.profileIdElement;
    if (hrp_.profileWordsElement) hrp_.profileWords = hrp_.profileWordsElement;
    if (hrp_.segmenterPropertiesElement) hrp_.segmenterProperties = hrp_.segmenterPropertiesElement;
    if (hrp_.keepFillerTokenElement) hrp_.keepFillerToken = hrp_.keepFillerTokenElement;
    if (hrp_.resultUpdatedIntervalElement) hrp_.resultUpdatedInterval = hrp_.resultUpdatedIntervalElement;
    if (hrp_.extensionElement) hrp_.extension = hrp_.extensionElement;
    if (hrp_.authorizationElement) hrp_.authorization = hrp_.authorizationElement;
    if (hrp_.codecElement) hrp_.codec = hrp_.codecElement;
    if (hrp_.resultTypeElement) hrp_.resultType = hrp_.resultTypeElement;
    if (hrp_.resultEncodingElement) hrp_.resultEncoding = hrp_.resultEncodingElement;
    if (hrp_.serviceAuthorizationElement) hrp_.serviceAuthorization = hrp_.serviceAuthorizationElement;
    if (hrp_.voiceDetectionElement) hrp_.voiceDetection = hrp_.voiceDetectionElement;
    if (hrp_.audioElement) hrp_.audio = hrp_.audioElement.file;
    if (!hrp_.audio) {
      state_ = 0;
      if (hrp_.TRACE) hrp_.TRACE("ERROR: can't stop feeding data to HTTP server (Missing audio)");
      if (hrp_.feedDataPauseEnded) hrp_.feedDataPauseEnded({code: 3, message: "Missing audio"});
      return;
    }
    let formData = new FormData();
    let domainId = "";
    if (hrp_.grammarFileNames) {
      domainId += "grammarFileNames=";
      domainId += encodeURIComponent(hrp_.grammarFileNames);
    }
    if (hrp_.profileId) {
      if (domainId.length > 0) {
        domainId += ' ';
      }
      domainId += "profileId=";
      domainId += encodeURIComponent(hrp_.profileId);
    }
    if (hrp_.profileWords) {
      if (domainId.length > 0) {
        domainId += ' ';
      }
      domainId += "profileWords=";
      domainId += encodeURIComponent(hrp_.profileWords);
    }
    if (hrp_.segmenterProperties) {
      if (domainId.length > 0) {
        domainId += ' ';
      }
      domainId += "segmenterProperties=";
      domainId += encodeURIComponent(hrp_.segmenterProperties);
    }
    if (hrp_.keepFillerToken) {
      if (domainId.length > 0) {
        domainId += ' ';
      }
      domainId += "keepFillerToken=";
      domainId += encodeURIComponent(hrp_.keepFillerToken);
    }
    if (hrp_.resultUpdatedInterval) {
      if (domainId.length > 0) {
        domainId += ' ';
      }
      domainId += "resultUpdatedInterval=";
      domainId += encodeURIComponent(hrp_.resultUpdatedInterval);
    }
    if (hrp_.extension) {
      if (domainId.length > 0) {
        domainId += ' ';
      }
      domainId += "extension=";
      domainId += encodeURIComponent(hrp_.extension);
    }
    if (hrp_.authorization) {
      if (domainId.length > 0) {
        domainId += ' ';
      }
      domainId += "authorization=";
      domainId += encodeURIComponent(hrp_.authorization);
    }
    formData.append("d", domainId);
    if (hrp_.codec) {
      formData.append("c", hrp_.codec);
    }
    if (hrp_.resultType) {
      formData.append("r", hrp_.resultType);
    }
    if (hrp_.resultEncoding) {
      formData.append("e", hrp_.resultEncoding);
    }
    if (hrp_.serviceAuthorization) {
      formData.append("u", hrp_.serviceAuthorization);
    }
    if (hrp_.voiceDetection) {
      formData.append("v", hrp_.voiceDetection);
    }
    formData.append("a", hrp_.audio);
    state_ = 0;
    inDataBytes_ = 0;
    let httpRequest = new XMLHttpRequest();
    httpRequest.addEventListener("loadstart", onOpen_);
    httpRequest.addEventListener("progress", onMessage_);
    httpRequest.addEventListener("load", onMessage_);
    httpRequest.addEventListener("error", onError_);
    httpRequest.addEventListener("abort", onError_);
    httpRequest.addEventListener("timeout", onError_);
    httpRequest.addEventListener("loadend", onClose_);
    httpRequest.open("POST", hrp_.serverURL, true);
    httpRequest.send(formData);
  }

  function onOpen_(e) {
  }

  function onClose_(e) {
    state_ = 0;
    if (!reason_) {
      reason_ = {code: 0, message: ""};
    }
    if (hrp_.feedDataPauseEnded) hrp_.feedDataPauseEnded(reason_);
  }

  function onMessage_(e) {
    if (state_ === 0) {
      if (e.target.status !== 200) {
        state_ = 9;
        if (hrp_.TRACE) hrp_.TRACE("ERROR: can't stop feeding data to HTTP server (Invalid response code: " + e.target.status + ")");
        if (!reason_ || reason_.code < 2) {
          reason_ = {code: 3, message: "Invalid response code: " + e.target.status};
        }
        e.target.abort();
        return;
      }
      let sessionId = e.target.getResponseHeader("X-Session-ID");
      if (!sessionId) {
        state_ = 9;
        if (hrp_.TRACE) hrp_.TRACE("ERROR: can't stop feeding data to HTTP server (Missing session id)");
        if (!reason_ || reason_.code < 2) {
          reason_ = {code: 3, message: "Missing session id"};
        }
        e.target.abort();
        return;
      }
      if (hrp_.resultCreated) hrp_.resultCreated(sessionId);
      state_ = 1;
    }
    if (state_ === 1) {
      let inDataBytes = e.target.response.indexOf("\r\n", inDataBytes_);
      while (inDataBytes !== -1) {
        let inData = e.target.response.substring(inDataBytes_, inDataBytes);
        if (inData.indexOf("...", inData.length - 3) !== -1 || inData.indexOf("...\"}", inData.length - 5) !== -1) {
          if (hrp_.resultUpdated) hrp_.resultUpdated(inData);
        } else {
          if (hrp_.resultFinalized) hrp_.resultFinalized(inData);
        }
        inDataBytes_ = inDataBytes + 2;
        inDataBytes = e.target.response.indexOf("\r\n", inDataBytes_);
      }
    }
  }

  function onError_(e) {
    if (state_ !== 9) {
      state_ = 9;
      if (hrp_.TRACE) hrp_.TRACE("ERROR: can't stop feeding data to HTTP server (Caught '" + e.type + "' event)");
      if (!reason_ || reason_.code < 2) {
        reason_ = {code: 3, message: "Caught '" + e.type + "' event"};
      }
    }
  }

  // 音声データの供給中かどうかの取得
  function isActive_() {
    return (state_ === 2);
  }

  // public プロパティの初期化
  if (recorder_) {
    hrp_.version += " " + recorder_.version;
  }
  hrp_.serverURL = window.location.protocol + "//" + window.location.host + window.location.pathname;
  hrp_.serverURL = hrp_.serverURL.substring(0, hrp_.serverURL.lastIndexOf('/') + 1);
  if (hrp_.serverURL.endsWith("/tool/")) {
    hrp_.serverURL = hrp_.serverURL.substring(0, hrp_.serverURL.length - 5);
  }
  hrp_.serverURL += "/recognize";
  hrp_.grammarFileNames = "-a-general";

  // public オブジェクトの返却
  return hrp_;
}();
