# fsim

A finite automata simulator in Swift. Automata are specified in a simple DSL explained below.


## Specification syntax

The syntax is a simple header followed by a sequence of state specifications. Generally, everything is space-separated. The machine's alphabet is inferred to be all of the symbols that appear in at least one state specification. It is not a requirement that all states have a transition defined for every symbol in the alphabet.

See `machines/` for examples.


### Header

The header currently only serves to specify the type of the FSM (`DFA` or `NFA`), for example:

```
type NFA
```


### States

A state is specified as follows:

```
stateId [ i ] [ a ]
  symbol targetId
```

* The first line specifies the state ID and special properties of the state.
* `i` marks the initial state, `a` marks accepting states
* Subsequent indented lines specify transitions from `symbol` to `targetId`.
* Symbols may be sequences of any Unicode characters except spaces.


### NFA additions

* NFAs may have more than one transition per state and symbol.
* `epsilon` is a reserved symbol for NFAs, specifying epsilon-transitions.



## Running

Words are passed as sequences of space-separated symbols.

```
$ make
$ ./fsim odd_number_of_zeroes 0 0
reject
```

For convenience, the parser will ignore the first two lines of the specification file if they start with a bang. Prepend the following header to your spec:

```
#!/bin/bash
./fsim $0 $@; exit 
```

Now the spec is runnable directly: 

```
$ chmod +x spec
$ ./parallel_nfa 0 0
accept
```

