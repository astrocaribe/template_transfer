require 'net/http'
require 'net/https'
require 'json'
require 'uri'
require 'yaml'
require 'optparse'
require 'json'

module ListTemplates
  class Script
    attr_reader :config
    attr_reader :template_array

    def initialize( args )
      @config     = YAML::load(File.open('config/config.yml'))
      @username   = nil
      @password   = nil

      # username, password                        = config['sendgrid'].keys, config['sendgrid'].values
      # @primary_username, @primary_password      = username[0], password[0]
      # @secondary_username, @secondary_password  = username[1], password[1]

      # Set the environment
      parse_command_line_options( args )

      puts "ListTemplates::Script initialized!"
      puts
    end

    def run
      home_template_array = retrieve_all_template_info

      if home_template_array then
        puts "There are #{home_template_array.length} templates available to #{@username}..."
        puts

        home_template_array.each do |t|
          puts "GUID: #{t[:id]}, Name: #{t[:name]}"
        end
      else
        puts "No templates to show!"
      end
    end


    def retrieve_all_template_info
      config['sendgrid'].each do |c|
        if c[0].to_sym == @username.to_sym then
          @password = c[1]
        end
      end

      if @password then
        puts "Retrieving all template ids and names for #{@username} ..."

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
      else
        puts "There is no entry for #{@username} in config.yml."
        return nil
      end
    end


    def parse_command_line_options( args )
      parser = OptionParser.new do |option|
        option.on('-u', '--user', 'List templates for user') do |u|
          @username = ARGV[0]
        end
        option.on('-h', '--help', 'Display help') do |x|
          puts parser.help
          exit 0
        end
      end
      parser.parse!( args )
    end

  end
end