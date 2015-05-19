# TemplateTransfer::Script
This repo houses a script that is intended to retrieve Sendgrid templates from a given account, and transfer them to a second, preserving the content.

# Notes:
- May 18, 2015
1. Retrieving all templates from a given account DOES NOT return template content. As such, the following approach will be taken:
    - Retrieve all template information, and build an array of main template ids.
    - Iterate through array to retrieve/store content for each template (including versions).