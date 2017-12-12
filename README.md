Musaic
=====================

##Introduction

Musaic is a Spotify analyzer application that allows users sign into their Spotify accounts to see interesting analyses about their music tastes, get song recommendations based on specified song attributes, and how they compare to other users in the database.

##Preview
![picture](img/signin.png)
![picture](img/name.png)
![picture](img/user.png)
![picture](img/global.png)
![picture](img/preferences.png)

##To Run

###Windows:

1. unzip database files or git clone https://github.com/sarahzhou97/SpotifyApp.git
2. in \app\assets\javascripts\application.js remove the line 'require tree'
3. create a role in pgadmin corresponding to you (for me it was "zachary")
4. cd into the app
5. Run ‘gem bundle install’
6. Run 'rails s'
7. If there is an ssl error add the following:
	* Add to application.rb 
	* require 'openssl'
	* OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
8. You also may need to change the pg_hba.conf file in your local installation of postgresql located at  \Postgresql\9.6\data. Where it says 'mdb' change to 'trust' 
9. Create Database: 'rake db:create'
10. Schema Migrations: 'rake db:migrate'
11. At this point the app should run on local server 'localhost:3000'
12. To deploy app, you need to push to heroku

###Mac:

1. unzip database files or git clone https://github.com/sarahzhou97/SpotifyApp.git
2. cd into the app
3. Run ‘bundle install’
4. Run 'rails s'
5. Create Database: 'rake db:create'
6. Schema Migrations: 'rake db:migrate'
7. At this point the app should run on local server 'localhost:3000'
8. To deploy app need to push to heroku



*Note: User must have Ruby, rbenv, postregesql, and Rails installed to run app. We recommend this resource: https://www.tutorialspoint.com/ruby-on-rails/rails-installation.html*



