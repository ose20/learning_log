TARGET = llog
STRCMA = str.cma
OBJS = mySupport.cmo manageLog.ml main.cmo

all : $(DEPEND) $(TARGET)

llog : $(OBJS)
			ocamlc -o $(TARGET) $(STRCMA) $(OBJS)

%.cmo : %.ml
			ocamlc -c $<

clean::
			-rm -rf *.cmi *.cmo $(TARGET) *.cmx *~

depend:: $(DEPEND)
			ocamldep *.mli *.ml > .depend

-include .depend