# LaTeX-Bewerbungen

Ein LaTeX-Projekt, das Lebenslauf, Anschreiben und Motivationsschreiben als **ein PDF-Dossier** baut, dazu optional ein Feedback-Dokument nach dem Gespräch. Vier Layouts stehen zur Wahl, der Inhalt steht nur einmal da.

Alle Inhalte sind Blindtext der fiktiven Person „Max Muster“. Sie werden durch die eigenen Angaben ersetzt.

## Layouts

| Theme | Gestaltung |
|---|---|
| `kompakt` | einspaltig, Datumsleiste links, feine Linien, Kontaktangaben zweispaltig neben dem Foto |
| `sidebar` | zweispaltig, getönte Seitenleiste mit Kontakt, Profil und Sprachen, Schlagwort-Chips |
| `akzent` | dunkles Kopfband mit Foto, Zeitachse |
| `rueckgrat` | senkrechte Linie als Rückgrat, Daten und Abschnittstitel rechtsbündig links davon, gesetzt in JetBrains Mono |

Fertig gebaute Beispiele liegen in [`vorschau/`](vorschau/) — dasselbe Blindtext-Dossier in jedem Layout. `make vorschau` baut sie neu. Mit `make themes` entsteht das eigene Dossier in allen vier Layouts unter `build/theme-*.pdf` zum Vergleichen.

## Struktur

```
├── Makefile
├── templates/                     # Arbeitskopie — immer die aktuelle Bewerbung
│   ├── application.tex            # Hauptdokument: wählt Theme und Bewerbung
│   ├── cover-letter.tex           # Anschreiben
│   ├── motivation.tex             # Motivationsschreiben
│   ├── feedback.tex               # optional: Feedback nach dem Gespräch
│   ├── cv-master.tex              # Treiber für den Master-Lebenslauf
│   └── themes/
│       ├── _common.tex            # Pakete, Icons, Sprache, Hilfsmakros
│       ├── cv-content.tex         # Lebenslauf-Inhalt (Deutsch), layoutneutral
│       ├── cv-content-en.tex      # derselbe Inhalt auf Englisch
│       ├── kompakt.tex            # die vier Layouts
│       ├── sidebar.tex
│       ├── akzent.tex
│       └── rueckgrat.tex
├── fonts/                         # Archivo, JetBrains Mono (SIL Open Font License)
├── images/platzhalter.png         # Foto — durch eigenes ersetzen
├── vorschau/                      # Beispiel-PDFs der vier Layouts
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
- Schriften **Inter** und **Source Sans Pro**: Beide sind in TeX Live enthalten (`inter`, `sourcesanspro`). Archivo und JetBrains Mono liegen in `fonts/`.
- optional `inotify-tools` für `make watch`

## Erste Schritte

1. Eigene Angaben in `templates/themes/cv-content.tex` eintragen und das Foto nach `images/` legen (Pfad in `\CVphoto`). Mit `\CVphotomirror{-1}` erscheint das Foto seitenverkehrt, damit die Person zum Text hin blickt. Die Kantenlänge des Fotos im Layout `kompakt` steht in `\photowide` (`kompakt.tex`).
2. Mit `make themes` die vier Layouts vergleichen und das gewählte in `templates/application.tex` setzen:
   ```latex
   \providecommand{\cvtheme}{kompakt}   % kompakt | sidebar | akzent | rueckgrat
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
make themes                 # Dossier in allen vier Layouts -> build/theme-*.pdf
make cv-master              # Lebenslauf mit allen Bausteinen -> build/cv-master.pdf
make dossier APP=<ordner>   # einzelne Dateien für Portale: Anschreiben_, Lebenslauf_, Bewerbung_ ...
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

## Schalter

Die Inhaltsdatei `themes/cv-content.tex` ist ein Master-Lebenslauf: Sie darf alles enthalten, was je in einem Lebenslauf stehen soll. Was eine Bewerbung davon zeigt, steuert ihre `meta.tex` mit Schaltern. `make cv-master` baut die vollständige Fassung mit allen Bausteinen.

```latex
\cvshow{projects}     % Baustein dazu, der sonst wegbleibt
\cvhide{french}       % Baustein weg, der sonst erscheint
```

In der Inhaltsdatei wird ein Baustein so markiert:

```latex
\cvopt{details}{\item ...}              % nur mit \cvshow{details} oder im Master
\cvstd{french}{\cvfact{Französisch}{...}}  % immer, ausser mit \cvhide{french}
\cvifopt{reference}{benannt}{Standardsatz} % zwei Fassungen
```

Ein neuer Schlüssel entsteht durch Verwenden, eine Liste muss nirgends gepflegt werden. Die Schlüssel der Vorlage:

| Schlüssel | Wirkung | Voreinstellung |
|---|---|---|
| `photo` | Foto im Kopf | an |
| `keywords` | Stichwortzeile unter dem Titel (kompakt, rueckgrat) | an |
| `github`, `web`, `nationality` | weitere Kontaktangaben (`web` nur rueckgrat) | aus |
| `exitreason` | Austrittsgrund in der Notizzeile der aktuellen Stelle | an |
| `details`, `tools` | zusätzliche Stichpunkte in der Berufserfahrung | aus |
| `projects` | Abschnitt Projekte nach der Berufserfahrung | aus |
| `grades` | Abschlussnoten | aus |
| `further` | Abschnitt Weiterbildung | an |
| `french` | Sprache Französisch | an |
| `interests` | Abschnitt Interessen | aus |
| `reference` | benannte Referenz statt des Standardsatzes | aus |
| `coverpage` | Deckblatt als erste Seite des Dossiers | aus |

Dazu kommen Schalter, die in der `meta.tex` als Befehl gesetzt werden:

| Befehl | Wirkung |
|---|---|
| `\newcommand{\noletters}{}` | Dossier ohne Briefe |
| `\newcommand{\nomotivation}{}` | ohne Motivationsschreiben |
| `\newcommand{\lettersfirst}{}` | Briefe vor dem Lebenslauf |
| `\newcommand{\enclosures}{Lebenslauf, Zeugnisse}` | Beilagenzeile am Ende des Anschreibens |
| `\newcommand{\cvsummaryoverride}{...}` | eigenes Kurzprofil für diese Bewerbung |
| `\newcommand{\cvskillsoverride}{\cvfact{..}{..}}` | eigene Kompetenzzeilen für diese Bewerbung |
| `\newcommand{\cvheaderclassic}{}` | kompakt: früherer Kopf mit dreispaltigen Kontaktangaben |

`make dossier APP=<ordner>` legt das Dossier zusätzlich als einzelne Dateien im Bewerbungsordner ab (Anschreiben, Motivationsschreiben, Lebenslauf, Gesamtdossier), wie es Bewerbungsportale verlangen. Liegen PDF unter `beilagen/`, kommen sie als Zeugnisse dazu. `\newcommand{\lettersinone}{}` in der `meta.tex` fasst beide Briefe in einer Datei zusammen, `PERSON=Vorname_Nachname` setzt den Namen in den Dateinamen.

Und Einstellungen in der Inhaltsdatei: `\CVphotomirror` (Foto spiegeln), `\CVphotozoom` und `\CVphotoshift` (Bildausschnitt), `\CVphotoaspect` (Hochformat, nur rueckgrat), `\CVsignature` (Unterschrift als Bild im Brief).

## Autoren

| Vorlage | Autor | Links |
|---|---|---|
| Layouts `kompakt`, `sidebar`, `akzent` | Marcel Eifert | [GitHub](https://github.com/Eifi1), [LinkedIn](https://www.linkedin.com/in/marcel-eifert/) |
| Layout `rueckgrat` | Gestaltung Markus Neusinger, als Theme umgesetzt von Marcel Eifert | [GitHub](https://github.com/MarkusNeusinger), [anyplot.ai](https://anyplot.ai) |
