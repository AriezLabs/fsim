# fsim

Implements automata in Swift.


## DFA specification syntax

For example, a DFA that accepts an uneven number of `a`s:

```
#!/bin/bash
./DFA $0 $@; exit 

# the two initial lines make this file executable
# (they're optional - if the file starts with a bang, the parser will ignore the first two lines)

# this defines a state - transitions are defined below
# i marks the initial state
initial i
  a accept

# a marks accepting states
accept a
  a initial
```


## Running

Words are passed with each symbol separated with a space.

```
$ make
$ ./DFA uneven_num_of_as a a a a
```

If the spec includes the bang, we can simpy run it like:

```
$ ./uneven_num_of_as a a a a
```

Note that the `DFA` binary must be in the same directory.

