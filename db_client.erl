-module(db_client).
-export([get/1, add/1, help/1]).
% http://erlang.org/documentation/doc-5.3/doc/getting_started/getting_started.html

execute(Operation) ->
  (dbms, Process) ! {node(), self(), Operation},
  receive
    {ok, Result} -> Result;
    {error, Error} -> error Error
  after 5000
    error "Cant get response from dbms"
  end.

get(Filters) ->
  execute({get, Filters}).

add(Row) ->
  execute({add, Row}).


  
