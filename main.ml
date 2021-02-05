open MySupport
open ManageLog
let fileptr = ref LogMap.empty

let rec to_state1 () = (* 状態1 *)
  print_endline "何をしますか？（番号を1つ入力）";
  print_endline "1. 記録";
  print_endline "2. 閲覧（直近60日間）";
  print_endline "3. 終わる";
  prompt ();
  let s = read_line () in
  match s with
  | "1" -> (print_endline "学習時間を記録します"; to_state2 ())
  | "2" -> (print_endline "記録を閲覧します。"; to_state6 ())
  | "3" -> print_endline "ラーニングログを終わります。";
  | _ -> (print_endline "1~3 の番号を入力してください。"; to_state1 ())
and to_state2 () = (* 状態2 *)
  print_endline "記録する日付をyyyymmdd形式で入力してください（中止する場合は q）";
  print_endline "例：2048年6月1日は 20480601";
  prompt ();
  let s = read_line () in
  if s = "q" then to_state1 ()
  else
    begin
      try 
        let (year, month, day) = ymd_of_string s in
        to_state3 year month day ()
      with _ -> (print_endline "形式が違います。やり直してください。"; to_state2 ())
    end
and to_state3 year month day () = (* 状態3 *)
  print_endline "データを参照しています。";
  if mem year month day !fileptr (* (year, month, day) にするとエラーになる理由を考える*)
  then to_state4 year month day ()
  else to_state5 year month day ()
and to_state4 year month day () = (* 状態4 *)
  print_endline "指定された日付の記録が既に存在しますが、上書きしますか？y/n";
  prompt ();
  let s = read_line () in
  if s = "y" || s = "Y" then to_state5 year month day ()
  else if s = "n" || s = "N" then to_state1 ()
  else (print_endline "y か n を押してください。"; to_state4 year month day ())
and to_state5 year month day () = (* 状態5 *)
  print_endline "学習時間を 0.5 時間単位で入力してください";
  print_endline "例：1時間半 → 1.5、3時間 → 3.0 or 3. or 3";
  print_char '>'; flush stdout;
  let s = read_line () in
  try 
    let time = time_of_string s in
    print_endline "データを記録しています。";
    fileptr := add year month day time !fileptr;
    print_endline "データを記録しました。";
    to_state6 ()
  with _ -> (print_endline "形式が違います。やり直してください"; to_state5 year month day ())
and to_state6 () = (* 状態6 *)
  show_log !fileptr;
  to_state1 ()

(* 起動時 *)
let () =
  print_endline "--- Learning Log ---";
  print_endline "今日もお疲れ様でした。データの更新を行います。少々お待ちください。";
  fileptr := loginit ();
  to_state1 ();