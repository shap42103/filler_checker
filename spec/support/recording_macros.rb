module RecordingMacros
  def start_recording()
    visit new_recording_path
    find("option[value='話題']").select_option
    find('#start-recording').click
  end

  def regist_db(recording)
    # 音声認識の結果をAPIのレスポンスではなくFactoryBotから擬似的に生成する
    # formの.display-noneをはずさないと値をセットできない（capybaraの仕様？）
    find('#recording_voice').set recording.voice
    find('#recording_text').set recording.text
    find('#recording_length').set recording.length
    find('#show-result').click
  end
end
