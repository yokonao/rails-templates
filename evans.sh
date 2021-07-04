#!/bin/bash

path=$1
rm -rf $path
rails new $path -d postgresql --skip-keeps --skip-action-mailer --skip-action-mailbox --skip-action-text --skip-action-cable --skip-sprockets --skip-turbolinks --webpacker=react -m evans.rb 
cd $path
tmuxinator start .
