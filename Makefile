ERLC := erlc
ERL := erl

ERLFILES := $(wildcard *.erl)
BEAMFILES := $(ERLFILES:.erl=.beam) 

DBFILE =
DBNODE =
CLIENTID =

all: $(BEAMFILES)

$(BEAMFILES): $(ERLFILES)
	$(ERLC) $(ERLFILES)

run-server: all
	$(ERL) -sname dbms -run db_server start $(DBFILE)

run-client: all
	$(ERL) -sname $(addsuffix $(CLIENTID), client) -run db_client start $(DBNODE)

clean:
	rm -f *.beam
	rm -f erl_crash.dump
	rm -f *.txt
