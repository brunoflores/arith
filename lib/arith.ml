open Syntax

exception NoRuleApplies

let rec isnumericval t =
  match t with
  | TmZero _ -> true
  | TmSucc (_, t1) -> isnumericval t1
  | _ -> false

(* let isval t = match t with
 *     TmTrue (_) -> true
 *   | TmFalse (_) -> true
 *   | t when isnumericval t -> true
 *   | _ -> false *)

let rec eval1 t =
  match t with
  | TmIf (_, TmTrue _, t2, _) -> t2
  | TmIf (_, TmFalse _, _, t3) -> t3
  | TmIf (i, t1, t2, t3) ->
      let t1' = eval1 t1 in
      TmIf (i, t1', t2, t3)
  | TmSucc (i, t1) ->
      let t1' = eval1 t1 in
      TmSucc (i, t1')
  | TmPred (_, TmZero i) -> TmZero i
  | TmPred (_, TmSucc (_, nv1)) when isnumericval nv1 -> nv1
  | TmPred (i, t1) ->
      let t1' = eval1 t1 in
      TmPred (i, t1')
  | TmIsZero (_, TmZero i) -> TmTrue i
  | TmIsZero (_, TmSucc (i, nv1)) when isnumericval nv1 -> TmFalse i
  | TmIsZero (i, t1) ->
      let t1' = eval1 t1 in
      TmIsZero (i, t1')
  | _ -> raise NoRuleApplies

let rec eval t =
  try
    let t' = eval1 t in
    eval t'
  with NoRuleApplies -> t
