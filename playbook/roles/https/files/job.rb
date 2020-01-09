# frozen_string_literal: true

$LOAD_PATH << __dir__

require 'optparse'
require 'ocsp_response_fetcher'

def parse_options(argv = ARGV)
  op = OptionParser.new

  op.banner += ' END_ENTITY_CERT ITERMEDIATE_CERT CACHE_FILE_PATH'
  begin
    args = op.parse(argv)
  rescue OptionParser::InvalidOption => e
    puts op.to_s
    puts "error: #{e.message}"
    exit 1
  end

  if args.size != 3
    puts op.to_s
    puts 'error: number of arguments is not 3'
    exit 1
  end

  args
end

ee, inter, cache_file = parse_options
ee_cert = OpenSSL::X509::Certificate.new(File.read(ee))
inter_cert = OpenSSL::X509::Certificate.new(File.read(inter))
key = ee_cert.subject.to_s + ' ' \
      + ee_cert.serial.to_s(16).scan(/.{1,2}/).join(':')
logger = Logger.new(STDERR)
logger.progname = "OCSPResponse Fetcher #{key}"

read_local_file = lambda do
  return nil unless File.exist?(cache_file)

  der = File.binread(cache_file)
  ocsp_response = OpenSSL::OCSP::Response.new(der)
  return nil if ocsp_response.basic.status.first[5] < Time.now

  ocsp_response
end

write_local_file = lambda do |ocsp_response|
  File.binwrite(cache_file, ocsp_response.to_der)
end

fetcher = OCSPResponseFetcher.new(
  ee_cert,
  inter_cert,
  read_cache: read_local_file,
  write_cache: write_local_file,
  logger: logger
)
fetcher.run
