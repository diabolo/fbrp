RSpec Haml Scaffold Generator
=============================


This is an uber version of the RSpec Scaffold Generator, the following things have been added:

Support for Haml instead of erb
Nested routes (nested tests/migrations)

Examples:

- `./script generate rspec_haml_scaffold post` # no attributes, view will be anemic
- `./script generate rspec_haml_scaffold post attribute:string attribute:boolean` 

Diabolists Additions & Removals
===============================

Made README markdown and added this section
Removed view specs - IMO views should be tested by features

Unobtrusive Destroy Method
--------------------------

Instead of using rails standard destroy, I have a confirmation form that the user will drop into. To get this to work you need to add a section to your `routes.rb`

[See this blog article](http://www.david-mcnally.co.uk/2008/11/04/the-missing-named-route/)

Here is the code in question

    class ActionController::Resources::Resource
      protected
        def add_default_actions
          add_default_action(member_methods, :get, :edit)
          add_default_action(member_methods, :get, :destroy)
          add_default_action(new_methods, :get, :new)
        end
    end

The generator does not add this code and expects you will implement a one step javascript destroy at a later date.