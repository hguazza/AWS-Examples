require 'aws-sdk-s3'  # AWS SDK for S3 to interact with Amazon S3 service
require 'pry'         # Pry for debugging (not used in this script)
require 'securerandom' # SecureRandom for generating random UUIDs

# Retrieve the bucket name from environment variables
bucket_name = ENV['BUCKET_NAME']
# Define the region for the S3 bucket
region = 'na-east-1'

# Initialize the S3 client
client = Aws::S3::Client.new

# Create a new S3 bucket with the specified name and region
resp = client.create_bucket({
  bucket: bucket_name, 
  create_bucket_configuration: {
    location_constraint: region
  } 
})

# Determine the number of random files to create, between 1 and 6
number_of_files = 1 + rand(6)
puts "Number of files: #{number_of_files}"

# Loop to create random files and upload them to the S3 bucket
number_of_files.times.each do |i|
  puts "Creating file #{i}"

  # Generate a filename and output path for the file
  filename = "file_#{i}.txt"
  output_path = "/tmp/#{filename}"

  # Create a new file with a random UUID as its content
  File.open(output_path, "w") do |f|
    f.write SecureRandom.uuid
  end

  # Upload the file to the S3 bucket
  File.open(output_path, 'rb') do |f|
    client.put_object(
      bucket: bucket_name,
      key: filename,
      body: f
    )
  end
end
