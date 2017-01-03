
##Quick Start
To start the container the first time, run 
```
docker run -d -p 3000:3000 -p 8086:8086 -p 8083:8083 -p 8125:8125/udp -v /Users/zhaoy1/docker/grafana:/var/lib/grafana -v /Users/zhaoy1/docker/influxdb:/var/lib/influxdb zhaoy1/grafana
```

## Mapped Ports
3000: Grafana 
8086: Influxdb
8083: Influxdb Admin
8125: Statsite

## Grafana
Open <http://localhost:3000>

## InfluxDB
### Mgmt Web
Open <http://localhost:8083>

```
Username: root
Password: root
Port: 8086
```


## influx DB ping
curl -sl -I localhost:8086/ping


## user account
user/account: admin/admin

## volumn map
/var/lib/grafana
/var/lib/influxdb

