open MySupport
(* log をいじる部分はモジュールとしてまとめる *)

let rec to_state1 () = (* 状態1 *)
  print_endline "何をしますか？（番号を1つ入力）";
  print_endline "1. 記録";
  print_endline "2. 閲覧（直近60日間）";
  print_endline "3. 終わる";
  print_endline ">";
  (try 
    Scanf.scanf "%d" @@ function
      | 1 -> (print_endline "学習時間を記録します"; to_state2 ())
      | 2 -> (print_endline "記録を閲覧します。"; to_state6 ())
      | 3 -> print_endline "ラーニングログを終わります。";
      | _ -> (Printf.printf "1~3 の番号を入力してください。"; to_state1 ())
  with _ -> Printf.printf "1~3の番号を入力してください。"; to_state1 ())
and to_state2 () = (* 状態2 *)
  print_endline "記録する日付をmmdd形式で入力してください（中止する場合は q）";
  print_endline "例：6月1日は 0601";
  Scanf.scanf "%s" @@ fun s ->
    if s = "q" then to_state1 ()
    else
      begin
        try 
          let month = month_of_int @@ int_of_string @@ String.sub s 0 2 
          and day = int_of_string @@ String.sub s 2 (String.length s - 2) in
          if is_day month day
          then to_state3 month day ()
          else (print_endline "形式が違います。やり直してください。"; to_state2 ())
        with _ -> (print_endline "形式が違います。やり直してください。"; to_state2 ())
      end
and to_state3 month day () = (* 状態3 *)
  print_endline "データを参照しています。";
      


(* 起動時 *)
let () =
  print_endline "--- Learning Log ---";
  print_endline "今日もお疲れ様でした。";
  to_state1 ()