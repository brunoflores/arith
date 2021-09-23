open Syntax

let rec isnumericval t = match t with
    TmZero (_) -> true
  | TmSucc (_, t1) -> isnumericval t1
  | _ -> false

let isval t = match t with
    TmTrue (_) -> true
  | TmFalse (_) -> true
  | t when isnumericval t -> true
  | _ -> false

let eval = ()
