# TemplateTransfer::Script

## Project Wiki

http://astrocaribe.github.io/template_transfer/

Please refer the the wiki for the transfer process details.

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

## Tests

Spec tests are run using `rspec`. Make sure to install bundled gems as described in [setup](#setup) section above. A valid config.yml file is
also required. See [configuration](#configuration) section above.
Once `rspec` is installed, run the tests by using:

```bash
$> rspec spec
```

**Note**: It has been ages since I've worked in Ruby, and the intentions
of the test suite was to cover all the cases that this tools was meant
to be used for. I have since moved on to other languages, and never had
the opportunity to complete them. Feel free to contibute by
adding/fleching out these tests, if I don't have the change to get back
to them!

## TemplateTransfer::Script Flow

This script was born out of the lack of resources to transfer templates between accounts, using the supplied Sendgrid Template API (https://sendgrid.com/docs/API_Reference/Web_API_v3/Template_Engine/templates.html). The process is outliined in the the [project wiki](http://astrocaribe.github.io/template_transfer/).

Note that this solution was coded in Ruby 2.1.2; to code in another language, just use this flow and code against appropriate analogs. I may code this solution in Python as well, if there is demand.

**Important Caveat:** This script **does not** selectively copy templates, nor is there the ability to select the templates that you want tranffered. This script will copy **ALL** templates from the first account!