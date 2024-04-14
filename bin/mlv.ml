module A = Automata.Simple.Make (Clock.String) (Number.Rational)
open Number.Rational

let step = num_of_int 1 // num_of_int 10

let random_strat =
  A.Strategy.random_label
    10
    (A.Strategy.random_leap
       A.I.(num_of_int 0 =-= num_of_int 1)
       (round_up step)
       (round_down step)
       random)
;;

let fast_strat =
  A.Strategy.random_label 10
  @@ A.Strategy.fast (A.I.make_include (num_of_int 0) (num_of_int 2)) (round_down step)
;;

let one = num_of_int 1
let two = num_of_int 2
let hundred = num_of_int 100
let half = num_of_int 1 // num_of_int 2

let () =
  let _ = Random.init 90237496439 in
  (* let ie = random (num_of_int 1) (num_of_int 4) in
     let rr = random (num_of_int 4) (num_of_int 50) in // 1 min*)
  let ie = num_of_int 1 in
  let rr = num_of_int 30 // num_of_int 60 in
  let inspiration_duration = one // rr // (one +/ ie) in
  let trigger_delay = num_of_int 7 // num_of_int 10 in
  let _ =
    Printf.printf
      "ie=%s;rr=%s;insp=%s\n"
      (t_to_string ie)
      (t_to_string rr)
      (t_to_string inspiration_duration)
  in
  let pcv_spec =
    Rtccsl.
      [ RTdelay ("inspiration", "expiration", (inspiration_duration, inspiration_duration))
      ; Precedence ("trigger.start", "trigger.finish")
      ; Allow ("trigger.start", "trigger.finish", [ "sensor.inhale" ])
      ; RTdelay ("expiration", "trigger.start", (trigger_delay, trigger_delay))
      ; RTdelay ("inspiration", "trigger.finish", (one // rr, one // rr))
      ; Delay ("next inspiration", "inspiration", (1, 1), None)
      ; Sample ("s", "sensor.inhale", "trigger.finish")
      ; Minus ("-", "trigger.finish", [ "s" ])
      ; Union ("cond", [ "sensor.inhale"; "-" ])
      ; FirstSampled ("next inspiration", "cond", "trigger.finish")
      ]
  in
  let machine = A.of_spec pcv_spec in
  let trace = A.skip_empty @@ A.run fast_strat machine 20 in
  let _, _, clocks = machine in
  let clocks = A.L.diff clocks (A.L.of_list [ "cond"; "-"; "s"; "next inspiration"; "first" ]) in
  let svgbob_str = A.trace_to_svgbob ~numbers:false clocks trace in
  print_endline svgbob_str
;;
