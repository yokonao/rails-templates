#!/bin/bash

app_name=$1
rm -rf ../$app_name
APP_NAME=$app_name rails new ../$app_name -d postgresql --skip-keeps --skip-action-mailer --skip-action-mailbox --skip-action-text --skip-action-cable --skip-sprockets --skip-turbolinks --webpacker=react -m evans.rb 
cd ../$app_name
tmuxinator start .
