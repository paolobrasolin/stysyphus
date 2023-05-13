CLS = article elsarticle

pdf: $(addprefix test/,$(addsuffix .pdf,$(CLS)))

tex: $(addprefix test/,$(addsuffix .tex,$(CLS)))

$(addprefix test/,$(addsuffix .pdf,$(CLS))): test/%.pdf: test/%.tex
	@latexmk -output-directory=test/ -pdf $<

$(addprefix test/,$(addsuffix .tex,$(CLS))): test/%.tex: main.tex
	@mkdir -p $(@D)
	@sed 's/target = article/target = $*/g' $< > $@

clean:
	@cd test/ && latexmk -c

clobber:
	@cd test/ && latexmk -C
