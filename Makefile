TARGET = llog
STRCMA = str.cma
INCLUDE = -I ~/my_project/personal_dev/learning_log
OBJS = mySupport.cmo manageLog.cmo main.cmo

all : $(DEPEND) $(TARGET)

llog : $(OBJS)
			ocamlc $(INCLUDE) -o $(TARGET) $(STRCMA) $(OBJS)

%.cmi : %.mli
			ocamlc -c $(INCLUDE) $<

%.cmo : %.ml
			ocamlc -c $(INCLUDE) $<

clean::
			-rm -rf *.cmi *.cmo $(TARGET) *.cmx *~

depend:: $(DEPEND)
			ocamldep *.mli *.ml > .depend

-include .depend