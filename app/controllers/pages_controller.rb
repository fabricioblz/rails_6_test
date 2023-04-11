class PagesController < ApplicationController
  def home
    api_key = 'RfqG5mIfZvmptaqHMYqJqAtt'
    project_id = '9aab0f73'
    voice_id = 'a56c5c6f'

    service = ResembleAiService.new(api_key, project_id, voice_id)
    service.clone_audio(input_audio_path, output_audio_path)
    @response = 'Just a test'
  end

  def option
    api_key = ENV['API_KEY']
    project_id = '9aab0f73'
    voice_id = '48d7ed16'
    input_audio_path = 'app/assets/recordings/record.wav'
    output_audio_path = 'app/assets/recordings/file.mp3'

    service = ResembleAiService.new(api_key, project_id, voice_id)

    @option = params[:id]
    # siwtch case with 4 positions
    case @option
    when '1'
      @response = service.get_all_projects
    when '2'
      @response = service.create_recording(voice_id, input_audio_path, 'Test POC', 'This is a test from Ruby POC')
    when '3'
      @response = service.all_recording(voice_id)
    when '4'
      @response = service.all_voices
    end
  end
end
