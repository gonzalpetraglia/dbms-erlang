-module(db_server).
-export([start/0, start/1, stop/0]).




serve(DB, OutFile, FatherPID) ->
  receive
    {SenderNode, SenderPID, {add, Row}} -> 
      {Response, NewDB} = add(DB, Row),
      {Sender_Node, SenderPID} ! Response,
      serve(NewDB, OutFile, FatherPID);
    {SenderNode, SenderPID, {get, Filters}} ->
      Response = get(DB, Filters),
      {SenderNode, SenderPID} ! Result,
      serve(NewDB, OutFile, FatherPID)
    {EXIT, FatherPID, Reason} ->
      save(DB, OutFile)
  end.
  
stop() ->
  case wheris(dbms) of 
    undefined -> throw("DBMS not started");
    Pid -> exit(whereis(dbms), normal)
  end.
  
init(OutFile, FatherPID) ->
  process_flag(trap_exit, true),
  serve([], OutFile, FatherPID).


start(OutFile) -> 
  register(dbms, spawn(fun() -> init(OutFile, self()) end)).
  
start() ->
  start("users.db").
  

