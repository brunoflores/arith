{
  open Parser

  exception Error of string
}

let zeroes = '0'+
let white = [' ' '\t']+

rule read = parse
  | white
    { read lexbuf }
  | zeroes
    { ZERO }
  | "if"
    { IF }
  | "then"
    { THEN }
  | "else"
    { ELSE }
  | "true"
    { TRUE }
  | "false"
    { FALSE }
  | ';'
    { SEMICOLON }
  | eof
    { EOF }
  | _
    { raise (Error (Printf.sprintf "At offset %d: unexpected character.\n" (Lexing.lexeme_start lexbuf))) }
