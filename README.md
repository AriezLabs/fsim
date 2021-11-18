# fsim

Implements automata in Swift.


## Specification syntax

A state is specified as follows:

```
stateId [ i ] [ a ]
  symbol targetId
```

* The first line specifies the state ID and special properties of the state.
* `i` marks the initial state, `a` marks accepting states
* Following indented lines specify transitions from `symbol` to `targetId`.
* Symbols may be sequences of any Unicode characters except spaces.

A full DFA specification is simply any sequence of state specifications. The alphabet is inferred to be all of the symbols that appear in at least one state specification.


## Running

Words are passed with each symbol separated by a space.

```
$ make
$ ./DFA uneven_num_of_as a a a a
```

The parser will ignore the first two lines of the file if they start with a bang. Prepend the following header to your spec:

```
#!/bin/bash
./DFA $0 $@; exit 
```

Now the spec is runnable directly: 

```
chmod +x spec
./spec 00 01 10 11
```

