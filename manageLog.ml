(* ManageLog: ログファイルを操作する *)
open MySupport
open Str

(*    持ちたい機能 
  - 入力された日付が log.txt に既に存在するか
  - add (上書き)
  - 直近 60 日のデータのリストを取得
    - log.txt を日付が新しい順に並べたリストを得る
    - そこから上位 60 個を、古い順に並べる
*)

module Date =
  struct
    type t = int * int * int (* 西暦、月、日の組 *)
    let compare (y1, m1, d1) (y2, m2, d2) = (* 新しい日付がより小さいとする *)
      match (y1 - y2, m1 - m2, d1 - d2) with
      | (r, _, _) when r > 0 -> -1
      | (r, _, _) when r < 0 -> 1
      | (0, r, _) when r > 0 -> -1
      | (0, r, _) when r < 0 -> 1
      | (0, 0, r) when r > 0 -> -1
      | (0, 0, r) when r < 0 -> 1
      | (0, 0, 0) -> 0
      | _ -> failwith "Date.compare: cannot happen"
  end

module LogMap = Map.Make (Date)

type t = float LogMap.t
type filetype = string
let empty : t = LogMap.empty
let logfile : filetype = "log.txt"


(* 起動時の log.txt の読み込み & それらを格納した Map を返す *)
let loginit () : t =
  let logmap = LogMap.empty in
  let in_ch = open_in logfile in
  let rec input_log logmap =
    let s = try input_line in_ch with End_of_file -> "---" in
    if string_match (regexp "^--") s 0 || string_match (regexp "\\$") s 0 
    then (close_in in_ch; logmap)
    else if string_match (regexp ";;") s 0 then input_log logmap
    else
      begin
        let (y, m, d, t) =
          match split (regexp ",") s with
          | [ys; ms; ds; ts] -> (i_of_s ys, i_of_s ms, i_of_s ds, f_of_s ts)
          | _ -> failwith "Failure: pattern much (y, m, d, t)"
        in
        input_log @@ LogMap.add (y, m, d) t logmap
      end
  in input_log logmap 

(* 指定された日付のデータが既に存在するか *)
let mem y m d (logmap : t)
  = LogMap.mem (y, m, d) logmap

(* 新しいデータを追加 & log.txt への書き込み *)
(* 上書きもこれでできる *)
let add y m d time (logmap : t) : t =
  let out_ch = open_out_gen [Open_wronly; Open_append; Open_text] 0o666 logfile in
  Printf.fprintf out_ch "%d,%02d,%02d,%.1f\n" y m d time;
  close_out out_ch;
  LogMap.add (y, m, d) time logmap

(* logmap から直近60日のデータを取ってきて出力 *)
let show_log (logmap : t) =
  let data_lst = LogMap.bindings logmap in
  let rec take_elt n result lst =
    match (n, lst) with
    | (0, _) -> result
    | (_, []) -> result
    | (_, ((y, m, d), time)::rest) -> 
        take_elt (n - 1) ((y, m, d, time)::result) rest
  in
  let result_lst = take_elt 60 [] data_lst in
  let rec make_gauge n =
    if n = 0 then "" else "▮" ^ (make_gauge (n - 1)) in
  let print_day (y, m, d, time) =
    Printf.printf "%02d/%02d（%s） |%s %.1f\n" m d
    (youbi_of_date y m d)
    (make_gauge @@ i_of_f @@ 4.0 *. time) time
  in
  Printf.printf "\n\n";
  List.iter (fun day -> print_day day) result_lst;
  Printf.printf "\n\n"