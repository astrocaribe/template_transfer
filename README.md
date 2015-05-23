# TemplateTransfer::Script

## Scope

The purpose of this script is tranfer Sendgrid templates and their versions from one account to another.

Currently, Sendgrid does not the option for automatic bulk tranfer of templates; to accomplish this task, templates have to be manually copied from one account, and saved to the other. This script automatates this task, using the available Sendgrid template API (https://sendgrid.com/docs/API_Reference/Web_API_v3/Template_Engine/templates.html).

## Setup

It is recommended to configre an RVM gemset:

    $> echo 'ruby-2.1.2' > .ruby-version
    $> echo 'template_tranfer' > .ruby-gemset

Note: The `$>` is meant to signify the terminal prompt, and is not part of the command; do not include this prompt in your command line!

Install bundled gems:

    $> bundle install

Note: This script is bundled as a gem; there are no other dependencies except the ones bundled with this gem (available via http://rubygems.com).

## Configuration

This project expects a local config/config.yml to specify the following:

1. **sendgrid:** Sendgrid credentials for accounts to transfer templates *from* and *to*, in that order.
2. **prepend_name:** String text to prepend to the beginning of each template name, to help distiguish tranffered templates.
3. **endpoint:** URI endpoint for the Sendgrid template API operations.

An example file has been supplied and the primary file is ignored by version control:

    $> cp config/config.yml.example config/config.yml

## Usage

The script can be run directly from the *bin/* directory; first, make the script launcher executable, if it isn't already:

    $> chmod +x bin/template_transfer

Then execute the script:

    $> bin/template_transfer

You can also time the script operation to determine how long the transfer takes:

    $> time bin/template_transfer


## TemplateTransfer::Script Flow

This script was born out of the lack of resources to transfer templates between accounts, using the supplied Sendgrid Template API (https://sendgrid.com/docs/API_Reference/Web_API_v3/Template_Engine/templates.html). Below is an outline of the process I used to accomplish the task. Most of this was trial and error, and I want to save others the pain of this process.

Note that this solution was coded in Ruby 2.1.2; to code in another language, just use this flow and code against appropriate analogs. I may code this solution in Python as well, if there is demand.

**Important Caveat:** This script **does not** selectively copy templates, nor is there the ability to select the templates that you want tranffered. This script will copy **ALL** templates from the first account!

### Tranfer Steps
1. Copy all templates from Account1 (account you want to copy templates from):
    + This operation does not copy the template contents, though identifying metadata for templates and underlying versions (id, name, etc.) are returned.
    + The :name and :id of each template is stored in an array in memory for use in the following steps.
    + Curl Example: `curl -X GET https://username:password@api.sendgrid.com/v3/templates/`

2. Retrieve each template, with given :id from step 1:
    + This operation retrieve one template, but returns all relevant data for that template (:name, :id, :versions, :html_content, :plain_content, etc.)
    + Returns the retrieved template.
    + Cur Example: `curl -X GET https://username:password@api.sendgrid.com/v3/templates/:template_id`

3. Backup template:
    + This step stores this template in a JSON file in the templates/ directory
    + Name format is ':template_id'.json

4. Create an empty template in Account2 (receiving account):
    + Before any template information can be tranffered, a new template needs to be created.
    + A name is required to create the new template. The name of the original template, with a prepended string is used in the script.
    + The newly created template will have a different :id than the original
    + **Note:** If a template with the name that already exist is attempted, the creation will fail.
    + Curl Example `curl -H "Content-Type: application/json" -X POST -d {"name":"template_name"} https://username:password@api.sendgrid.com/v3/templates/`

5. Populate template:
    + Tranfer the template information retrieved in step 2.
    + Script pushes versions of current template, one at a time, if different versions exist.
    + Relevant template version documentation can be found at https://sendgrid.com/docs/API_Reference/Web_API_v3/Template_Engine/versions.html
    + Curl Example `curl -H "Content-Type: application/json" -X POST -d @template_content.json https://username:password@api.sendgrid.com/v3/templates/:template_id/versions`

6. Repeat steps #2-#5 until the end of the array returned in step #1
    + Perform Steps #2 thru #5 for all templates in the array.

---

# Notes
### May 18, 2015
----------------

1. Retrieving all templates from a given account DOES NOT return template content. As such, the following approach will be taken:
    - Retrieve all template information, and build an array of main template ids.
    - Iterate through array to retrieve/store content for each template (including versions).

### May 19, 2015
----------------

1. Based on experience from last coding session, script now follows these steps:
    - Retrieves all templates from account, storing :id and :name in an template array of hashes.
    - Iterates over template array, retrieving by template id, then storing each retrieved template in an external file (template_id.json), including metadata (versions, html_content, plain_content, for example).

### May 20, 2015
----------------

1. Changed #save_template to #backup_template. Since the downloaded template will already be in memory, it makes more sense to backup the template for prosperity's sake, then create and populate a new template with the current template in memory. No need to read a file for this operation!
2. Include the 2nd account (secondary_account?) to config.yml file. This will be needed for creating and populating the new templates.

### May 21, 2015
----------------

1. Script now creates a new template for every imported template.
2. Currently attempting to populate new templates with versions from the imported template.

#### Observations:
- Version names must be unique accross accounts
- If template already exists, 400 response is returned
    + I'm going to assume that all templates will be unique on the CHC site
- Current attempts at populating the newly created template results in a 400 error from Sendgrid:
    + Net::HTTPBadRequest 400 BAD REQUEST readbody=true
    + {"error"=>"JSON is malformed"}

### May 22, 2015
----------------

1. Working proptotype script!
2. Template are now being tranffered, including versions.
3. The previous error was due to trying to process a versions array. The solution was to process each item in the array seperately.