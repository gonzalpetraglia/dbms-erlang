-module(db_operation).
-export([add/2, select/2]).

add([{Name, Address, Phone} | _], {Name, Address, Phone}) ->
	throw("Duplicated entry");
add([], {Name, Address, Phone}) ->
	[{Name, Address, Phone}];
add([H | T], Row) ->
	[H | add(T, Row)].

filter_db([], _) ->
	[];
filter_db([{Name, Address, Phone} | T], {address, Address}) ->
	[{Name, Address, Phone} | filter_db(T, {address, Address})];
filter_db([{Name, Address, Phone} | T], {name, Name}) ->
	[{Name, Address, Phone} | filter_db(T, {name, Name})];
filter_db([{Name, Address, Phone} | T], {phone, Phone}) ->
	[{Name, Address, Phone} | filter_db(T, {phone, Phone})];
filter_db([_ | T], F) ->
	filter_db(T, F).
	
select(Db, []) ->
	Db;
select(Db, [HeadFilter | TailFilters]) ->
	select(filter_db(Db, HeadFilter), TailFilters).
