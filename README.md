# TemplateTransfer::Script
This repo houses a script that is intended to retrieve Sendgrid templates from a given account, and transfer them to a second, preserving the content.

# Notes:
- May 18, 2015  
1. Retrieving all templates from a given account DOES NOT return template content. As such, the following approach will be taken:
    - Retrieve all template information, and build an array of main template ids.
    - Iterate through array to retrieve/store content for each template (including versions).

- May 19, 2015  
1. Based on experience from last coding session, script now follows these steps:
    - Retrieves all templates from account, storing :id and :name in an template array of hashes.
    - Iterates over template array, retrieving by template id, then storing each retrieved template in an external file (template_id.json), including metadata (versions, html_content, plain_content, for example).

- May 20, 2015  
1. Changed #save_template to #backup_template. Since the downloaded template will already be in memory, it makes more sense to backup the template for prosperity's sake, then create and populate a new template with the current template in memory. No need to read a file for this operation!
2. Include the 2nd account (secondary_account?) to config.yml file. This will be needed for creating and populating the new templates.

- May 21, 2015
1. Script now creates a new template for every imported template.
2. Currently attempting to populate new templates with versions from the imported template.

#### Observations:
- Version names must be unique accross accounts
- If template already exists, 400 response is returned
    + I'm going to assume that all templates will be unique on the CHC site
- Current attempts at populating the newly created template results in a 400 error from Sendgrid:
    + Net::HTTPBadRequest 400 BAD REQUEST readbody=true
    + {"error"=>"JSON is malformed"}