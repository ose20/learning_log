
(* log をいじる部分はモジュールとしてまとめる *)
(* 状態1 *)
let rec to_state1 () =
  print_endline "何をしますか？（番号を1つ入力）";
  print_endline "1. 記録";
  print_endline "2. 閲覧（直近60日間）";
  print_endline "3. 終わる";
  try 
    Scanf.scanf "%d" @@ function
      | 1 -> (print_endline "学習時間を記録します"; to_state3 ())
      | 2 -> (print_endline "記録を閲覧します。"; to_state9 ())
      | 3 -> print_endline "ラーニングログを終わります。";
      | _ -> (Printf.printf "1~3 の番号を入力してください。"; to_state1 ())
  with _ -> Printf.printf "1~3の番号を入力してください。"; to_state1 ()

(* 起動時 *)
let () =
  Printf.printf "今日もお疲れ様でした。";
  to_state1 ()