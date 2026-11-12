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

.PHONY: application cv feedback rebuild themes view watch clean
