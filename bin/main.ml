module E = MenhirLib.ErrorReports
module L = MenhirLib.LexerUtil
module A = ArithLib
module Syntax = A.Syntax
module Parser = A.Parser
module Lexer = A.Lexer
module Arith = A.Arith
module I = Parser.MenhirInterpreter

let print_position outx (lexbuf : Lexing.lexbuf) =
  let pos = lexbuf.lex_curr_p in
  let fname = pos.pos_fname in
  let line = pos.pos_lnum in
  let col = pos.pos_cnum - pos.pos_bol + 1 in
  Format.fprintf outx "%s:%d:%d" fname line col

let show text positions =
  E.extract text positions |> E.sanitize |> E.compress |> E.shorten 20

let rec int_of_term = function
  | Syntax.TmSucc (_, v) -> 1 + int_of_term v
  | Syntax.TmPred (_, v) -> 1 - int_of_term v
  | _ -> 0

let string_of_term (t : Syntax.term) =
  match t with
  | Syntax.TmTrue _ -> "true"
  | Syntax.TmFalse _ -> "false"
  | Syntax.TmZero _ -> "0"
  | Syntax.TmSucc _ | Syntax.TmPred _ -> string_of_int (int_of_term t)
  | _ -> failwith "cannot print"

let succeed (v : Syntax.term option) =
  match v with
  | Some v -> Format.printf "%s\n" (string_of_term (Arith.eval v))
  | None -> ()

let fail text buffer _ =
  let location = L.range (E.last buffer) in
  let indication =
    Format.sprintf "Syntax error %s.\n" (E.show (show text) buffer)
  in
  Format.eprintf "%s%s%!" location indication;
  exit 1

let parse lexbuf text =
  let supplier = I.lexer_lexbuf_to_supplier Lexer.read lexbuf in
  let buffer, supplier = E.wrap_supplier supplier in
  let checkpoint = Parser.Incremental.prog lexbuf.lex_curr_p in
  try I.loop_handle succeed (fail text buffer) supplier checkpoint
  with Lexer.Error msg ->
    Format.eprintf "%a: %s\n" print_position lexbuf msg;
    ()

let get_contents s =
  let filename, content =
    match s with
    | None | Some "-" -> ("-", In_channel.input_all In_channel.stdin)
    | Some filename -> (filename, Stdio.In_channel.read_all filename)
  in
  (L.init filename (content |> Lexing.from_string), content)

let loop filename =
  let lexbuf, content = get_contents filename in
  parse lexbuf content

let command =
  Command.basic ~summary:"Type-check a program"
    Command.Let_syntax.(
      let%map_open filename =
        anon (maybe ("filename" %: Filename_unix.arg_type))
      in
      fun () -> loop filename)

let () = Command_unix.run command
