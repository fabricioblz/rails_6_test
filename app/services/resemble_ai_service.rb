require 'resemble'
require 'aws-sdk-s3'

class ResembleAiService
  API_BASE_URL = 'https://api.resemble.ai/v2/projects'

  def initialize(api_key, project_id)
    @api_key = api_key
    @project_id = project_id
    @voice_id = '48d7ed16'

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
    is_active = true
    emotion = 'neutral'

    File.open(file_path) do |file|
      response = Resemble::V2::Recording.create(voice_uuid, file, name, text, is_active, emotion)
      response.to_json(indent: 2)
    end
  end

  def all_voices
    response = Resemble::V2::Voice.all(@page, @page_size)
    response['items']
  end

  def all_clips(project_uuid)
    response = Resemble::V2::Clip.all(project_uuid, @page, @page_size)
    response.to_json(indent: 2)
  end

  def create_clip(voice_uuid, project_uuid, file_path)
    body = "<speak><resemble:convert src='#{file_path}'
/></speak>"

    callback_uri = 'https://example.com/callback/resemble-clip'

    Resemble::V2::Clip.create_async(
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

  def transform_voice(voice_uuid, _audio_file)
    # file_path = upload_to_s3(audio_file)
    file_path = 'https://drive.google.com/uc?id=1llA9UhqBxlr7wmmQ8s2xcLhEFWsHudFa&export=download'
    response = create_clip(voice_uuid, @project_id, file_path)
    clip_uuid = response['item']['uuid']
    get_clip(clip_uuid)
  end

  def get_clip(clip_uuid)
    clip = Resemble::V2::Clip.get(@project_id, clip_uuid)
    clip['item']['audio_src']
  end

  def upload_to_s3(file)
    s3 = Aws::S3::Resource.new(
      region: 'us-east-2',
      access_key_id: ENV['A_KEY'],
      secret_access_key: ENV['A_S']
    )

    # Generate a unique filename for the file
    filename = "#{SecureRandom.uuid}#{File.extname(file.original_filename)}"

    # Upload the file to S3 bucket
    obj = s3.bucket('resemble-poc').object(filename)
    obj.upload_file(file.tempfile)

    # Get the URL of the uploaded file
    puts obj.public_url.to_s
    obj.public_url.to_s
  end
end
