class TextAnalysisCollection
  include ActiveModel::Conversion
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  include ActiveModel::AttributeMethods
  include ActiveModel::Validations
  attr_accessor :collection

  def initialize(attributes = [], action)
    self.collection = attributes.map do |value|
      if action == "new"
        word = value['written']
        filler = self.filler?(word)
      elsif action == "create"
        word = value[:word]
        filler = value[:filler]
        recording_id = value[:recording_id]
      end
      TextAnalysis.new(word: word, filler: filler, recording_id: recording_id)
    end
  end

  def filler?(word)
    return true if word.include?('%')
    return false
  end

  def persisted?
    false
  end

  def save
    is_success = true
    ActiveRecord::Base.transaction do
      collection.each do |result|
        is_success = false unless result.save
        byebug unless is_success
      end
      raise ActiveRecord::RecordInvalid unless is_success
    end
    rescue
      p 'エラー'
    ensure
      return is_success
  end
end
