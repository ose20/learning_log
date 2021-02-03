(* MySupport: 補助関数群*)

type month =
  | January | February | March | April
  | May | June | July | August 
  | September | October | November | December

let month_of_int = function
  | 1 -> January | 2 -> February | 3 -> March | 4 -> April
  | 5 -> May | 6 -> June | 7 -> July | 8 -> August
  | 9 -> September | 10 -> October | 11 -> November | 12 -> December
  | _ -> failwith "argument does not represent month" 

let int_of_month = function
  | January -> 1 | February -> 2 | March -> 3 | April -> 4
  | May -> 5 | June -> 6 | July -> 7 | August -> 8
  | September -> 9 | October -> 10 | November -> 11 | December -> 12

(* 与えられた整数が月を表しているか *)
let is_month m = 1 <= m && m <= 12

(* 与えられた月の日数 *)
(* 簡単のため2月は29日までとする*)
let days_in_month = function
  | February -> 29
  | (April | June | September | November) -> 30
  | (January | March | May | July | August | October | December) -> 31

(* 与えられた月と日が正しいか *)
let is_day m d = 1 <= d && d <= days_in_month m