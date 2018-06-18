-module(db_operation).
-export([add/2, select/2]).

add(Db, NewRow) ->
	case member(Db, NewRow) of
		false -> [NewRow | Db]
		true -> throw("Duplicated entry")
	end.

filter_db(Db, {address, A}) ->
	filter(Db, fun({_, Address, _}) -> A == Address end));
filter_db(Db, {name, N}) ->
	filter(Db, fun({_, Name, _}) -> N == Name end));
filter_db(Db, {phone, Phone}) ->
	filter(Db, fun({_, _, Phone}) -> P == Phone end));
filter_db(_, F) ->
	throw("Unvalid field").

select(Db, []) ->
	Db;
select(Db, [HeadFilter | TailFilters]) ->
	select(filter_db(Db, HeadFilter), TailFilters).
