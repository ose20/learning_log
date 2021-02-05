(* MySupport: 補助関数群 *)

(* int_of_string *)
val i_of_s : string -> int

(* float_of_string *)
val f_of_s : string -> float

(* int_of_float *)
val i_of_f : float -> int

(* > を標準出力したのち stdout を flush する *)
val prompt : unit -> unit

(* その月の日の数を返す。2月は29日までとする *)
val days_of_month : int -> int

(* yyyymmdd 形式の文字列を受け取り年月日を返す *)
(* 形式が異なった場合はエラーを返す *)
val ymd_of_string : string -> int * int * int

(* "n.5" or "n." or "n" を受け取り実数型にして返す *)
(* それ以外の形式はエラーを返す *)
val time_of_string : string -> float