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
    puts 'entrei'
    response = Resemble::V2::Clip.all(project_uuid, @page, @page_size)
    response.to_json(indent: 2)
  end

  def create_clip(voice_uuid, project_uuid)
    callback_uri = 'https://example.com/callback/resemble-clip'
    body = 'This is an async test'

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
    response.to_json(indent: 2)
  end
end
