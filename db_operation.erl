-module(db_operation).
-export([add/2, select/2]).

add(Db, {N, A, P}) ->
    case lists:member({N, A, P}, Db) of
        false -> [{N, A, P} | Db];
        true -> throw("Duplicated entry")
    end.

filter_db(Db, {address, A}) ->
    lists:filter(fun({_, Address, _}) -> A == Address end, Db);
filter_db(Db, {name, N}) ->
    lists:filter(fun({Name, _, _}) -> N == Name end, Db);
filter_db(Db, {phone, P}) ->
    lists:filter(fun({_, _, Phone}) -> P == Phone end, Db).

select(Db, []) ->
    Db;
select(Db, [HeadFilter | TailFilters]) ->
    select(filter_db(Db, HeadFilter), TailFilters).
