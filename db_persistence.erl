-module(db_persistence).
-export([save/2, read/1]).

read(File) ->
    case file:consult(File) of
    {ok, Result} -> Result;
    {error, Error} -> throw(Error)
    end.
    
save(_, none) ->
    ok;
save(Db, File) ->
    Format = fun(Row) -> io_lib:format("~tp.~n", [Row]) end,
    Text = lists:map(Format, Db),
    file:write_file(File, Text).