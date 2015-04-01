OXDOC := "C:\Program Files (x86)\oxdoc\bin\oxdoc.bat"
INC := C:\Users\Chris\Documents\OFFICE\software\Microeconometrics\niqlow\include

src := HetJobStatus. UIPhases.
srcobj = $(algsrc:.=.oxo)
srcdoc = $(src:.=.ox) Ferrall1997.ox

Ferrall1997.oxo : $(srcobj)

%.oxo : %.ox %.h
	$(OX) $(OXFLAGS) -i$(INC) -c $<
	$(COPY) $@ $(INC)
	$(ERASE) $@
	
.PHONY : document
document:
	$(OXDOC) $(srcdoc) 
#	${MAKE} -C $(DOC) tweak

