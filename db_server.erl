-module(db_server).
-export([start/0, stop/1, start/1, stop/0]).
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

serve(DB) ->
  receive
    {SenderPID, {add, Row}} ->
      {Response, NewDB} = serve_add(DB, Row),
      SenderPID ! Response,
      serve(NewDB);
    {SenderPID, {get, Filters}} ->
      Response = serve_select(DB, Filters),
      SenderPID ! Response,
      serve(DB);
    {'EXIT', _, {stop, OutFile}} ->
      ok = save(DB, OutFile)
  end.

stop(OutFile) ->
  case whereis(dbms) of
    undefined -> throw("DBMS not started");
    Pid -> exit(Pid, {stop, OutFile})
  end.

stop() ->
  stop(none).

init(InitialDB) ->
  process_flag(trap_exit, true),
  serve(InitialDB).

start(none) ->
  register(dbms, spawn(fun() -> init([]) end));
start(InFile) ->
  InitialDB = read(InFile),
  register(dbms, spawn(fun() -> init(InitialDB) end)).

start() ->
  start(none).
