-module(db_operation).
-export([add/2, get/2]).


add([], {Name, Address, Phone}) ->
	[{Name, Address, Phone}];
add([{Name, Address, Phone} | _], {Name, Address, Phone}) ->
	{error, "Duplicated entry"};
add([H | T], Row) ->
	[H | add(T, Row)].

apply_single_filter([], _) ->
	[];
apply_single_filter([{Name, Address, Phone} | T], {address, Address}) ->
	[{Name, Address, Phone} | apply_single_filter(T, {address, Address})];
apply_single_filter([{Name, Address, Phone} | T], {name, Name}) ->
		[{Name, Address, Phone} | apply_single_filter(T, {name, Name})];
apply_single_filter([{Name, Address, Phone} | T], {phone, Phone}) ->
		[{Name, Address, Phone} | apply_single_filter(T, {phone, Phone})];
apply_single_filter([_ | T], F) ->
		apply_single_filter(T, F).
	
apply_filters(Db, []) ->
	Db;
apply_filters(Db, [H | T]) ->
	apply_filters(apply_single_filter(Db, H), T).

get(Db, Filters) ->
	apply_filters(Db, Filters).