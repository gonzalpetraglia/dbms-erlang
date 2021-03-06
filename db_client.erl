-module(db_client).
-export([select/1, add/1, select_by_tuple/1, basic_select/0, filter/3, start/0, start/1]).

execute(Operation) ->
    {dbms, get(dbms_node)} ! {self(), Operation},
    receive
        {error, Error} -> throw(Error);
        Response -> Response
    after
        5000 -> throw("Can´t get response from dbms")
    end.

basic_select() ->
    [].

filter(_, any, Query) ->
    Query;
filter(Field, Value, Query) ->
    [{Field, Value} | Query].

select(Filters) ->
    execute({select, Filters}).

select_by_tuple({Name, Address, Phone}) ->
    Q = basic_select(),
    Q1 = filter(name, Name, Q),
    Q2 = filter(address, Address, Q1),
    Q3 = filter(phone, Phone, Q2),
    select(Q3).

add({Name, Address, Phone}) ->
    execute({add, {Name, Address, Phone}}).

start() ->
    ok.
start(Node) ->
    put(dbms_node, Node),
    ok.

