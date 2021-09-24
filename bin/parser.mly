%{
  open Support.Error
  open Syntax

  let pos_of_lexing_position (pos : Lexing.position) : info =
    { pos_fname = pos.pos_fname;
      pos_lnum = pos.pos_lnum;
      pos_bol = pos.pos_bol;
      pos_cnum = pos.pos_cnum }
%}

%token TRUE
%token SEMICOLON
%token EOF

%start <Syntax.term option> prog

%%

prog:
  | TRUE; SEMICOLON
    { Some (TmTrue (pos_of_lexing_position $startpos)) }
  | EOF
    { None }
