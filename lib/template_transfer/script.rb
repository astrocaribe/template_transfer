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
    attr_reader :template_array

    def initialize( args )
      @production = false
      @config = YAML::load(File.open('config/config.yml'))
      @username = @config['sendgrid']['username']
      @password = @config['sendgrid']['password']

      # Set environment
      parse_command_line_options( args )

      puts "TemplateTransfer::Script initialized!"
      puts
    end

    def run
      home_template_array = retrieve_all_template_info

      home_template_array.each do |item|
        away_template = retrieve_single_template( item[:id] )
        save_template( away_template )
        puts '--------------------------------------------------'
      end
    end

    # Retrieve all template information. Build an array of template ids
    # here over which to iterate
    def retrieve_all_template_info
      puts "Retrieving all template ids and names for #{@username} ..."
      puts

      uri = URI(@config['endpoint'])

      # Retrieve templates
      http = Net::HTTP.new( uri.host,uri.port )
      http.use_ssl = true
      request = Net::HTTP::Get.new( uri.request_uri )
      request.basic_auth(@username, @password)

      response = http.request( request )
      templates = JSON.parse( response.body )

      # Create template_id array
      @template_array = Array.new

      # Create a template hash w/ name and id for each template found
      templates['templates'].each do |t|
        @template_array.push({:id => t['id'], :name => t['name']})
      end

      # Return constructed temmplate array
      return template_array
    end

    # Retrieve single template. This method will be iterative over
    # the result of #retrieve_all_template_info
    def retrieve_single_template( template_id )
      puts "Retrieving template id #{template_id}."

      uri = URI(@config['endpoint'] + '/' + template_id)

      # Retrieve templates
      http = Net::HTTP.new( uri.host,uri.port )
      http.use_ssl = true
      request = Net::HTTP::Get.new( uri.request_uri )
      request.basic_auth(@username, @password)

      response = http.request( request )
      template = JSON.parse( response.body )

      # puts JSON.pretty_generate( template )
    end

    # Save each template content here. This method will be iterative
    # over the result of #retrieve_single_template
    def save_template( template )
      filename = "./templates/#{template['id']}.json"
      file = File.new(filename, "w")
        puts "Saving #{filename} ..."
        file.write( template )
      file.close
      # puts template
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
