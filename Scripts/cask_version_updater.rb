require 'net/http'
require 'uri'
require 'json'
require 'logger'
require 'fileutils'
require 'digest'

$logger = Logger.new($stdout)
$logger.level = Logger::INFO

# Downloads a file from the given URI with support for redirection.
#
# @param uri [URI] The URI of the file to download.
# @param file_path [String] The local file path to save the downloaded file.
# @return [void]
# @raise [RuntimeError] If the HTTP request fails.
def download_with_redirect(uri, file_path)
  Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
    request = Net::HTTP::Get.new(uri)
    request['User-Agent'] = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:97.0) Gecko/20100101 Firefox/97.0'
    http.request(request) do |response|
      case response
      when Net::HTTPSuccess
        open(file_path, 'wb') do |file|
          response.read_body do |chunk|
            file.write(chunk)
          end
        end
      when Net::HTTPRedirection
        location = response['location']
        $logger.debug "Redirected to #{location}"
        download_with_redirect(URI(location), file_path)
      else
        raise "HTTP request failed: #{response.code} #{response.message}"
      end
    end
  end
end

# Calculates the SHA256 hash of a file.
#
# @param file_path [String] The path to the file.
# @return [String] The SHA256 hash of the file.
def calculate_sha256(file_path)
  return "File does not exist: #{file_path}" unless File.exist?(file_path)

  sha256 = Digest::SHA256.new
  File.open(file_path, 'rb') do |file|
    buffer_size = 1024 * 1024
    while chunk = file.read(buffer_size)
      sha256.update(chunk)
    end
  end
  sha256.hexdigest
end

# Updates the cask file with the latest version and SHA256 checksum.
#
# @param file_path [String] The path to the cask file.
# @return [void]
def update_cask(file_path)
  content = File.read(file_path)
  cask_match = content.match(/cask ['"]([^'"]+)['"]/)
  version_match = content.match(/version ['"]([^'"]*)['"]/)
  sha256_match = content.match(/sha256 ['"]([^'"]*)['"]/)
  url_pattern = content.match(/url ['"]([^'"]+)['"]/)[1]
  if cask_match && version_match && sha256_match && url_pattern
    cask_name = cask_match[1]
    current_version = version_match[1] || 'empty'
    current_sha256 = sha256_match[1] || 'empty'
    interpolated_url = interpolate_url(url_pattern, current_version)
    $logger.info("Cask: #{cask_name}")
    $logger.info("Version: #{current_version}")
    $logger.info("SHA256: #{current_sha256}")
    $logger.info("URL: #{interpolated_url}")
    match = interpolated_url.match(%r{https://github\.com/([^/]+/[^/]+)})
    if !match
      $logger.info('GitHub repository pattern not found in the URL.')
      return
    end

    repo_part = match[1]
    $logger.debug(repo_part)
    version_uri = URI("https://api.github.com/repos/#{repo_part}/releases/latest")
    $logger.debug(version_uri)
    version_res = Net::HTTP.get_response(version_uri)
    unless version_res.is_a?(Net::HTTPSuccess)
      raise "Failed to retrieve data: #{version_res.code} #{version_res.message}"
    end

    data = JSON.parse(version_res.body)
    tag_name = data['tag_name']
    $logger.debug("Latest release tag: #{tag_name}")
    if tag_name == current_version
      $logger.info("No update needed for #{cask_name}. Version is up-to-date.")
    else
      new_version = tag_name
      download_uri = URI(interpolate_url(url_pattern, new_version))
      $logger.debug(download_uri)
      dl_file_path = "#{cask_name}#{File.extname(download_uri.path)}"
      download_with_redirect(download_uri, dl_file_path)
      new_sha256 = calculate_sha256(dl_file_path)
      File.delete(dl_file_path)
      $logger.info("New SHA256: #{new_sha256}")
      updated_content = content.gsub(/version ['"]([^'"]*)['"]/, "version '#{new_version}'")
      updated_content = updated_content.gsub(/sha256 ['"]([^'"]*)['"]/, "sha256 '#{new_sha256}'")
      File.write(file_path, updated_content)
      $logger.info "Updated #{cask_name}"
    end
  else
    $logger.info "Failed to extract necessary information from #{file_path}"
  end
end

# Interpolates the given pattern with the provided version.
# It replaces all occurrences of `#{expression}` in the pattern with the evaluated result of the expression.
# If an error occurs during evaluation, it logs the error message and returns the original match.
#
# @param pattern [String] The pattern to interpolate.
# @param version [String] The version to use for interpolation.
# @return [String] The interpolated URL pattern.
def interpolate_url(pattern, version)
  pattern.gsub(/\#\{([^}]+)\}/) do |match|
    eval(Regexp.last_match(1), binding)
  rescue StandardError => e
    $logger.info "Failed to evaluate expression #{match}: #{e}"
    match
  end
end

# Processes a directory by iterating over all files in the directory and updating the cask for each file.
#
# @param dir_path [String] The path to the directory to be processed.
# @return [void]
def process_directory(dir_path)
  return $logger.error "Directory does not exist: #{dir_path}" unless Dir.exist?(dir_path)

  Dir.glob(File.join(dir_path, '*')).each do |file_path|
    next if File.directory?(file_path)

    update_cask(file_path)
    $logger.info('####################')
  end
end

process_directory('Casks')
