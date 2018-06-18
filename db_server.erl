-module(db_server).
-export([start/0, start/2, start/1, stop/0]).
-import(db_persistence, [read/1, save/2]).
-import(db_operation, [select/2, add/2]).

serve_add(DB, NewRow) ->
  try add(DB, NewRow) of
    NewDB -> {ok, NewDB}
  catch
    throw:Reason -> {{error, Reason}, DB}
  end.

serve_select(DB, Filters) ->
  try select(DB, Filters) of
    Result -> Result
  catch
    throw:Reason -> {error, Reason}
  end.

serve(DB, OutFile) ->
  receive
    {SenderPID, {add, Row}} -> 
      {Response, NewDB} = serve_add(DB, Row),
      SenderPID ! Response,
      serve(NewDB, OutFile);
    {SenderPID, {get, Filters}} ->
      Response = serve_select(DB, Filters),
      SenderPID ! Response,
      serve(DB, OutFile);
    {'EXIT', _, _} ->
      ok = save(DB, OutFile)
  end.
  
stop() ->
  case whereis(dbms) of 
    undefined -> throw("DBMS not started");
    Pid -> exit(Pid, normal)
  end.
  
init(InFile, OutFile) ->
  process_flag(trap_exit, true),
  serve(db_persistence:read(InFile), OutFile).

init(OutFile) ->
  process_flag(trap_exit, true),
  serve([], OutFile).

start(InFile, OutFile) ->
  register(dbms, spawn(fun() -> init(InFile, OutFile) end)).
  

start(OutFile) -> 
  register(dbms, spawn(fun() -> init(OutFile) end)).
  
start() ->
  start(none).
  

