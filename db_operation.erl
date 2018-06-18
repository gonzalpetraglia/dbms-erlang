-module(db_operation).
-export([add/2, select/2]).

add(Db, NewRow) ->
	case NewRow of
		{N, A, P} -> ok;
		_ -> throw("Not a triple")
	case member(Db, NewRow) of
		false -> [NewRow | Db];
		true -> throw("Duplicated entry")
	end.

filter_db(Db, {address, A}) ->
	filter(Db, fun({_, Address, _}) -> A == Address end));
filter_db(Db, {name, N}) ->
	filter(Db, fun({Name, _, _}) -> N == Name end));
filter_db(Db, {phone, Phone}) ->
	filter(Db, fun({_, _, Phone}) -> P == Phone end));
filter_db(_, F) ->
	throw("Invalid field").

select(Db, []) ->
	Db;
select(Db, [HeadFilter | TailFilters]) ->
	select(filter_db(Db, HeadFilter), TailFilters).
