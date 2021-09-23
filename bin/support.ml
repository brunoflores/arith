module Error = struct
  type info =
      FI of string * int * int
    | UNKNOWN

  type 'a withinfo = {i: info; v: 'a}

  let dummyinfo = UNKNOWN
  let createInfo f l c = FI(f, l, c)

  let printInfo = function
      FI(f,l,c) ->
      print_string f;
      print_string ":";
      print_int l; print_string ".";
      print_int c; print_string ":"
    | UNKNOWN ->
      print_string "<Unknown file and line>: "
end
