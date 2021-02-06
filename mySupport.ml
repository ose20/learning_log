(* MySupport: 補助関数群*)
open Str

let i_of_s s = int_of_string s
let f_of_s s = float_of_string s
let i_of_f f = int_of_float f
let data_of_log y m d time =
  (i_of_s y, i_of_s m, i_of_s d, f_of_s time)
let prompt () = print_char '>'; flush stdout
let days_of_month = function
  | 2 -> 29
  | 4 | 6 | 9 | 11 -> 30
  | 1 | 3 | 5 | 7 | 8 | 10 | 12 -> 31
  | _ -> failwith "days_of_month: days does not represent month"

let ymd_of_string s =
  assert (String.length s = 8);
  let y = int_of_string @@ String.sub s 0 4 in
  let m = int_of_string @@ String.sub s 4 2 in
  let d = int_of_string @@ String.sub s 6 2 in
  assert (1 <= m && m <= 12 && 1 <= d && d <= days_of_month m);
  (y, m, d)

let time_of_string s =
  let slist = split (regexp "\\.") s in
  if List.length slist < 1 || 2 < List.length slist
  then failwith "time_of_string"
  else if List.length slist = 1
  then
    match slist with
    | [x] -> float_of_string x
    | _ -> failwith "time_of_string"
  else
    match slist with
    | [x; y] -> 
        let _ = int_of_string x in
        let f = int_of_string y in
        if f <> 5 && f <> 0 then failwith "time_of_string"
        else float_of_string s
    | _ -> failwith "time_of_string"

let whle cond body =
  let rec iter () =
    if cond () then body () else ()
  in iter ()