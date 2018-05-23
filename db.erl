-module(db).
-export([new/0,destroy/1,write/3,delete/2,read/2,match/2]).


new() -> [].

destroy(_) -> ok.

delete(_, []) -> [];
delete(Key, [{Key,_} | T]) -> T;
delete(Key, [H | T] )-> [H | delete(Key, T)].

write(Key, Element, Db) -> [{Key, Element} | delete(Key, Db)].

read(Key, [{Key, Element} | _]) -> Element;
read(Key, [_ | T ]) -> read(Key, T).

match(_, []) -> [];
match(Element, [{Key, Element} | T]) -> [Key | match(Element, T)];
match(Element, [_ | T]) -> match(Element, T).
