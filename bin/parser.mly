%{
  open Support.Error
  open Syntax

  let pos_of_lexing_position (pos : Lexing.position) : info =
    { pos_fname = pos.pos_fname;
      pos_lnum = pos.pos_lnum;
      pos_bol = pos.pos_bol;
      pos_cnum = pos.pos_cnum }
%}

%token ZERO
%token TRUE
%token FALSE
%token IF
%token THEN
%token ELSE
%token SEMICOLON
%token EOF

%start <Syntax.term option> prog

%%

prog:
  | e = expr; SEMICOLON
    { Some e }
  | IF; e1 = expr; THEN; e2 = expr; ELSE; e3 = expr; SEMICOLON
    { Some (TmIf ((pos_of_lexing_position $startpos), e1, e2, e3)) }
  | EOF
    { None }

expr:
  | ZERO
    { TmZero (pos_of_lexing_position $startpos) }
  | TRUE
    { TmTrue (pos_of_lexing_position $startpos) }
  | FALSE
    { TmFalse (pos_of_lexing_position $startpos) }
