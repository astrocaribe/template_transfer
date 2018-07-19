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
      @config = YAML::load(File.open('config/config.yml'))

      username, password                       = config['sendgrid'].keys, config['sendgrid'].values
      @primary_username, @primary_password     = username[0], password[0]
      @secondary_username, @secondary_password = username[1], password[1]

      # Set environment
      parse_command_line_options( args )

      puts "TemplateTransfer::Script initialized!"
      puts
    end

    def run
      home_template_array = retrieve_all_template_info

      home_template_array.each do |item|
        puts '--------------------------------------------------'
        home_template = retrieve_single_template( item[:id] )
        backup_template( home_template )
        away_template_id = create_template( config['prepend_name']+item[:name] )
        populate_template( away_template_id, home_template )
        puts '--------------------------------------------------'
      end

      puts
      puts 'All templates transffered!'
    end

    # Retrieve all template information. Build an array of template ids
    # here over which to iterate
    def retrieve_all_template_info
      puts "Retrieving all template ids and names for #{@primary_username} ..."
      puts

      uri = URI(@config['endpoint'])

      # Retrieve templates
      http = Net::HTTP.new( uri.host,uri.port )
      http.use_ssl = true
      request = Net::HTTP::Get.new( uri.request_uri )
      request.basic_auth(@primary_username, @primary_password)

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
      request.basic_auth(@primary_username, @primary_password)

      response = http.request( request )
      template = JSON.parse( response.body )
    end

    # Save each template content here. This method will be iterative
    # over the result of #retrieve_single_template
    def backup_template( template )
      filename = "./templates/#{template['id']}.json"
      file = File.new(filename, "w")
        puts "Backing up #{filename} ..."
        file.write( template )
      file.close
    end

    # Create a single template (in new location/account). This method
    # will be iterative over the result of #save_templates. The templates
    # created here will be blank.
    def create_template( template_name )
      puts "Creating new template #{template_name} at #{@secondary_username}..."

      uri = URI(@config['endpoint'])

      # Retrieve templates
      http = Net::HTTP.new( uri.host,uri.port )
      http.use_ssl = true
      request = Net::HTTP::Post.new( uri.request_uri, initheader = {'Content-Type:' => 'application/json'} )
      request.basic_auth(@secondary_username, @secondary_password)

      payload = {:name => "#{template_name}"}.to_json
      request.body = payload

      response = http.request( request )
      new_template_info = JSON.parse( response.body )
      new_template_id = new_template_info['id']

      return new_template_id
    end

    # Popuate the newy created templates with the content received from
    # #save_templates. Each file will be read in iteratively, and content
    # matched to correct template.
    def populate_template( template_id, imported_template )
      puts "Populating new tempalte id: #{template_id}..."

      uri = URI(@config['endpoint']+"/#{template_id}/versions")

      # Retrieve templates
      http = Net::HTTP.new( uri.host,uri.port )
      http.use_ssl = true
      request = Net::HTTP::Post.new( uri.request_uri, initheader = {'Content-Type:' => 'application/json'} )
      request.basic_auth(@secondary_username, @secondary_password)


      # If versions exist, transfer each to new template
      imported_template['versions'].each do |version|
        version.delete("id")
        version.delete("user_id")
        version.delete("template_id")
        version.delete("updated_at")

        puts "    Adding template version #{version['name']}..."
        payload = version.to_json
        request.body = payload
        response = http.request( request )
        response_message = JSON.parse( response.body )
      end
    end

    def parse_command_line_options( args )
      parser = OptionParser.new do |option|
        option.on('-h', '--help', 'Display help') do |x|
          puts parser.help
          exit 0
        end
      end
      parser.parse!( args )
    end
  end
end
