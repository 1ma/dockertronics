# Sleepy

Sleepy is a testing and mocking HTTP server that takes as long to reply as you tell it (using the `ms` query parameter),
and then echoes back the serialization of the HTTP request exactly as it received it.

It was primarily designed to aid in testing the [Hydra](https://gitlab.com/1ma/hydra) HTTP client.


### Build

Note: Needs the [go toolchain](https://golang.org/dl/) available on your system.

```
$ CGO_ENABLE=0 go build -tags netgo -v -ldflags="-d -s -w" -o sleepy
```


### Run

```
$ ./sleepy [port, default 1234]
[sleepy] 2019/03/04 16:53:09 Sleepy built with go1.12
```

Alternatively, you can run the Docker image:
 
```
$ docker run --rm -it -p 127.0.0.1:1234:1234 1maa/sleepy:latest
[sleepy] 2019/03/04 16:53:09 Sleepy built with go1.12
```


### Usage

```
$ time curl -i localhost:1234
HTTP/1.1 200 OK
Server: sleepy
Date: Mon, 04 Mar 2019 20:45:13 GMT
Content-Length: 78
Content-Type: text/plain; charset=utf-8

GET / HTTP/1.1
Host: localhost:1234
Accept: */*
User-Agent: curl/7.63.0

real	0m0.010s
user	0m0.005s
sys	0m0.004s


$ time curl -i localhost:1234?ms=1500
HTTP/1.1 200 OK
Server: sleepy
Date: Mon, 04 Mar 2019 20:45:54 GMT
Content-Length: 86
Content-Type: text/plain; charset=utf-8

GET /?ms=1500 HTTP/1.1
Host: localhost:1234
Accept: */*
User-Agent: curl/7.63.0

real	0m1.510s
user	0m0.006s
sys	0m0.004s


$ time curl -i -X POST -H "Content-Type: application/json" -d'{"foo":"bar"}' localhost:1234?ms=5000
HTTP/1.1 200 OK
Server: sleepy
Date: Mon, 04 Mar 2019 20:47:49 GMT
Content-Length: 152
Content-Type: text/plain; charset=utf-8

POST /?ms=5000 HTTP/1.1
Host: localhost:1234
Accept: */*
Content-Length: 13
Content-Type: application/json
User-Agent: curl/7.63.0

{"foo":"bar"}

real	0m5.011s
user	0m0.006s
sys	0m0.004s
```
