.PHONY: install run tests

install:
	mix deps.get
run:
	iex -S mix

tests:
	mix test
