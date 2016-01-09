# PastebinEx

PastebinEx is a simple pastebin service written in
[Elixir](http://elixir-lang.org) using
[Plug](https://github.com/elixir-lang/plug).

## Getting started

Run `mix deps.get` and then `./bin/server` to start the server on [http://localhost:4000](http://localhost:4000).

## Usage

```bash
$ echo "hello, world" | curl http://localhost:4000/ --data-binary @-
http://localhost:4000/3cdf55b6-2ffe-42c9-97be-d94ef66e58c6

$ curl http://localhost:4000/3cdf55b6-2ffe-42c9-97be-d94ef66e58c6
hello, world
```
