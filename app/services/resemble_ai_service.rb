require 'resemble'

class ResembleAiService
  API_BASE_URL = 'https://api.resemble.ai/v2/projects'

  def initialize(api_key, project_id, voice_id)
    @api_key = api_key
    @project_id = project_id
    @voice_id = voice_id

    Resemble.api_key = @api_key
    @page = 1
    @page_size = 10
  end

  def get_all_projects
    response = Resemble::V2::Project.all(@page, @page_size)
    puts response['items']
    response.to_json(indent: 2)
  end

  def all_recording(voice_uuid)
    response = Resemble::V2::Recording.all(voice_uuid, @page, @page_size)
    response.to_json(indent: 2)
  end

  def create_recording(voice_uuid, file_path, name, text)
    puts 'entrei'
    is_active = true
    emotion = 'neutral'

    File.open(file_path) do |file|
      response = Resemble::V2::Recording.create(voice_uuid, file, name, text, is_active, emotion)
      response.to_json(indent: 2)
    end
  end

  def all_voices
    response = Resemble::V2::Voice.all(@page, @page_size)
    response.to_json(indent: 2)
  end

  def all_clips(project_uuid)
    response = Resemble::V2::Clip.all(project_uuid, @page, @page_size)
    response.to_json(indent: 2)
  end

  def create_clip(voice_uuid, project_uuid, _file_path)
    callback_uri = 'https://example.com/callback/resemble-clip'
    # body = "<speak><resemble:convert src=\"#{file_path}\"/></speak>"
    # body = '<speak><resemble:convert src="https://resemble-data.s3.us-east-2.amazonaws.com/source-s2s.wav"/></speak>'
    body = '<speak><resemble:convert src="https://drive.google.com/uc?export=download&id=1Dr1e4j8fSw6-HJRrRxJTIWDbXoCOTIRe"/></speak>'

    response = Resemble::V2::Clip.create_async(
      project_uuid,
      voice_uuid,
      callback_uri,
      body,
      title: nil,
      sample_rate: nil,
      output_format: nil,
      precision: nil,
      include_timestamps: nil,
      is_public: nil,
      is_archived: nil
    )
  end

  def full_test(voice_uuid, project_uuid, file_path)
    response = create_clip(voice_uuid, project_uuid, file_path)
    clip_uuid = response['item']['uuid']
    puts clip_uuid
    clip_response = Resemble::V2::Clip.get(project_uuid, clip_uuid)
    puts clip_response
    clip_response['item']['audio_src']
  end
end
