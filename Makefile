# LaTeX-Bewerbungen
#
# Ablauf:
#   - templates/ ist die Arbeitskopie (immer die aktuelle Bewerbung).
#   - In templates/application.tex \application auf den Ordnernamen unter
#     applications/ setzen.
#   - `make application` baut das PDF und legt Briefe + PDF im Ordner ab,
#     sodass jeder Ordner festhält, was verschickt wurde.

TEMPLATE_DIR = templates
BUILD_DIR    = build
THEMES       = kompakt sidebar akzent rueckgrat

# Aktuelle Bewerbung aus templates/application.tex lesen
APPLICATION = $(shell grep '\\newcommand{\\application}' $(TEMPLATE_DIR)/application.tex | sed 's/.*{\\application}{\([^}]*\)}.*/\1/')
APP_DIR     = applications/$(APPLICATION)

XELATEX = xelatex -interaction=nonstopmode -halt-on-error -output-directory=$(BUILD_DIR)

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# Dossier bauen und in den Bewerbungsordner ablegen
application: $(BUILD_DIR)
	@echo "=== $(APPLICATION) ==="
	@mkdir -p $(APP_DIR)
	$(XELATEX) -jobname=application-$(APPLICATION) $(TEMPLATE_DIR)/application.tex
	$(XELATEX) -jobname=application-$(APPLICATION) $(TEMPLATE_DIR)/application.tex
	cp $(BUILD_DIR)/application-$(APPLICATION).pdf $(APP_DIR)/application.pdf
	cp $(TEMPLATE_DIR)/cover-letter.tex $(APP_DIR)/cover-letter.tex
	cp $(TEMPLATE_DIR)/motivation.tex $(APP_DIR)/motivation.tex

# Nur der Lebenslauf, ohne Briefe und ohne Ablage
cv: $(BUILD_DIR)
	$(XELATEX) -jobname=cv "\def\cvonly{}\input{$(TEMPLATE_DIR)/application.tex}"
	$(XELATEX) -jobname=cv "\def\cvonly{}\input{$(TEMPLATE_DIR)/application.tex}"
	@echo "  -> $(BUILD_DIR)/cv.pdf"

# Dossier als einzelne Dateien für Bewerbungsportale, abgelegt im Bewerbungsordner.
#   make dossier APP=2026-01-muster-ag
#        de: Bewerbung_ / Anschreiben_ / Motivationsschreiben_ / Lebenslauf_ / Zeugnisse_<Name>.pdf
#        en: Application_ / Cover_Letter_ / Motivation_Letter_ / CV_ / Certificates_<Name>.pdf
# Die Sprache folgt der meta.tex (\cvlanguage{british} = englische Dateinamen). Die Briefe
# kommen aus dem Bewerbungsordner. Bewerbung_ enthält alles in der Reihenfolge Anschreiben,
# Motivationsschreiben, Lebenslauf, Zeugnisse.
#   Zeugnisse: alle PDF unter beilagen/, in alphabetischer Reihenfolge (Ordner fehlt = keine)
#   \newcommand{\nomotivation}{} in der meta.tex   kein Motivationsschreiben
#   \newcommand{\lettersinone}{}                   beide Briefe in einer Datei
#   \newcommand{\noletters}{}                      gar keine Briefe
#   make dossier APP=... PERSON=Erika_Beispiel     Name in den Dateinamen
PERSON           ?= Max_Muster
DOSSIER_LANG     ?= $(if $(shell grep -ls '^\\newcommand{\\cvlanguage}{british}' applications/$(APP)/meta.tex),en,de)
DOSSIER_NAMES_de  = Bewerbung Anschreiben Lebenslauf Zeugnisse Motivationsschreiben Anschreiben_und_Motivationsschreiben
DOSSIER_NAMES_en  = Application Cover_Letter CV Certificates Motivation_Letter Cover_and_Motivation_Letter
DOSSIER_NAME      = $(word $(1),$(DOSSIER_NAMES_$(DOSSIER_LANG)))_$(PERSON).pdf
DOSSIER_ARGS      = "$(1)\def\lettersfromapp{}\def\appoverride{$(APP)}\input{$(TEMPLATE_DIR)/application.tex}"
DOSSIER_NOLETTERS = $(shell grep -ls '^\\newcommand{\\noletters}' applications/$(APP)/meta.tex)
DOSSIER_MOTIV     = $(if $(DOSSIER_NOLETTERS),,$(if $(wildcard applications/$(APP)/motivation.tex),$(if $(shell grep -ls '^\\newcommand{\\nomotivation}' applications/$(APP)/meta.tex),,yes),))
DOSSIER_ONEFILE   = $(shell grep -ls '^\\newcommand{\\lettersinone}' applications/$(APP)/meta.tex)
DOSSIER_BEILAGEN  = $(sort $(wildcard beilagen/*.pdf))

dossier: $(BUILD_DIR)
	@test -n "$(APP)" || { echo "Aufruf: make dossier APP=<ordner unter applications/>"; exit 1; }
	@test -d applications/$(APP) || { echo "applications/$(APP) existiert nicht"; exit 1; }
	@echo "=== Dossier $(APP) ($(DOSSIER_LANG)$(if $(DOSSIER_NOLETTERS), ohne Briefe,)) ==="
ifeq ($(DOSSIER_NOLETTERS),)
	$(XELATEX) -jobname=cover-$(APP) $(call DOSSIER_ARGS,\def\letteronly{}\def\coveronly{}) > /dev/null
	$(XELATEX) -jobname=cover-$(APP) $(call DOSSIER_ARGS,\def\letteronly{}\def\coveronly{}) > /dev/null
	cp $(BUILD_DIR)/cover-$(APP).pdf applications/$(APP)/$(call DOSSIER_NAME,2)
ifneq ($(DOSSIER_MOTIV),)
	$(XELATEX) -jobname=motivation-$(APP) $(call DOSSIER_ARGS,\def\letteronly{}\def\motivationonly{}) > /dev/null
	$(XELATEX) -jobname=motivation-$(APP) $(call DOSSIER_ARGS,\def\letteronly{}\def\motivationonly{}) > /dev/null
	cp $(BUILD_DIR)/motivation-$(APP).pdf applications/$(APP)/$(call DOSSIER_NAME,5)
endif
ifneq ($(DOSSIER_ONEFILE),)
	pdfunite $(BUILD_DIR)/cover-$(APP).pdf $(if $(DOSSIER_MOTIV),$(BUILD_DIR)/motivation-$(APP).pdf) \
		applications/$(APP)/$(call DOSSIER_NAME,6)
	rm -f applications/$(APP)/$(call DOSSIER_NAME,2) applications/$(APP)/$(call DOSSIER_NAME,5)
endif
endif
	$(XELATEX) -jobname=cvpart-$(APP) $(call DOSSIER_ARGS,\def\cvonly{}) > /dev/null
	$(XELATEX) -jobname=cvpart-$(APP) $(call DOSSIER_ARGS,\def\cvonly{}) > /dev/null
	cp $(BUILD_DIR)/cvpart-$(APP).pdf applications/$(APP)/$(call DOSSIER_NAME,3)
ifneq ($(DOSSIER_BEILAGEN),)
	pdfunite $(DOSSIER_BEILAGEN) $(BUILD_DIR)/beilagen.pdf
	cp $(BUILD_DIR)/beilagen.pdf applications/$(APP)/$(call DOSSIER_NAME,4)
endif
	pdfunite $(if $(DOSSIER_NOLETTERS),,$(BUILD_DIR)/cover-$(APP).pdf) \
		$(if $(DOSSIER_MOTIV),$(BUILD_DIR)/motivation-$(APP).pdf) \
		$(BUILD_DIR)/cvpart-$(APP).pdf $(if $(DOSSIER_BEILAGEN),$(BUILD_DIR)/beilagen.pdf) \
		applications/$(APP)/$(call DOSSIER_NAME,1)
	@ls applications/$(APP)/*_$(PERSON).pdf | sed 's/^/  -> /'

# Master-Lebenslauf: alle Bausteine der Inhaltsdatei, zum Durchsehen.
#   make cv-master                 -> build/cv-master.pdf, build/cv-master-en.pdf
#   make cv-master CVTHEME=sidebar    anderes Layout
CVTHEME ?= kompakt
cv-master: $(BUILD_DIR)
	$(XELATEX) -jobname=cv-master "\def\cvtheme{$(CVTHEME)}\input{$(TEMPLATE_DIR)/cv-master.tex}" > /dev/null
	$(XELATEX) -jobname=cv-master "\def\cvtheme{$(CVTHEME)}\input{$(TEMPLATE_DIR)/cv-master.tex}" > /dev/null
	$(XELATEX) -jobname=cv-master-en "\def\cvtheme{$(CVTHEME)}\def\cvmasteren{}\input{$(TEMPLATE_DIR)/cv-master.tex}" > /dev/null
	$(XELATEX) -jobname=cv-master-en "\def\cvtheme{$(CVTHEME)}\def\cvmasteren{}\input{$(TEMPLATE_DIR)/cv-master.tex}" > /dev/null
	@echo "  -> $(BUILD_DIR)/cv-master.pdf, $(BUILD_DIR)/cv-master-en.pdf"

# Beispiel-PDFs im Ordner vorschau/ neu bauen: das Dossier in jedem Layout.
vorschau: themes
	@for t in $(THEMES); do \
		cp $(BUILD_DIR)/theme-$$t.pdf vorschau/$$t.pdf; \
		echo "  -> vorschau/$$t.pdf"; \
	done

# Feedback nach dem Gespräch bauen und ablegen
feedback: $(BUILD_DIR)
	@echo "=== Feedback $(APPLICATION) ==="
	@mkdir -p $(APP_DIR)
	$(XELATEX) -jobname=feedback-$(APPLICATION) "\def\appoverride{$(APPLICATION)}\input{$(TEMPLATE_DIR)/feedback.tex}"
	$(XELATEX) -jobname=feedback-$(APPLICATION) "\def\appoverride{$(APPLICATION)}\input{$(TEMPLATE_DIR)/feedback.tex}"
	cp $(BUILD_DIR)/feedback-$(APPLICATION).pdf $(APP_DIR)/feedback.pdf
	cp $(TEMPLATE_DIR)/feedback.tex $(APP_DIR)/feedback.tex

# Archivierte Bewerbung mit ihren eigenen Briefen neu bauen, ohne templates/
# anzufassen. Ersetzt nur die PDF. Der Lebenslauf kommt aus dem aktuellen
# cv-content.tex -- den Stand beim Versand liefert git.
#   make rebuild APP=2026-01-muster-ag
rebuild: $(BUILD_DIR)
	@test -n "$(APP)" || { echo "Aufruf: make rebuild APP=<ordner unter applications/>"; exit 1; }
	@test -d applications/$(APP) || { echo "applications/$(APP) existiert nicht"; exit 1; }
	$(XELATEX) -jobname=application-$(APP) "\def\lettersfromapp{}\def\appoverride{$(APP)}\input{$(TEMPLATE_DIR)/application.tex}"
	$(XELATEX) -jobname=application-$(APP) "\def\lettersfromapp{}\def\appoverride{$(APP)}\input{$(TEMPLATE_DIR)/application.tex}"
	cp $(BUILD_DIR)/application-$(APP).pdf applications/$(APP)/application.pdf

# Das aktuelle Dossier in jedem Theme -> build/theme-<name>.pdf
themes: $(BUILD_DIR)
	@for t in $(THEMES); do \
		echo "=== Theme $$t ==="; \
		$(XELATEX) -jobname=theme-$$t "\def\cvtheme{$$t}\input{$(TEMPLATE_DIR)/application.tex}" > /dev/null && \
		$(XELATEX) -jobname=theme-$$t "\def\cvtheme{$$t}\input{$(TEMPLATE_DIR)/application.tex}" > /dev/null || exit 1; \
		echo "  -> $(BUILD_DIR)/theme-$$t.pdf"; \
	done

# Ein Theme bauen und öffnen, z.B. make theme-sidebar
theme-%: $(BUILD_DIR)
	$(XELATEX) -jobname=theme-$* "\def\cvtheme{$*}\input{$(TEMPLATE_DIR)/application.tex}"
	$(XELATEX) -jobname=theme-$* "\def\cvtheme{$*}\input{$(TEMPLATE_DIR)/application.tex}"
	xdg-open $(BUILD_DIR)/theme-$*.pdf

view: application
	xdg-open $(APP_DIR)/application.pdf

watch:
	@echo "Beobachte Änderungen... (Ctrl+C beendet)"
	@while true; do \
		inotifywait -e modify $(TEMPLATE_DIR)/*.tex $(TEMPLATE_DIR)/themes/*.tex applications/*/*.tex 2>/dev/null && make application; \
	done

clean:
	rm -rf $(BUILD_DIR)

.PHONY: application cv cv-master dossier feedback rebuild themes vorschau view watch clean
