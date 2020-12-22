# StreamAggregator

It's a system that receives an infinite stream of whitespace-delimited words over a websocket.

## Dependencies

To run it, you need to install:

* [Elixir (v1.10)](http://elixir-lang.org)
* [Erlang/OTP (v22.1)](https://www.erlang-solutions.com/resources/download.html)

## Installing

```
$ make install
```

## Running server with console

```bash
$ make run
```

## usage

```bash
$(while true; do cat text.txt; done) | wscat -c ws://127.0.0.1:1234
```

## Running tests

```bash
$ make tests
```
## Development notes

I used `GenServer` to maintain the socket and state words group and dispatch a recursive function that communicate the socket client about the most frequent word.
