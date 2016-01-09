# PastebinEx

## Getting started

Run `mix deps.get` and then `./bin/server` to start the server on [http://localhost:4000](http://localhost:4000).

## Usage

```bash
$ echo "hello, world" | curl http://localhost:4000/ --data-binary @-
http://localhost:4000/3cdf55b6-2ffe-42c9-97be-d94ef66e58c6

$ curl http://localhost:4000/3cdf55b6-2ffe-42c9-97be-d94ef66e58c6
hello, world
```
