-module(db_persistence).
-export([save/2, read/1]).

is_a_triple({_,_,_}) ->
    true;
is_a_triple(_) ->
    false.

read(File) ->
    Result = file:consult(File),
    case Result of
        {ok, List} -> List;
        {error, Error} -> throw(Error)
    end,
    {ok, Db} = Result, 
    case lists:all(fun(X) -> is_a_triple(X) end, Db) of
        true -> Db;
        false -> throw("Invalid DB")
    end.

save(_, none) ->
    ok;
save(Db, File) ->
    Format = fun(Row) -> io_lib:format("~tp.~n", [Row]) end,
    Text = lists:map(Format, Db),
    file:write_file(File, Text).
