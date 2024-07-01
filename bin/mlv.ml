open Mrtccsl
open Prelude
open Number.Rational
module A = Automata.Simple.Make (Clock.String) (Number.Rational)

let step = of_int 1 / of_int 10

let random_strat =
  A.Strategy.random_label
    10
    (A.Strategy.random_leap
       A.I.(of_int 0 =-= of_int 1)
       (round_up step)
       (round_down step)
       random)
;;

let fast_strat =
  A.Strategy.random_label 10
  @@ A.Strategy.fast (A.I.make_include (of_int 0) (of_int 2)) (round_down step)
;;

let nom_denom (n, d) = of_int n / of_int d

let () =
  let _ = Random.init 365216367 in
  (* let ie = random (of_int 1) (of_int 4) in
     let rr = random (of_int 4) (of_int 50) in // 1 min*)
  let ie = of_int 1 in
  let rr = nom_denom (30, 60) in
  let inspiration_duration = one / rr / (one + ie) in
  let trigger_delay = nom_denom (7, 10) in
  let _ =
    Printf.printf
      "ie=%s;rr=%s;insp=%s\n"
      (t_to_string ie)
      (t_to_string rr)
      (t_to_string inspiration_duration)
  in
  let pcv_spec =
    Rtccsl.
      [ RTdelay
          { arg = "inspiration"
          ; out = "expiration"
          ; delay = TimeConst inspiration_duration, TimeConst inspiration_duration
          }
      ; Precedence { cause = "trigger.start"; effect = "trigger.finish" }
      ; Allow
          { from = "trigger.start"; until = "trigger.finish"; args = [ "sensor.inhale" ] }
      ; RTdelay
          { arg = "expiration"
          ; out = "trigger.start"
          ; delay = TimeConst trigger_delay, TimeConst trigger_delay
          }
      ; RTdelay
          { arg = "inspiration"
          ; out = "trigger.finish"
          ; delay = TimeConst (one / rr), TimeConst (one / rr)
          }
      ; Delay
          { out = "next inspiration"
          ; arg = "inspiration"
          ; delay = IntConst 1, IntConst 1
          ; base = None
          }
      ; Sample { out = "s"; arg = "sensor.inhale"; base = "trigger.finish" }
      ; Minus { out = "-"; arg = "trigger.finish"; except = [ "s" ] }
      ; Union { out = "cond"; args = [ "sensor.inhale"; "-" ] }
      ; FirstSampled { out = "next inspiration"; arg = "cond"; base = "trigger.finish" }
      ]
  in
  let machine = A.of_spec pcv_spec in
  let trace = A.skip_empty @@ A.gen_trace fast_strat machine 20 in
  let _, _, clocks = machine in
  let clocks =
    A.L.diff clocks (A.L.of_list [ "cond"; "-"; "s"; "next inspiration"; "first" ])
  in
  let svgbob_str = A.trace_to_svgbob ~numbers:false (A.L.elements clocks) trace in
  print_endline svgbob_str
;;
