# Thermostat Reading API

The API consists of 3 methods.
1. POST Reading: stores temperature, humidity and battery charge from a particular thermostat.
2. GET Reading: returns the thermostat data using the reading_id obtained from POST Reading.
3. GET Stats: gives the average, minimum and maximum by temperature, humidity and battery_charge in a particular thermostat across all the period of time.

# Getting Started
## Setup project
```
$ cd $PROJ_DIR
$ cp config/database.example.yml config/database.yml
$ cp env.example .env
$ bundle install
$ rails db:setup
```
## Launch rails server
```
$ rails s
```
## Start redis and sidekiq
```
$ redis-server
$ sidekiq
```
## Running rspec test
```
$ rspec
```
