open Support.Error

type term =
  | TmTrue of info
  | TmFalse of info
  | TmZero of info
  | TmIf of info * term * term * term
  | TmSucc of info * term
  | TmPred of info * term
  | TmIsZero of info * term
