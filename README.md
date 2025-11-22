### Boolean Logic Evaluator
***
An OCaml program that evaluates logical expressions written in conjunctive normal form and finds a true/false assignment that makes them evaluate to TRUE.
### Features
***
- Parses logical expressions written using `AND`, `OR`, `NOT`, and parentheses.
- Extracts variables and generates all possible true/false assignments.
- Evaluates each assignment against the logical expression.
- Returns the *first* assignment that satisfies the expression.
- Returns `[("error", true)]` if no satisfying assignment exists.
### Example
***
Input:
```
( a OR b ) AND ( NOT c )
```

Output:
```ocaml
[("a", true); ("b", false); ("c", false)]
```

### How to Run
***
1. Open a terminal.

2. Navigate to the folder where your files are located:
```
cd path/to/your/files
```

3. Start OCaml:
```
ocaml
```

4. Inside the OCaml prompt, load the solver and driver files:
```
# #mod_use "solver.ml";;
# #load "str.cma";;
# #use "driver.ml";;
```

Once loaded, you can evaluate expressions like this:

```
# satisfyFromString "( a OR b ) AND ( NOT c )";;
```

This will return a list of `(variable, bool)` pairs representing the first satisfying assignment found.
### File Structure
***
- **solver.ml** contains all implementation details.
- **driver.ml** provides simple wrapper functions for testing in the OCaml interpreter.
### Notes
***
- Variables must be lowercase letters `a` through `z`.
- Supported logical operators: `AND`, `OR`, `NOT`.
- Parentheses are required around each clause.
- Boolean constants `TRUE` and `FALSE` are also supported.
