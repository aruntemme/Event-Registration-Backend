require 'aws-sdk-s3'
class RecordsController < ActionController::API
    def start_upload
      client = Aws::S3::Client.new(
        region:               'ap-south-1', #or any other region
        access_key_id:       Rails.application.credentials.dig(:aws, :access_key_id),
        secret_access_key:    Rails.application.credentials.dig(:aws, :secret_access_key)
      )
      response = client.create_multipart_upload({
        bucket: params[:bucket], 
        key: params[:key], 
      })
      Rails.logger.info("create-multipart - #{response.upload_id} - #{params[:bucket]} - #{params[:key]}")

      render json: {uploadId: response.upload_id}  
    end

    def get_presigned_url

      client = Aws::S3::Client.new(
        region:               'ap-south-1', #or any other region
        access_key_id:       Rails.application.credentials.dig(:aws, :access_key_id),
        secret_access_key:    Rails.application.credentials.dig(:aws, :secret_access_key)
      )

      s3 = Aws::S3::Resource.new(client: client)
      bucket = s3.bucket(params[:bucket])
      obj = bucket.object(params[:key])
      if params[:type] == 'single'
        url = obj.presigned_url(:put)
      else 
        url = obj.presigned_url(
          :upload_part, 
          part_number: params[:part_number], 
          upload_id: params[:upload_id]
        )
      end
      Rails.logger.info("presigned - #{params[:part_number]} - #{params[:upload_id]} - #{params[:bucket]} - #{params[:key]}")
      render json: {url: url}  

    end
  
    def complete_upload
      client = Aws::S3::Client.new(
        region:               'ap-south-1', #or any other region
        access_key_id:       Rails.application.credentials.dig(:aws, :access_key_id),
        secret_access_key:    Rails.application.credentials.dig(:aws, :secret_access_key)
      )
      partsResponse = client.list_parts({
        bucket: params[:bucket], 
        key: params[:key], 
        upload_id: params[:upload_id]
      })
      partsResponse_hash = partsResponse.to_h
      parts = partsResponse_hash[:parts]

      parts.each { |h| h.delete(:last_modified) }
      parts.each { |h| h.delete(:size) }

      Rails.logger.info("----------------------------")
      Rails.logger.info(parts)
      Rails.logger.info("----------------------------")

      response = client.complete_multipart_upload({
        bucket: params[:bucket], 
        key: params[:key], 
        upload_id: params[:upload_id],
        multipart_upload: {
          parts: parts
        }
      })
      render json: {location: response.location}  
    end

end
