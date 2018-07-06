ERLC := erlc
ERL := erl

ERLFILES := $(wildcard *.erl)
BEAMFILES := $(ERLFILES:.erl=.beam) 

DBFILE =
DBNAME = 'dbms'
CLIENTID =

all: $(BEAMFILES)

$(BEAMFILES): $(ERLFILES)
	$(ERLC) $(ERLFILES)

run-server: all
	$(ERL) -sname $(DBNAME) -run db_server start $(DBFILE)

run-client: all
	$(ERL) -sname $(addsuffix $(CLIENTID), client) -run db_client start

clean:
	rm -f *.beam
	rm -f erl_crash.dump
	rm -f *.txt
