fbrp Feature Based Rails Project
================================

Another one of those starter rails projects. This one has one interesting feature which is that it has rewritten 'features' for testing authentication using restful-authentication. The features have been written to be

1. Simple
1. Declarative rather than imperative (they say what should happen not how)
1. Have steps that are simple enough that I can understand them (that's pretty simple)


Dependencies
============

There are a few things you'll need, I've not frozen gems or done anything nice yet

1. rspec-rails
1. cucumber
1. object_daddy
1. the very latest haml
1. the very latest compass

All can be found here on github. Follow the installation instructions on the compass page for haml and compass.

Apologies for depending on compass, its not necessary for the features, but it is something I want to use. You may need other stuff as well.

Run Features
============

Finally

1. create a database.yml
1. run db:create:all db:migrate

Then the following should run and pass

1. rake spec 
1. rake features

