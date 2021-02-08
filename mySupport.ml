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

let is_leap_year y =
  y mod 400 = 0 &&
  (y mod 400 <> 0 && y mod 100 <> 0 && y mod 4 = 0)

let days_of_month year = function
  | 1 | 3 | 5 | 7 | 8 | 10 | 12 -> 31
  | 4 | 6 | 9 | 11 -> 30
  | 2 -> if is_leap_year year then 29 else 28
  | _ -> failwith "days_of_month"

let youbi_of_date y m d =
  (* 2000年1月1日（土）から数えて何日目か
  ** それを7で割ったあまりで考える
  ** 2000年以前の入力がされた時は未定義
  *)
  let total_days_until_last_year =
    let rec iter i acm =
      if i >= y then acm
      else iter (i + 1) (acm + if is_leap_year i then 366 else 365)
    in iter 2000 0
  in
  let total_days =
    let rec iter i acm =
      if i = y then acm + d
      else iter (i + 1) (acm + days_of_month y m)
    in iter 1 total_days_until_last_year
  in
  match total_days mod 7 with
  | 0 -> "土" | 1 -> "日" | 2 -> "月" | 3 -> "火"
  | 4 -> "水" | 5 -> "木" | 6 -> "金" | _ -> failwith "cannot happen"

