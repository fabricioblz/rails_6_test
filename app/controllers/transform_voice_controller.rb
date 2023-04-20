class TransformVoiceController < ApplicationController
  def home
    api_key = ENV['API_KEY']
    project_id = '9aab0f73'
    service = ResembleAiService.new(api_key, project_id)

    @all_voices = service.all_voices
  end

  def transform_voice
    api_key = ENV['API_KEY']
    project_id = '9aab0f73'
    service = ResembleAiService.new(api_key, project_id)

    voice = params[:voice]
    audio_file = params[:audio_file]

    # file_path = service.upload_to_s3(audio_file)
    # @file_path = service.transform_voice(voice, audio_file)
    # @file_path = 'https://app.resemble.ai/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBCR3QzcEF3PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--fd45a558534320e77272367de5efe7e322c390aa/9a037bb5-10684b1f.wav'
    @file_path = service.get_clip('9a037bb5')

    redirect_to transform_voice_path(file_path: @file_path),
                notice: "Voice Transformed successfully: #{@file_path}"
  end
end
