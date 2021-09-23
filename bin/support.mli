module Error : sig

  (* An element of the type info represents a "file position": a
     file name, line number, and character position within the line.
     Used for printing error messages. *)
  type info
  val dummyinfo : info


  (* Create file position info: filename lineno column *)
  val createInfo : string -> int -> int -> info
  val printInfo : info -> unit

  (* A convenient datatype for a "value with file info."  Used in
     the lexer and parser. *)
  type 'a withinfo = {i: info; v: 'a}

end
