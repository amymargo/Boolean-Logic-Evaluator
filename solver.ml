
let validVarNames = ["a";"b";"c";"d";"e";"f";"g";"h";"i";"j";"k";"l";"m";"n";"o";"p";"q";"r";"s";"t";"u";"v";"w";"x";"y";"z"];;

let partition (input: string list) (bound : string) : string list list =
  let rec aux acc current = function
    | [] -> List.rev (current :: acc)
    | x :: xs when x = bound -> aux (current :: acc) [] xs
    | x :: xs -> aux acc (x :: current) xs
  in
  aux [] [] input |> List.map List.rev
;;

let getVariables (input : string list) : string list =
  List.filter (fun x ->
    List.mem x validVarNames && not (List.mem x ["AND"; "OR"; "NOT"; "("; ")"; "TRUE"; "FALSE"])
  ) input |> List.sort_uniq compare
;;

let rec generateDefaultAssignments (varList : string list) : (string * bool) list =
  List.map (fun var -> (var, false)) varList
;;

let rec generateNextAssignments (assignList : (string * bool) list) : (string * bool) list * bool =
  let rec aux carry = function
    | [] -> ([], carry)  (* If carry propagates past the leftmost variable, return carry *)
    | (var, value) :: rest ->
      if carry then
        if value then  (* If the current variable is true, flip to false and continue carry *)
          let updated_rest, new_carry = aux carry rest in
          ((var, false) :: updated_rest, new_carry)
        else  (* If the current variable is false, flip to true and stop carry *)
          let updated_rest, _ = aux false rest in
          ((var, true) :: updated_rest, false)
      else
        let updated_rest, new_carry = aux carry rest in
        ((var, value) :: updated_rest, new_carry)
  in
  aux true (List.rev assignList) |> fun (res, carry) -> (List.rev res, carry)
;;

let rec lookupVar (assignList : (string * bool) list) (str : string) : bool =
  match assignList with
  | [] -> raise (Invalid_argument "Variable not found")
  | (var, value) :: rest -> if var = str then value else lookupVar rest str
;;

let buildCNF (input : string list) : (string * string) list list =
  let clauses = partition input "AND" in
  List.map (fun clause ->
    let literals = partition clause "OR" |> List.flatten in
    let rec process_literals acc = function
      | [] -> List.rev acc
      | "NOT" :: var :: rest -> process_literals ((var, "NOT") :: acc) rest
      | literal :: rest when literal = "(" || literal = ")" -> process_literals acc rest
      | literal :: rest -> process_literals ((literal, "") :: acc) rest
    in
    process_literals [] literals
  ) clauses
;;

let evaluateCNF (t : (string * string) list list) (assignList : (string * bool) list) : bool =
  let evaluate_clause clause =
    List.exists (fun (var, negation) ->
      let value = lookupVar assignList var in
      if negation = "NOT" then not value else value
    ) clause
  in
  List.for_all evaluate_clause t
;;


let satisfy (input : string list) : (string * bool) list =
  let cnf = buildCNF input in
  let vars = getVariables input in
  let rec try_assignments assignments =
    if evaluateCNF cnf assignments then assignments
    else
      let next_assignments, carry = generateNextAssignments assignments in
      if carry then [("error", true)]
      else try_assignments next_assignments
  in
  let initial_assignments = generateDefaultAssignments vars in
  try_assignments initial_assignments
;;