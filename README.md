## Usage
  To build this application, execute below commands.
``` bash
$ bundle install
$ docker-compose up
$ bundle exec rake db:create
$ bundle exec rake db:schema:load
```

  Application will start when execute below commands.
``` bash
$ bundle exec sidekiq -C config/sidekiq.yml
$ bundle exec rails s
```

  If you want store data by curl command,  
  try below commands.
``` bash
$ curl -X POST -H 'Content-Type:application/json' -d '{ "location": "X X" }' http://0.0.0.0:3000/thermostats
$ curl -X POST -H 'Authorization: Token "obtain token from first command"' -H 'Content-Type:application/json' -d '{ "temperature": "XX.X", "humidity": "YY.Y", "battery_charge": "Z.Z" }' http://0.0.0.0:3000/readings
$ curl -X GET -H 'Authorization: Token "obtain token from first command"' http://0.0.0.0:3000/readings/:number
$ curl -X GET -H 'Authorization: Token "obtain token from first command"' http://0.0.0.0:3000/stats
```

  If you already installed golang, try below.  
  It creates the data by executing above flow.
``` bash
$ go run tester.go
```
