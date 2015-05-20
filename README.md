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