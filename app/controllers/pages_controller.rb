class PagesController < ApplicationController
  def home
    @response = 'Hello'
  end

  def option
    api_key = ENV['API_KEY']
    project_id = '9aab0f73'
    voice_id = '48d7ed16'
    input_audio_path = 'app/assets/recordings/record.wav'
    output_audio_path = 'app/assets/recordings/file.mp3'

    service = ResembleAiService.new(api_key, project_id, voice_id)

    @option = params[:id]
    case @option
    when '1'
      @response = service.get_all_projects
    when '2'
      @response = service.create_recording(voice_id, input_audio_path, 'Test POC',
                                           'This is a test from Ruby POC')
    when '3'
      @response = service.all_recording(voice_id)
    when '4'
      @response = service.all_voices
    when '5'
      @response = service.create_clip(voice_id, project_id)
    when '6'
      @response = service.all_clips(project_id)
    end
  end
end
