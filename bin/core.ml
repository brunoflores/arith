open Syntax

let rec isnumericval t = match t with
    TmZero (_) -> true
  | TmSucc (_, t1) -> isnumericval t1
  | _ -> false

let eval = ()
