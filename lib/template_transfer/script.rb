require 'net/http'
require 'net/https'
require 'json'
require 'uri'
require 'yaml'
require 'optparse'
require 'json'

module TemplateTransfer
  class Script
    attr_reader :config

    def initialize( args )
      @production = false
      @config = YAML::load(File.open('config/config.yml'))
      @username = @config['sendgrid']['username']
      @password = @config['sendgrid']['password']

      # Set environment
      parse_command_line_options( args )

      puts "Script initialized!"
    end

    def run
      retrieve_all_template_info
      puts '-----------------------------------------------------------'
      retrieve_single_template( 'aed176b4-7e69-4511-8a34-4f659e0305d6' )
    end

    # Retrieve all template information. Build an array of template ids
    # here over which to iterate
    def retrieve_all_template_info
      puts "I'm in the Retrieve All Templates Module!"

      uri = URI(@config['endpoint'])

      # Retrieve templates
      http = Net::HTTP.new( uri.host,uri.port )
      http.use_ssl = true
      request = Net::HTTP::Get.new( uri.request_uri )
      request.basic_auth(@username, @password)

      response = http.request( request )
      templates = JSON.parse( response.body )

      save_templates( templates )
    end

    # Retrieve single template. This method will be iterative over
    # the result of #retrieve_all_template_info
    def retrieve_single_template( template_id )
      puts "I'm in the Retrieve Single Tempalte Module!"

      uri = URI(@config['endpoint'] + '/' + template_id)

      # Retrieve templates
      http = Net::HTTP.new( uri.host,uri.port )
      http.use_ssl = true
      request = Net::HTTP::Get.new( uri.request_uri )
      request.basic_auth(@username, @password)

      response = http.request( request )
      template = JSON.parse( response.body )

      puts JSON.pretty_generate( template )
    end

    # Save each template content here. This method will be iterative
    # over the result of #retrieve_single_template
    def save_templates( templates )
      puts JSON.pretty_generate( templates )
    end

    # Create a single template (in new location/account). This method
    # will be iterative over the result of #save_templates. The templates
    # created here will be blank.
    def create_template
    end

    # Popuate the newy created templates with the content received from
    # #save_templates. Each file will be read in iteratively, and content
    # matched to correct template.
    def populate_template
    end

    def parse_command_line_options( args )
      parser = OptionParser.new do |option|
        option.on('-p', '--production', 'Set environment to production') { @production = true }
        option.on('-h', '--help', 'Display help') do |x|
          puts parser.help
          exit 0
        end
      end
      parser.parse!( args )
    end
  end
end
