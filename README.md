# LaTeX-Bewerbungen

Ein LaTeX-Projekt, das Lebenslauf, Anschreiben und Motivationsschreiben als **ein PDF-Dossier** baut, dazu optional ein Feedback-Dokument nach dem Gespräch. Drei Layouts stehen zur Wahl, der Inhalt steht nur einmal da.

Alle Inhalte sind Blindtext der fiktiven Person „Max Muster“. Sie werden durch die eigenen Angaben ersetzt.

## Layouts

| Theme | Gestaltung |
|---|---|
| `kompakt` | einspaltig, Datumsleiste links, feine Linien, Kontaktangaben zweispaltig neben dem Foto |
| `sidebar` | zweispaltig, getönte Seitenleiste mit Kontakt, Profil und Sprachen, Schlagwort-Chips |
| `akzent` | dunkles Kopfband mit Foto, Zeitachse |

Fertig gebaute Beispiele liegen in [`vorschau/`](vorschau/) — dasselbe Blindtext-Dossier in jedem Layout. Mit `make themes` entsteht das eigene Dossier in allen drei Layouts unter `build/theme-*.pdf` zum Vergleichen.

## Struktur

```
├── Makefile
├── templates/                     # Arbeitskopie — immer die aktuelle Bewerbung
│   ├── application.tex            # Hauptdokument: wählt Theme und Bewerbung
│   ├── cover-letter.tex           # Anschreiben
│   ├── motivation.tex             # Motivationsschreiben
│   ├── feedback.tex               # optional: Feedback nach dem Gespräch
│   └── themes/
│       ├── _common.tex            # Pakete, Icons, Sprache, Hilfsmakros
│       ├── cv-content.tex         # Lebenslauf-Inhalt (Deutsch), layoutneutral
│       ├── cv-content-en.tex      # derselbe Inhalt auf Englisch
│       ├── kompakt.tex            # die drei Layouts
│       ├── sidebar.tex
│       └── akzent.tex
├── fonts/                         # Archivo (SIL Open Font License)
├── images/platzhalter.png         # Foto — durch eigenes ersetzen
├── vorschau/                      # Beispiel-PDFs der drei Layouts
└── applications/
    └── YYYY-MM-firma/             # ein Ordner pro Bewerbung
        ├── meta.tex               # Stelle, Firma, Adresse, Empfänger, Sprache
        ├── cover-letter.tex       # Kopie des verschickten Briefs (von make)
        └── motivation.tex
```

**Inhalt und Gestaltung sind getrennt.** Der ganze Lebenslauf steht einmal in `themes/cv-content.tex`, geschrieben mit semantischen Makros (`\cvrole`, `\cvfact`, `\cvtag`, …). Jedes Theme setzt diese Makros auf seine eigene Weise um. Ein Theme-Wechsel ändert deshalb kein Zeichen Inhalt.

## Voraussetzungen

- **TeX Live** (2020+), vollständige Installation (`texlive-full`) oder mindestens `fontawesome5`, `paracol`, `tikz`, `hyperref`, `microtype`
- **XeLaTeX** (wegen `fontspec`)
- Schriften **Inter** und **Source Sans Pro**: Beide sind in TeX Live enthalten (`inter`, `sourcesanspro`). Archivo liegt in `fonts/`.
- optional `inotify-tools` für `make watch`

## Erste Schritte

1. Eigene Angaben in `templates/themes/cv-content.tex` eintragen und das Foto nach `images/` legen (Pfad in `\CVphoto`). Mit `\CVphotomirror{-1}` erscheint das Foto seitenverkehrt, damit die Person zum Text hin blickt. Die Kantenlänge des Fotos im Layout `kompakt` steht in `\photowide` (`kompakt.tex`).
2. Mit `make themes` die drei Layouts vergleichen und das gewählte in `templates/application.tex` setzen:
   ```latex
   \providecommand{\cvtheme}{kompakt}   % kompakt | sidebar | akzent
   ```

## Ablauf pro Bewerbung

1. Einen Ordner `applications/2026-04-firma/` anlegen und `meta.tex` aus dem Beispielordner kopieren und anpassen.
2. In `templates/application.tex` den Ordner eintragen:
   ```latex
   \newcommand{\application}{2026-04-firma}
   ```
3. `templates/cover-letter.tex` und `templates/motivation.tex` für die Stelle neu schreiben.
4. `make application` baut das PDF und legt es zusammen mit den Briefen im Bewerbungsordner ab.
5. Beim Versand committen, inklusive `application.pdf`.

Die PDFs werden bewusst mitversioniert: `make rebuild` baut mit dem *aktuellen* Lebenslauf, das Ergebnis weicht also vom verschickten Dossier ab, sobald sich `cv-content.tex` seither geändert hat. Das abgelegte PDF ist der Beleg, was tatsächlich verschickt wurde.

## Make-Befehle

```bash
make application            # Dossier bauen + im Bewerbungsordner ablegen
make rebuild APP=<ordner>   # archivierte Bewerbung mit ihren eigenen Briefen neu bauen
make cv                     # nur der Lebenslauf -> build/cv.pdf
make feedback               # Feedback-Dokument bauen + ablegen
make themes                 # Dossier in allen drei Layouts -> build/theme-*.pdf
make theme-sidebar          # ein Layout bauen und öffnen
make view                   # bauen + öffnen
make watch                  # bei jeder Änderung neu bauen (inotify-tools)
make clean                  # build/ löschen
```

## Englische Bewerbung

Die Sprache gehört zur Stelle und nicht zum Layout. Sie wird deshalb in der `meta.tex` der Bewerbung umgeschaltet:

```latex
\newcommand{\cvlanguage}{british}       % babel-Sprache; Voreinstellung ngerman
\newcommand{\cvcontent}{cv-content-en}  % Inhaltsdatei; Voreinstellung cv-content
```

Die Abschnittsüberschriften kommen aus den `\Lbl…`-Makros. `_common.tex` setzt sie auf Deutsch, `cv-content-en.tex` übersetzt sie. Die Briefe schreibt man pro Bewerbung ohnehin in der passenden Sprache.

Man sollte `british` verwenden, nicht `english`: babel warnt bei `english` vor der mehrdeutigen Option, und `british` liefert die europäische Datumsreihenfolge.

**Beide Inhaltsdateien sind derselbe Lebenslauf.** Eine Änderung in der einen gehört auch in die andere.

## Lebenslauf-Makros

```latex
\cvrole{Titel}{Firma}{Ort, Land}{2020 -- 2024}
\cvnote{Eine Zeile Anmerkung unter der Rolle}
\begin{cvbullets}
    \item \lead{Thema:} was gemacht wurde und was dabei herauskam
\end{cvbullets}

\cvplain{Kurs}{2021}{Beschreibung}          % Weiterbildung
\cvfact{Software}{Python, SQL}              % Kompetenzen, Sprachen
\cvtag{Python}                              % Schlagwort-Chip (Sidebar-Theme)
```

Zwei Zeiträume in derselben Rolle beim selben Arbeitgeber bekommen **einen** Eintrag:

```latex
\cvrole{Titel}{Firma}{Ort}{2022 -- 2025\cvalso{2018 -- 2019}}
```

Prozentbalken für Kompetenzen gibt es bewusst nicht. Eine Skala ohne Bezugsgrösse kann der Leser nicht überprüfen, und CV-Parser lesen sie als leere Fläche.

`\cvextrasections` ist der Haken für Zusatzabschnitte wie Referenzen oder Publikationen. Er wird am Ende des Lebenslaufs ausgeführt.

Firmen- und Ortsnamen, die nicht getrennt werden sollen, gehören in `\cvhyphenexceptions` in `themes/_common.tex`.

## Mit dem Original synchron halten

Wer das Template als Ausgangspunkt für ein eigenes, **privates** Repo nutzt, kann es als zweites Remote anhängen. So lassen sich Layout-Verbesserungen übernehmen:

```bash
git remote add template <url-dieses-repos>
git fetch template
git merge template/main   # Konflikte entstehen meist nur in den Inhaltsdateien
```

Eigene Bewerbungen gehören nie in dieses Template-Repo, sondern ins private Repo.
