%% rueckgrat.cls
%% One class for CV (Lebenslauf), letter (Anschreiben) and cover page (Deckblatt).
%% Compile with XeLaTeX (MiKTeX or TeX Live), two runs. See LIESMICH.txt.
%% Normally you only edit lebenslauf.tex and anschreiben.tex, not this file.
%%
%% Options
%%   cv | brief | deckblatt   document type (default cv)
%%   de | en                  language (default de, Swiss German spelling)
%%   papier                   warm paper background #f5f3ec instead of white
%%   greentext                comparison variant: section labels in accent green (default off)
%%   light                    body text in the Light weight instead of Regular
%%   intern                   internal build: watermark, footer "intern", legend for open items
%%   test                     test application: footer note "Test, nicht versenden"
%%   versalien                section labels in capitals with letter spacing (default: normal case)
%%   fensterlinks             letter: recipient for a left window envelope (default: right window, Swiss C5/C4)
%%   rueckgrat                CV grid layout: dates right-aligned left of a vertical spine with green nodes
%%   bplus                    CV grid layout: date column on the left, full-width hairline per section
%%                            (both grid layouts also apply to letter and cover page)
%%   schmal                   grid: narrower left column (37 mm instead of 41), the spine moves left
%%   duenn                    grid: spine 0.8 pt instead of 1.1 pt
%%   rand15 | rand12          grid: left page margin 15 or 12 mm instead of 18 (spine moves left, text block widens)
%%   ohnepfeil                grid: section labels without the grey › in front
%%   blocksatz                grid: justified body text instead of ragged right
%%   schluesselspalte         grid: keys of key-value rows (skills, languages, interests) stand in the left
%%                            column like the dates; the section label then has a line of its own
%%   name25 | name27          grid: name 25 or 27 pt instead of 23 (head baselines are kept)
%%   gesperrt                 grid: name letterspaced (LetterSpace=10), reaches closer to the photo
%%   ruhig                    grid: like knapp, but word spaces stretch at most 20 % and shrink 10 %,
%%                            right skip 1.5 em: even spacing, lines end 4 to 5 mm before the margin
%%   knapp | knapper          grid: tighter ragged right: word spaces may stretch a little (ragged2e fixes them),
%%                            right skip 1 em or 0.5 em instead of 3 em, more hyphenation; lines end closer to the margin
%%   fotoeinzug               grid: photo indented 3 mm from the right margin
%%   kopftausch               rueckgrat: birth date and nationality directly under the address, phone and
%%                            e-mail on the baselines of the last two links (letter and cover unchanged)
%%   live                     grid: grey "live" mark next to project links that are not on GitHub (default off)
%%   v1 | v2 | v3             design variant of letter and cover page in the grid layouts
%%                            letter: v1 head like the CV, v2 margin notes (default); cover: v1 head like the CV
%%                            (default), v3 contents as a row of nodes
%%
%% Fonts are loaded by relative path: the folder fonts/ (JetBrains Mono NL, SIL Open
%% Font License, see fonts/OFL.txt) must sit next to the .tex files.
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{rueckgrat}[2026/11/12 v1.0 CV, letter and cover page]

\newif\ifnc@cv      \nc@cvtrue
\newif\ifnc@brief
\newif\ifnc@deck
\newif\ifnc@en
\newif\ifnc@paper
\newif\ifnc@greentext
\newif\ifnc@light
\newif\ifnc@intern
\newif\ifnc@test
\newif\ifnc@versalien
\newif\ifnc@fensterlinks
\newif\ifnc@grid
\newif\ifnc@schmal
\newif\ifnc@briefschmal % letter: narrow left column (28 mm), sender data in the head
\newif\ifnc@ohnelinie  % grid: no vertical spine line, nodes stay
\newif\ifnc@briefkopf   % letter v2: head like the CV (contact column next to the name), no sender block
\newif\ifnc@betreffrubrik % letter v2: column label Application/Bewerbung instead of Date
\newif\ifnc@beilagengruss % letter v2: enclosures beside the closing line, signature with more air
\newif\ifnc@absendergross % letter: sender line in the window 7.8 pt instead of 6.8 pt
\newif\ifnc@ohnefenster % letter: no window geometry (PDF by mail): recipient higher, no sender line, body from 82 mm
\newif\ifnc@luft % letter: more leading for prose, 9.5/14.5 pt, paragraph gap 9 pt, 10 pt after the subject
\newif\ifnc@randnotizen % letter v2: \cvmargin{...} notes in the left column beside paragraphs
\newif\ifnc@duenn
\newif\ifnc@kopftausch % rueckgrat head: personal data under the address, contact beside the links
\def\nc@randl{18mm}
\newif\ifnc@ohnepfeil
\newif\ifnc@blocksatz
\newif\ifnc@knapp
\newif\ifnc@keycol
\newif\ifnc@gesperrt
\newif\ifnc@fotoeinzug
\newif\ifnc@live
\newif\ifnc@headreduced   % cover v3: name, title, contact and photo only
\newif\ifnc@closingpending % letter v2: closing printed together with the enclosures
\newif\ifnc@nolinks      % letter v1: CV head without the link block
\newif\ifnc@spine

\DeclareOption{cv}{\nc@cvtrue\nc@brieffalse\nc@deckfalse}
\DeclareOption{brief}{\nc@cvfalse\nc@brieftrue\nc@deckfalse}
\DeclareOption{deckblatt}{\nc@cvfalse\nc@brieffalse\nc@decktrue}
\DeclareOption{de}{\nc@enfalse}
\DeclareOption{en}{\nc@entrue}
\DeclareOption{papier}{\nc@papertrue}
\DeclareOption{greentext}{\nc@greentexttrue}
\DeclareOption{light}{\nc@lighttrue}
\DeclareOption{intern}{\nc@interntrue}
\DeclareOption{test}{\nc@testtrue}
\DeclareOption{versalien}{\nc@versalientrue}
\DeclareOption{fensterlinks}{\nc@fensterlinkstrue}
\DeclareOption{rueckgrat}{\nc@gridtrue\nc@spinetrue}
\DeclareOption{bplus}{\nc@gridtrue\nc@spinefalse}
\DeclareOption{schmal}{\nc@schmaltrue}
\DeclareOption{briefschmal}{\nc@briefschmaltrue}
\DeclareOption{ohnelinie}{\nc@ohnelinietrue}
\DeclareOption{briefkopf}{\nc@briefkopftrue}
\DeclareOption{betreffrubrik}{\nc@betreffrubriktrue}
\DeclareOption{beilagengruss}{\nc@beilagengrusstrue}
\DeclareOption{absendergross}{\nc@absendergrosstrue}
\DeclareOption{randnotizen}{\nc@randnotizentrue}
\DeclareOption{ohnefenster}{\nc@ohnefenstertrue}
\DeclareOption{luft}{\nc@lufttrue}
\DeclareOption{duenn}{\nc@duenntrue}
\DeclareOption{kopftausch}{\nc@kopftauschtrue}
\DeclareOption{rand15}{\def\nc@randl{15mm}}
\DeclareOption{rand12}{\def\nc@randl{12mm}}
\DeclareOption{ohnepfeil}{\nc@ohnepfeiltrue}
\DeclareOption{blocksatz}{\nc@blocksatztrue}
\def\nc@rrskip{3em}\def\nc@tol{200}\def\nc@hyp{2500}
% knapp: lines end closer to the margin; needs more hyphenation (lower penalty) and a higher tolerance,
% so a line that cannot be made tight ends short instead of overfull
\DeclareOption{knapp}{\nc@knapptrue\def\nc@rrskip{1em}\def\nc@tol{800}\def\nc@hyp{400}}
\DeclareOption{schluesselspalte}{\nc@keycoltrue}
\def\nc@namesize{23}
\DeclareOption{name25}{\def\nc@namesize{25}}
\DeclareOption{name27}{\def\nc@namesize{27}}
\DeclareOption{gesperrt}{\nc@gesperrttrue}
\DeclareOption{knapper}{\nc@knapptrue\def\nc@rrskip{0.5em}\def\nc@tol{2500}\def\nc@hyp{50}}
\newif\ifnc@ruhig
\DeclareOption{ruhig}{\nc@knapptrue\nc@ruhigtrue\def\nc@rrskip{1.5em}\def\nc@tol{800}\def\nc@hyp{1000}} % word spaces stretch 20 %, shrink 10 %, lines end 4 to 5 mm before the margin
\DeclareOption{fotoeinzug}{\nc@fotoeinzugtrue}
\DeclareOption{live}{\nc@livetrue}
\def\nc@var{0}
\DeclareOption{v1}{\def\nc@var{1}}
\DeclareOption{v2}{\def\nc@var{2}}
\DeclareOption{v3}{\def\nc@var{3}}
\DeclareOption*{\ClassWarning{rueckgrat}{Unknown option \CurrentOption}}
\ProcessOptions\relax
\ifnum\nc@var=0 \ifnc@brief\def\nc@var{2}\else\def\nc@var{1}\fi\fi % defaults: letter v2, cover v1

\LoadClass[10pt]{article}

%% ---------------------------------------------------------------------------
%% Design tokens
%% ---------------------------------------------------------------------------
\RequirePackage{xcolor}
\definecolor{ink}{HTML}{1A1A17}       % names, headings
\definecolor{inksoft}{HTML}{4A4A44}   % running text
\definecolor{inkmuted}{HTML}{67665F}  % labels, meta, dates
\definecolor{rule}{HTML}{D9D8D1}      % hairlines (ink at 15 % on white, solid for print)
\definecolor{accent}{HTML}{009E73}    % lines, rules, dots, small marks only; never text
\ifnc@paper
  \definecolor{paper}{HTML}{F5F3EC}
\else
  \definecolor{paper}{HTML}{FFFFFF}
\fi
\ifnc@greentext
  \colorlet{labelink}{accent}         % comparison variant only
\else
  \colorlet{labelink}{ink}
\fi

% lengths
\newlength\nc@marginx      \setlength\nc@marginx{20mm}
\newlength\nc@margintop    \setlength\nc@margintop{16mm}
\newlength\nc@marginbot    \setlength\nc@marginbot{20mm}
\newlength\nc@hair         \setlength\nc@hair{0.45pt}    % hairline
\newlength\nc@accentrule   \setlength\nc@accentrule{0.9pt}% green mark on a hairline
\newlength\nc@accentlen    \setlength\nc@accentlen{10mm}
\newlength\nc@photow       \setlength\nc@photow{30mm}
\newlength\nc@photoh       \setlength\nc@photoh{37.5mm}  % 4:5 like the source picture
\newlength\nc@labelw       \setlength\nc@labelw{42mm}    % label column in skills, languages
\newlength\nc@sectionskip  \setlength\nc@sectionskip{12pt}
\newlength\nc@entryskip    \setlength\nc@entryskip{6pt}
\newlength\nc@bulletindent \setlength\nc@bulletindent{10pt}
% grid layouts: label/date column left of the text block
\newlength\nc@colL
\newlength\nc@colG       \setlength\nc@colG{6mm}
\newlength\nc@pull
\newlength\nc@keyw       \setlength\nc@keyw{18mm}     % key column in skill rows
\newlength\nc@marginleft \setlength\nc@marginleft{\nc@marginx}
\ifnc@grid
  \setlength\nc@marginx{18mm}
  \setlength\nc@marginleft{\nc@randl}
  \setlength\nc@margintop{18mm}
  \ifnc@spine
    \setlength\nc@colL{\ifnc@schmal 37mm\else 41mm\fi}\ifnc@brief\ifnc@briefschmal\setlength\nc@colL{28mm}\fi\fi\setlength\nc@photow{32mm}\setlength\nc@photoh{40mm}
  \else
    \setlength\nc@colL{35mm}\setlength\nc@photow{30mm}\setlength\nc@photoh{37.5mm}
  \fi
  \setlength\nc@pull{\dimexpr\nc@colL+\nc@colG\relax}
  \ifnc@spine\setlength\nc@sectionskip{14pt}\else\setlength\nc@sectionskip{12pt}\fi
  \setlength\nc@entryskip{7pt}
\fi

% font sizes (pt): size / leading
\def\nc@sizebody{\fontsize{9.5}{13.2}\selectfont}
\def\nc@sizesmall{\fontsize{8}{11}\selectfont}
\def\nc@sizemeta{\fontsize{7.8}{11}\selectfont}
\def\nc@sizetiny{\fontsize{6.8}{9}\selectfont}
\def\nc@sizelabel{\fontsize{8.2}{11}\selectfont}
\def\nc@sizeentry{\fontsize{10}{13.2}\selectfont}
\def\nc@sizename{\fontsize{\nc@namesize}{\dimexpr\nc@namesize pt+4pt\relax}\selectfont}
\newlength\nc@nameextra \setlength\nc@nameextra{\dimexpr0.8\dimexpr\nc@namesize pt-23pt\relax\relax} % head gaps compensate a larger name (0.8: the glyphs grow less than the size)
\def\nc@sizetitle{\fontsize{11}{15}\selectfont}
\ifnc@grid\def\nc@sizebody{\fontsize{9.3}{12.9}\selectfont}\fi % grid layouts: narrower text block

%% ---------------------------------------------------------------------------
%% Page, fonts, language
%% ---------------------------------------------------------------------------
\newlength\nc@marginl
\ifnc@brief\ifnc@grid\setlength\nc@marginl{\nc@marginleft}\else\setlength\nc@marginl{25mm}\fi\else\setlength\nc@marginl{\nc@marginx}\fi % letter: body aligned with address
\ifnc@grid\setlength\nc@marginl{\nc@marginleft}\addtolength\nc@marginl{\nc@pull}\fi % grid: text block starts right of the label column
\RequirePackage[a4paper,left=\nc@marginl,right=\nc@marginx,top=\nc@margintop,bottom=\nc@marginbot,footskip=9mm,
  headheight=12.5pt,headsep=5mm]{geometry}
\pagecolor{paper}

\RequirePackage{fontspec}
\ifnc@light
  \def\nc@bodyweight{Light}\def\nc@bodyitalic{LightItalic}
\else
  \def\nc@bodyweight{Regular}\def\nc@bodyitalic{Italic}
\fi
% one free family for text and code roles; the NL cut has no programming ligatures
\setmainfont{JetBrainsMonoNL}[Path=fonts/, Extension=.ttf,
  UprightFont=*-\nc@bodyweight, ItalicFont=*-\nc@bodyitalic,
  BoldFont=*-SemiBold, BoldItalicFont=*-BoldItalic,
  FontFace={m}{n}{*-\nc@bodyweight},
  FontFace={mb}{n}{*-Medium},
  FontFace={mb}{it}{*-MediumItalic}]
\setsansfont{JetBrainsMonoNL}[Path=fonts/, Extension=.ttf,
  UprightFont=*-\nc@bodyweight, ItalicFont=*-\nc@bodyitalic,
  BoldFont=*-SemiBold, BoldItalicFont=*-BoldItalic]
\setmonofont{JetBrainsMonoNL}[Path=fonts/, Extension=.ttf,
  UprightFont=*-Regular, ItalicFont=*-Italic, BoldFont=*-Medium]
\newfontfamily\nc@codemedium{JetBrainsMonoNL}[Path=fonts/, Extension=.ttf, UprightFont=*-Medium]
\newfontfamily\nc@textmedium{JetBrainsMonoNL}[Path=fonts/, Extension=.ttf, UprightFont=*-Medium]
\newfontfamily\nc@textsemibold{JetBrainsMonoNL}[Path=fonts/, Extension=.ttf, UprightFont=*-SemiBold]

% font roles
\newcommand\nc@fname{\nc@codemedium\nc@sizename\color{ink}\ifnc@gesperrt\addfontfeature{LetterSpace=10}\fi}
\newcommand\nc@ftitle{\rmfamily\nc@sizetitle\color{inksoft}}
\newcommand\nc@fmeta{\ttfamily\nc@sizemeta\color{inkmuted}}
\ifnc@versalien
  \newcommand\nc@flabel{\nc@codemedium\nc@sizelabel\color{labelink}\addfontfeature{LetterSpace=6}}
  \newcommand\nc@labelcase[1]{\MakeUppercase{#1}}
\else
  \newcommand\nc@flabel{\nc@codemedium\fontsize{8.6}{11}\selectfont\color{labelink}\addfontfeature{LetterSpace=2.5}}
  \newcommand\nc@labelcase[1]{#1}
\fi
\newcommand\nc@fentry{\nc@textsemibold\nc@sizeentry\color{ink}}
\newcommand\nc@forg{\rmfamily\nc@sizebody\color{inksoft}}
\newcommand\nc@fdate{\ttfamily\nc@sizemeta\color{inkmuted}}
\newcommand\nc@fbody{\rmfamily\nc@sizebody\color{inksoft}}
\newcommand\nc@fbodynocolor{\rmfamily\nc@sizebody}
\newcommand\nc@ftag{\ttfamily\nc@sizemeta\color{inkmuted}}

\RequirePackage{polyglossia}
\ifnc@en
  % British spelling in the texts; US patterns because en-GB patterns are often not installed
  \setdefaultlanguage[variant=american]{english}
  \setlanghyphenmins[variant=american]{english}{3}{4}
\else
  \setdefaultlanguage[variant=swiss]{german}
  \setlanghyphenmins[variant=swiss]{german}{3}{4}
\fi

\RequirePackage{graphicx}
\RequirePackage{tikz}
\RequirePackage{enumitem}
\RequirePackage{ragged2e}
\RequirePackage{calc}
\RequirePackage{fancyhdr}
\RequirePackage{lastpage}
\RequirePackage{eso-pic}
\RequirePackage{needspace}
\RequirePackage[hidelinks]{hyperref}
\hypersetup{colorlinks=true, linkcolor=ink, urlcolor=ink, citecolor=ink, pdfborder={0 0 0},
  pdfcreator={rueckgrat.cls, XeLaTeX}}
\ifnc@en\hypersetup{pdflang=en-GB}\else\hypersetup{pdflang=de-CH}\fi

\setlength\parindent{0pt}
\setlength\parskip{0pt}
\setlength\emergencystretch{2em}
\frenchspacing
% ragged right with hyphenation (needs German patterns; without them TeX simply does not hyphenate)
\setlength\RaggedRightRightskip{0pt plus \nc@rrskip}
\tolerance=\nc@tol
% knapp: plain TeX ragged right with the font's own stretchable word spaces (ragged2e fixes them),
% so lines are filled first by word spacing, then by hyphenation, and only then end short
\newcommand\nc@tightragged{\rightskip=0pt plus \nc@rrskip\relax\@rightskip=0pt plus \nc@rrskip\relax % \@rightskip: lists reset \rightskip from it
  \spaceskip=0pt\relax\parfillskip=0pt plus 1fil\relax
  \ifnc@ruhig\fontdimen3\font=0.2\fontdimen2\font \fontdimen4\font=0.1\fontdimen2\font \fi}
% code lines and the narrow column keep the loose ragged setting (long tokens, no hyphenation)
\newcommand\nc@RaggedRightLoose{\setlength\RaggedRightRightskip{0pt plus 3em}\RaggedRight}
\AtBeginDocument{\rmfamily\nc@sizebody\color{inksoft}\ifnc@blocksatz\else\ifnc@knapp\nc@tightragged\else\RaggedRight\fi\fi}
% few, clean hyphenations; set after polyglossia has selected the language
\AddToHook{begindocument/end}{%
  \ifnc@en % US patterns break often and in odd places: English stays ragged right without hyphenation
    \hyphenpenalty=10000
    \hyphenation{TypeScript JavaScript FastAPI PostgreSQL scikit-learn hetero-geneous
      identifi-cation pro-duction theo-retical classi-fication visual-isation harmon-isation}%
  \else % compounds the patterns split badly; words without hyphen never break
    \hyphenpenalty=\nc@hyp
    \ifnc@grid\exhyphenpenalty=10000 \fi % grid: never break after an explicit hyphen (keeps LLM-Pipelines whole for parsers)
    \hyphenation{Projekt-management Projekt-leitung Qualitäts-sicherung Inbetrieb-nahme
      Daten-visualisierung Auswerte-prozesse Fertigungs-anlagen Fach-bereich Fach-bereichen
      Weiter-bildung Zusammen-arbeit Maschinen-bau Automatisierungs-technik
      TypeScript JavaScript Machine Learning Fertigung Qualität Entwicklung}%
  \fi}

%% ---------------------------------------------------------------------------
%% Small marks
%% ---------------------------------------------------------------------------
% green dot (graphic, not text)
\newcommand\nc@dot[2][accent]{\tikz[baseline=-0.5ex]\fill[#1] (0,0) circle (#2);}
% separators are grey; green stays reserved for hairline marks and "not yet confirmed"
\newcommand\cvsep{\hspace{0.45em}\nc@dot[inkmuted]{0.7pt}\hspace{0.45em}}
\newcommand\cvsepaccent{\hspace{0.55em}\nc@dot{0.9pt}\hspace{0.55em}}
\newcommand\cvbullet{\nc@dot[inkmuted]{0.85pt}}

% marker for items with beleg "bestaetigen" (only in internal builds)
\newcommand\cvoffen{\leavevmode\llap{\nc@dot{2pt}\hspace{5pt}}}
\newcommand\cvoffenitem{\leavevmode\llap{\nc@dot{2pt}\hspace{\nc@bulletindent+6pt}}}
\newcommand\cvoffeninline{\nc@dot{1.6pt}\hspace{3pt}}
% internal appendix row: item id and source
\newcommand\cvopenrow[2]{\par\noindent\parbox[t]{50mm}{\raggedright\ttfamily\nc@sizetiny\color{ink}\nc@dot{1.6pt}\hspace{3pt}#1}%
  \parbox[t]{\linewidth-50mm}{\raggedright\ttfamily\nc@sizetiny\color{inkmuted}#2}\par\vspace{1.5pt}}

% hairline with green start mark (plain rules: no overfull boxes, prints crisp)
\newcommand\cvhair[1][\linewidth]{%
  \par\noindent
  \rlap{\textcolor{rule}{\rule[0.225pt]{#1}{\nc@hair}}}%
  \textcolor{accent}{\rule{\nc@accentlen}{\nc@accentrule}}\par}
\newcommand\cvhairplain[1][\linewidth]{%
  \par\noindent\textcolor{rule}{\rule{#1}{\nc@hair}}\par}

\newcommand\cvlink[2]{\href{#1}{#2}}
% portrait, optionally clipped: \cvfield{fotoviewport}{<left> <bottom> <right> <top>} in pixels of the image file
% mirrored on request, \cvfield{fotospiegeln}{1}: the sitter faces the text; the image file stays untouched
\newcommand\nc@photo{\nc@iffield{fotospiegeln}{\reflectbox{\nc@photoraw}}{\nc@photoraw}}
\newcommand\nc@photoraw{\nc@iffield{fotoviewport}%
  {\edef\nc@vp{\nc@get{fotoviewport}}\expandafter\nc@photoclip\expandafter{\nc@vp}}%
  {\includegraphics[width=\nc@photow,height=\nc@photoh]{\nc@get{foto}}}}
\newcommand\nc@photoclip[1]{\includegraphics[viewport=#1,clip,width=\nc@photow,height=\nc@photoh]{\nc@get{foto}}}
\newcommand\cvlistsep{,\ }   % between enclosures; a line break in the left column
\newcommand\cvcomma{,\ }     % comma in address and nationality; a line break in narrow columns
\newcommand\cvarrow{→}       % date ranges in the grid layouts
\newif\ifnc@livenext
\newcommand\cvlivenext{\global\nc@livenexttrue} % next project gets the green "live" mark

%% ---------------------------------------------------------------------------
%% Header fields (each one switchable): \cvfield{<key>}{<value>}, \cvhide{<key>}
%% keys: name titel adresse telefon email web github linkedin geburtsdatum
%%       nationalitaet zivilstand foto
%% ---------------------------------------------------------------------------
\newcommand\cvfield[2]{\expandafter\def\csname nc@f@#1\endcsname{#2}}
\newcommand\cvhide[1]{\expandafter\let\csname nc@f@#1\endcsname\relax}
% \nc@iffield{key}{if present}{if absent}
\newcommand\nc@iffield[1]{\expandafter\ifx\csname nc@f@#1\endcsname\relax
  \expandafter\@secondoftwo\else\expandafter\@firstoftwo\fi}
\newcommand\nc@get[1]{\csname nc@f@#1\endcsname}

% contact line builder: prints present fields separated by \cvsep
\newif\ifnc@first
\newcommand\nc@item[1]{\nc@iffield{#1}{\ifnc@first\nc@firstfalse\else\cvsep\fi\mbox{\nc@get{#1}}}{}}
\newcommand\nc@contactlines{%
  {\nc@fmeta\hypersetup{urlcolor=inkmuted}% whole contact block in ink-muted, links stay clickable
   \nc@firsttrue\nc@item{adresse}\nc@item{telefon}\nc@item{email}\par
   \nc@firsttrue\nc@item{web}\nc@item{github}\nc@item{linkedin}\par
   \nc@firsttrue\nc@item{geburtsdatum}\nc@item{zivilstand}\par
   \nc@firsttrue\nc@item{nationalitaet}\par}}

%% ---------------------------------------------------------------------------
%% Footer
%% ---------------------------------------------------------------------------
\def\nc@doclabel{}
\newcommand\cvdoclabel[1]{\def\nc@doclabel{#1}}
\def\nc@pageword{\ifnc@en Page\else Seite\fi}
\def\nc@ofword{\ifnc@en of\else von\fi}
\def\nc@internnote{}
\newcommand\cvinternnote[1]{\def\nc@internnote{#1}}
\def\nc@testnote{\ifnc@en Test application, not a real application\else Testbewerbung, keine echte Bewerbung\fi}
\def\nc@legend{\ifnc@en not yet confirmed\else noch zu bestätigen\fi}

\pagestyle{fancy}
\fancyhf{}
\renewcommand\headrulewidth{0pt}
\renewcommand\footrulewidth{0pt}
\fancyfoot[L]{\nc@fmeta\nc@sizetiny
  \ifnc@intern\nc@dot{2pt}\hspace{4pt}\nc@legend\cvsep\nc@internnote
  \else\ifnc@test\nc@testnote\else\nc@iffield{name}{\nc@get{name}}{}\ifx\nc@doclabel\@empty\else\cvsep\nc@doclabel\fi\fi\fi}
\fancyfoot[R]{\nc@fmeta\nc@sizetiny\nc@pageword\ \thepage\ \nc@ofword\ \pageref*{LastPage}}
\fancypagestyle{plain}{}
\ifnc@brief\ifnc@test\else\ifnc@intern\else\pagestyle{empty}\fi\fi\fi

% watermark for internal builds
\ifnc@intern
  \AddToShipoutPictureBG{%
    \AtPageCenter{\makebox[0pt]{\rotatebox{55}{\nc@codemedium\fontsize{110}{110}\selectfont
      \color{rule!45}INTERN}}}}
\fi

%% ---------------------------------------------------------------------------
%% CV building blocks
%% ---------------------------------------------------------------------------
% header: name, title, contact on the left, photo top right
\newlength\nc@headw
\newcommand\cvheader{%
  \nc@iffield{foto}{\setlength\nc@headw{\linewidth-\nc@photow-8mm}}{\setlength\nc@headw{\linewidth}}%
  \begin{minipage}[t]{\nc@headw}%
    \vspace{0pt}%
    {\nc@fname\nc@get{name}\par}%
    \vspace{3pt}%
    \nc@iffield{titel}{{\nc@ftitle\nc@get{titel}\par}}{}%
    \vspace{12pt}%
    \nc@contactlines
  \end{minipage}%
  \nc@iffield{foto}{\hfill
    \begin{minipage}[t]{\nc@photow}\vspace{0pt}%
      \nc@photo%
    \end{minipage}}{}%
  \par\vspace{6pt}}

% section: label, hairline with green start mark
\newcommand\cvsection[1]{%
  \par\addvspace{\nc@sectionskip}%
  \Needspace{4\baselineskip}%
  {\leavevmode\nc@flabel\nc@labelcase{#1}\par}\nobreak
  \nointerlineskip\vspace{4.5pt}\nobreak\cvhair\nobreak\vspace{1.5pt}\nobreak
  \@afterheading}

% optional muted intro line under a section label
\newcommand\cvsectionnote[1]{{\leavevmode\rmfamily\itshape\nc@sizesmall\color{inkmuted}#1\par}\vspace{4pt}}

% entry: \cventry[<marker>]{title}{organisation, place}{dates}
\newcommand\cventry[4][]{%
  \par\addvspace{\nc@entryskip}%
  \Needspace{4\baselineskip}%
  {\leavevmode#1\nc@fentry #2\hfill{\nc@fdate #4}\par}\nobreak
  \ifx\relax#3\relax\else{\leavevmode\nc@forg #3\par}\nobreak\fi
  \vspace{1.5pt}\nobreak}

% project entry: \cvproject[<marker>]{name}{link text}{url}{dates}
\newcommand\cvproject[5][]{%
  \par\addvspace{\nc@entryskip}%
  \Needspace{7\baselineskip}% keep name, description and first point together
  {\leavevmode#1\nc@fentry #2\ifx\relax#3\relax\else\cvsep{\nc@fmeta\href{#4}{#3}}\fi\hfill{\nc@fdate #5}\par}\nobreak
  \vspace{1pt}\nobreak}

\newcommand\cvtext[1]{{\leavevmode\nc@fbody\clubpenalty=10000 \widowpenalty=10000 #1\par}\vspace{2pt}}
\newcommand\cvtags[1]{\nobreak\vspace{1.5pt}\nobreak{\leavevmode\nc@ftag #1\par}}

% label row (skills, languages): \cvrow[<marker>]{label}{value}
\newcommand\cvrow[3][]{%
  \par\noindent#1\parbox[t]{\nc@labelw}{\raggedright\nc@fmeta #2}%
  \parbox[t]{\linewidth-\nc@labelw}{\raggedright\nc@fbody #3}\par\vspace{2.5pt}}

\newenvironment{cvbullets}{%
  \begin{itemize}[label=\cvbullet, leftmargin=\nc@bulletindent, labelsep=5pt,
    itemsep=1.6pt, parsep=0pt, topsep=2pt, partopsep=0pt, beginpenalty=10000]%
    \nc@fbodynocolor\clubpenalty=10000 \widowpenalty=10000 }%
  {\end{itemize}}


%% ---------------------------------------------------------------------------
%% Grid layouts (rueckgrat, bplus): labels and dates in a left column
%% ---------------------------------------------------------------------------
\ifnc@grid
\RequirePackage{refcount}
\def\nc@pending{}
\def\nc@cursection{}
% left column at the start of the current line; smashed so it never changes the line height
% (\leavevmode before any \color: a colour whatsit in vertical mode would shift the [t] baseline)
\newsavebox\nc@lcbox
\newcommand\nc@leftcol[1]{\leavevmode\sbox\nc@lcbox{\parbox[t]{\nc@colL}{%
  \ifnc@spine\RaggedLeft\else\nc@RaggedRightLoose\fi\leavevmode #1}}%
  \ht\nc@lcbox\z@\dp\nc@lcbox\z@\llap{\usebox\nc@lcbox\hspace{\nc@colG}}}
\newcommand\nc@labeltext[1]{{\nc@flabel\ifnc@ohnepfeil\else\textcolor{inkmuted}{›}\ \fi\nc@labelcase{#1}}}
% green node on the spine (white halo so the line appears to pass behind it)
\newcommand\nc@node{\ifnc@spine\rlap{\hspace{-0.5\nc@colG}\raisebox{0.3em}{\tikz[overlay]{%
  \fill[paper] (0,0) circle (4.3pt); \fill[accent] (0,0) circle (2.9pt);}}}\fi}
% full-width hairline with green start (bplus); no interline glue around it, no break after it
\newcommand\nc@fullrule{\par\nointerlineskip\vspace{3pt}\noindent\hspace*{-\nc@pull}%
  \rlap{\textcolor{rule}{\rule[0.225pt]{\dimexpr\linewidth+\nc@pull\relax}{\nc@hair}}}%
  \textcolor{accent}{\rule{6.35mm}{\nc@accentrule}}\par\nobreak\nointerlineskip\vspace{3.5pt}\nobreak}
% pending section label: shares the line with the following text or row
\newcommand\nc@emitlabel{\ifx\nc@pending\@empty\else
  \nc@leftcol{\nc@labeltext{\nc@pending}}\nc@node\global\let\nc@pending\@empty\fi}
% before entries the label stands on a line of its own, followed by the entry gap
\newcommand\nc@flushlabel{{\leavevmode\nc@emitlabel\nc@fbody\strut\par}\nobreak\vspace{5pt}\nobreak}
% start of an entry: gap, keep-together, label line or, on a new page, the section label again
\newcounter{nc@entry}
\newcommand\nc@entrystart[1]{%
  \par
  \ifx\nc@pending\@empty
    \addvspace{\nc@entryskip}\Needspace{#1\baselineskip}%
    \stepcounter{nc@entry}\label{nc@entry\arabic{nc@entry}}%
    \ifnum\value{nc@entry}>1
      \ifnum\getpagerefnumber{nc@entry\the\numexpr\value{nc@entry}-1\relax}<\getpagerefnumber{nc@entry\arabic{nc@entry}}\relax
        \ifnc@spine\else\nc@fullrule\fi
        \global\let\nc@pending\nc@cursection\nc@flushlabel
      \fi
    \fi
  \else
    \Needspace{\numexpr#1+1\relax\baselineskip}%
    \stepcounter{nc@entry}\label{nc@entry\arabic{nc@entry}}%
    \nc@flushlabel
  \fi}

% lines kept together with a section label; a one-row section needs fewer (\cvsectionneed)
\def\nc@secneed{5}
\newcommand\cvsectionneed[1]{\gdef\nc@secneed{#1}}
\renewcommand\cvsection[1]{%
  \par\addvspace{\nc@sectionskip}%
  \Needspace{\nc@secneed\baselineskip}\gdef\nc@secneed{5}%
  \ifnc@spine\else\nc@fullrule\fi
  \gdef\nc@pending{#1}\gdef\nc@cursection{#1}\@afterheading}
\renewcommand\cvsectionnote[1]{{\leavevmode\nc@emitlabel\rmfamily\nc@sizesmall\color{inkmuted}#1\par}\addvspace{2pt}}
\renewcommand\cvtext[1]{{\leavevmode\nc@emitlabel\nc@fbody\clubpenalty=10000 \widowpenalty=10000 #1\par}\addvspace{1pt}}
% key-value row as a hanging paragraph: one baseline grid for single and wrapped rows
\renewcommand\cvrow[3][]{%
  \par{\nc@fbody\hangindent\nc@keyw\hangafter1
   \leavevmode\nc@emitlabel#1\makebox[\nc@keyw][l]{\nc@fmeta #2}#3\par}\addvspace{2.2pt}}
\ifnc@keycol % keys in the left column, label on its own line like before entries
\renewcommand\cvrow[3][]{%
  \par\ifx\nc@pending\@empty\else\nc@flushlabel\fi
  {\nc@fbody\leavevmode\nc@leftcol{\nc@fmeta #2}#1#3\par}\addvspace{2.2pt}}
\fi
\newcommand\cvrowgap{} % no extra gap before appended rows: same rhythm as the other rows
\renewcommand\cventry[4][]{%
  \nc@entrystart{4}%
  {\leavevmode\nc@leftcol{\nc@fdate #4}#1\nc@fentry #2\par}\nobreak
  \ifx\relax#3\relax\else{\leavevmode\nc@forg\color{inkmuted}#3\par}\nobreak\fi
  \addvspace{1.5pt}\nobreak}
\renewcommand\cvproject[5][]{%
  \nc@entrystart{7}%
  {\leavevmode\nc@leftcol{\nc@fdate #5}#1\nc@fentry #2%
   \ifx\relax#3\relax\else\hspace{0.8em}{\nc@fmeta\hypersetup{urlcolor=inkmuted}\href{#4}{#3}}\fi
   \ifnc@live\ifnc@livenext\hspace{0.7em}\nc@dot[inkmuted]{1.4pt}\hspace{0.3em}{\nc@fmeta\nc@sizetiny live}\fi\fi\par}%
  \global\nc@livenextfalse\nobreak\addvspace{1pt}\nobreak}
\renewcommand\cvtags[1]{\nobreak\vspace{3pt}\nobreak{\nc@RaggedRightLoose\leavevmode\nc@fmeta\interlinepenalty=10000 #1\par}} % code lines stay ragged, also in blocksatz
\renewcommand\cvbullet{\nc@dot[inkmuted]{1.1pt}}
\renewenvironment{cvbullets}{%
  \begin{itemize}[label=\cvbullet, leftmargin=\nc@bulletindent, labelsep=5pt,
    itemsep=1.8pt, parsep=0pt, topsep=3pt, partopsep=0pt, beginpenalty=10000]%
    \nc@fbodynocolor\clubpenalty=10000 \widowpenalty=10000 \@endparpenalty=10000 }%
  {\end{itemize}}

% blocks of the contact column in the rueckgrat head (kopftausch swaps contact and personal data)
\newcommand\nc@headcontact{%
  \nc@iffield{telefon}{\nc@get{telefon}\par}{}%
  \nc@iffield{email}{\nc@get{email}\par}{}}
\newcommand\nc@headperson{%
  \nc@iffield{geburtsdatumkurz}{\nc@get{geburtsdatumkurz}\par}{\nc@iffield{geburtsdatum}{\nc@get{geburtsdatum}\par}{}}%
  \nc@iffield{nationalitaetkurz}{\nc@get{nationalitaetkurz}\par}{\nc@iffield{nationalitaet}{\nc@get{nationalitaet}\par}{}}}
\newcommand\nc@headzivil{\nc@iffield{zivilstand}{\nc@get{zivilstand}\par}{}}
% header
\newcommand\nc@headmiddle{%
  \vspace{-3pt}{\nc@fname\nc@get{name}\par}\vspace{2pt}%
  \nc@iffield{titel}{{\nc@ftitle\nc@get{titel}\par}}{}}
\renewcommand\cvheader{%
  \noindent
  \ifnc@spine
    % stream order for parsers: name, links, photo, then the contact column (kerned back to the left)
    \begin{minipage}[t]{\dimexpr\linewidth-\nc@photow-\nc@colG\relax}\vspace{0pt}%
      \nc@headmiddle
      % baselines on the grid of the contact column: keywords with the phone line
      \ifnc@headreduced\else
      \nc@iffield{stichworte}{\vspace{11pt}{\nc@fmeta\nc@get{stichworte}\par}}{\vspace{11pt}\mbox{}\par}%
      \ifnc@nolinks\else
      \vspace{\dimexpr23pt-\nc@nameextra\relax}% links one per line; the last one on the bottom edge of the photo (variant C2)
      {\nc@fmeta\hypersetup{urlcolor=inkmuted}%
       \nc@iffield{web}{\nc@get{web}\par}{}%
       \nc@iffield{github}{\nc@get{github}\par}{}%
       \nc@iffield{linkedin}{\nc@get{linkedin}\par}{}}%
      \fi
      \fi
    \end{minipage}%
    \hspace{\nc@colG}%
    \nc@iffield{foto}{\begin{minipage}[t]{\nc@photow}\vspace{0pt}%
      \ifnc@fotoeinzug\hspace*{-3mm}\fi\nc@photo\end{minipage}}{\hspace{\nc@photow}}%
    \hspace*{-\dimexpr\linewidth+\nc@pull\relax}%
    \begin{minipage}[t]{\nc@colL}\vspace{0pt}\RaggedLeft
      \vspace{\dimexpr27pt+\nc@nameextra\relax}% first contact line on the baseline of the job title
      {\nc@fmeta\hypersetup{urlcolor=inkmuted}\def\cvcomma{\newline}%
       \nc@iffield{adresse}{\nc@get{adresse}\par}{}%
       \ifnc@headreduced
         \nc@headcontact
         \nc@iffield{web}{\nc@get{web}\par}{}% letter and cover: website under the e-mail
         \nc@headzivil
       \else
         \ifnc@kopftausch % personal data under the address, phone and e-mail on the baselines of the last two links
           \nc@headperson\nc@headzivil
           \vspace{\dimexpr23pt-\nc@nameextra\relax}%
           \nc@headcontact
         \else % birth date and nationality on the baselines of the last two links
           \nc@headcontact
           \vspace{\dimexpr23pt-\nc@nameextra\relax}%
           \nc@headperson\nc@headzivil
         \fi
       \fi}%
    \end{minipage}%
  \else
    \begin{minipage}[t]{\nc@iffield{foto}{\dimexpr\linewidth-\nc@photow-\nc@colG\relax}{\linewidth}}\vspace{0pt}%
      \nc@headmiddle
      \ifnc@headreduced
      \vspace{12pt}{\nc@fmeta\hypersetup{urlcolor=inkmuted}\nc@firsttrue\nc@item{adresse}\nc@item{telefon}\par
        \nc@firsttrue\nc@item{email}\par}%
      \else
      \vspace{28pt}% last contact line on the bottom edge of the photo
      {\nc@fmeta\hypersetup{urlcolor=inkmuted}%
       \nc@firsttrue\nc@item{adresse}\nc@item{telefon}\par
       \nc@firsttrue\nc@item{email}\nc@item{github}\par
       \nc@firsttrue\nc@item{web}\nc@item{linkedin}\par
       \nc@firsttrue\nc@iffield{geburtsdatumkurz}{\nc@item{geburtsdatumkurz}}{\nc@item{geburtsdatum}}%
       \nc@iffield{nationalitaetkurz}{\nc@item{nationalitaetkurz}}{\nc@item{nationalitaet}}\nc@item{zivilstand}\par}%
      \fi
    \end{minipage}%
    \hspace{\nc@colG}%
    \nc@iffield{foto}{\begin{minipage}[t]{\nc@photow}\vspace{0pt}%
      \nc@photo\end{minipage}}{}%
  \fi
  \par\vspace{4pt}}

% running head (from page 2) and footer
\fancyhf{}
\fancyhfoffset[L]{\nc@pull}
\newcommand\nc@pagenum{\nc@fmeta\nc@sizetiny\thepage/\pageref*{LastPage}}
\newcommand\nc@footnote{\nc@fmeta\nc@sizetiny\ifnc@intern\nc@dot{2pt}\hspace{4pt}\nc@legend\cvsep\nc@internnote\else\ifnc@test\nc@testnote\fi\fi}
\ifnc@spine
  \fancyfoot[L]{\makebox[\nc@colL][r]{\nc@pagenum}\hspace{\nc@colG}\nc@footnote}
  \fancyhead[L]{\ifnum\value{page}>1 {\nc@fmeta\makebox[\nc@colL][r]{\nc@get{name}}\hspace{\nc@colG}\nc@doclabel}\fi}
\else
  \fancyfoot[L]{\nc@footnote}
  \fancyfoot[R]{\nc@pagenum}
  \fancyhead[L]{\ifnum\value{page}>1 {\nc@fmeta\nc@get{name}}\fi}
  \fancyhead[R]{\ifnum\value{page}>1 {\nc@fmeta\nc@doclabel}\fi}
\fi
% the spine: a vertical line through the whole page, behind the nodes
\ifnc@ohnelinie\else\ifnc@spine
  \AddToShipoutPictureBG{\AtPageLowerLeft{%
    \put(\LenToUnit{\dimexpr\nc@marginleft+\nc@colL+0.5\nc@colG-\ifnc@duenn 0.4pt\else 0.55pt\fi\relax},\LenToUnit{9.5mm}){%
      \color{ink}\rule{\ifnc@duenn 0.8pt\else 1.1pt\fi}{\dimexpr\paperheight-9.5mm-\ifnum\value{page}>1 8.5mm\else\nc@margintop\fi\relax}}}}
\fi\fi
\fi


%% ---------------------------------------------------------------------------
%% Letter (Anschreiben), Swiss conventions, window envelope right (default) or left
%% ---------------------------------------------------------------------------
\newlength\nc@addrx
\ifnc@fensterlinks
  \setlength\nc@addrx{25mm}   % left window, flush with the body text
\else
  \setlength\nc@addrx{118mm}  % right window (Swiss C5/C4), block ends inside the window at 190 mm
\fi
\newlength\nc@addry \setlength\nc@addry{53mm}  % sender line top from top page edge (window 50 to 95 mm, 3 mm clear of the edge)
\newcommand\nc@sizeletter{\fontsize{10}{14.5}\selectfont}

\newlength\nc@bodystart \setlength\nc@bodystart{98mm} % letter body (place, date) from top edge
\ifnc@ohnefenster\setlength\nc@addry{47mm}\setlength\nc@bodystart{82mm}\fi
\newlength\nc@letterparskip \setlength\nc@letterparskip{\ifnc@luft 9pt\else 7pt\fi}
\newsavebox\nc@lhbox
\newcommand\cvletterhead{%
  \sbox\nc@lhbox{\parbox[t]{\linewidth}{%
    \vspace{0pt}%
    {\nc@codemedium\fontsize{16}{19}\selectfont\color{ink}\nc@get{name}\par}%
    \vspace{2pt}%
    \nc@iffield{titel}{{\rmfamily\fontsize{8.6}{11.5}\selectfont\color{inksoft}\nc@get{titel}\par}}{}%
    \vspace{6pt}%
    {\nc@fmeta\hypersetup{urlcolor=inkmuted}\nc@firsttrue\nc@item{adresse}\nc@item{telefon}\nc@item{email}\nc@item{web}\par}%
    \vspace{5pt}\cvhair}}%
  \noindent\usebox\nc@lhbox\par}

% \cvrecipient{sender line}{line\\line\\line}: absolute position for a window envelope (left window)
\newcommand\cvrecipient[2]{%
  \AddToShipoutPictureFG*{\AtPageUpperLeft{\put(\LenToUnit{\nc@addrx},\LenToUnit{-\nc@addry}){%
    \begin{minipage}[t]{72mm}\vspace{0pt}%
      \ifnc@ohnefenster\else\ifx\relax#1\relax\else{\ttfamily\ifnc@absendergross\nc@sizemeta\else\nc@sizetiny\fi\color{inkmuted}#1\par}\vspace{1.5mm}\fi\fi
      \rmfamily\nc@sizeletter\color{ink}#2\end{minipage}}}}}
\providecommand\cvmargin[1]{}
\newcommand\cvletterbody{\par\vspace*{\dimexpr\nc@bodystart-\nc@margintop-\ht\nc@lhbox-\dp\nc@lhbox-\baselineskip\relax}}
\newcommand\cvplacedate[1]{{\leavevmode\rmfamily\nc@sizeletter\color{inksoft}#1\par}\vspace{14pt}}
\newcommand\cvsubject[1]{{\leavevmode\nc@textsemibold\fontsize{10.5}{14.5}\selectfont\color{ink}#1\par}\vspace{12pt}}
\newenvironment{cvletter}{\rmfamily\nc@sizeletter\color{inksoft}\setlength\parskip{\nc@letterparskip}}{\par}
\newcommand\cvclosing[3]{% closing, signature file (or empty), name
  \par\vspace{8pt}{\rmfamily\nc@sizeletter\color{inksoft}#1\par}%
  \ifx\relax#2\relax\vspace{30pt}\else\vspace{2pt}\includegraphics[height=13mm]{#2}\par\vspace{0pt}\fi
  {\rmfamily\nc@sizeletter\color{ink}#3\par}}
\newcommand\cvenclosures[2]{\par\vspace{16pt}{\nc@fmeta #1\ #2\par}}

%% ---------------------------------------------------------------------------
%% Cover page (Deckblatt)
%% ---------------------------------------------------------------------------
% same header as the CV (photo right), target role in the middle, contents at the bottom
\newcommand\cvcover[4]{% kicker, target role, company, contents list
  \thispagestyle{empty}%
  \cvheader
  \vspace{4pt}\cvhair
  \vspace*{\fill}%
  {\leavevmode\nc@flabel\nc@labelcase{#1}\par}%
  \vspace{8pt}%
  {\leavevmode\nc@textsemibold\fontsize{24}{29}\selectfont\color{ink}#2\par}%
  \vspace{5pt}%
  {\leavevmode\rmfamily\fontsize{13}{17}\selectfont\color{inksoft}#3\par}%
  \vspace*{\fill}\vspace*{\fill}%
  {\leavevmode\nc@flabel\nc@labelcase{\ifnc@en Contents\else Inhalt\fi}\par}%
  \nointerlineskip\vspace{4.5pt}\cvhairplain\vspace{1.5pt}%
  {\leavevmode\nc@fbody #4\par}%
  \ifnc@test\vspace{10pt}{\leavevmode\nc@fmeta\nc@sizetiny\nc@testnote\par}\fi
}

%% ---------------------------------------------------------------------------
%% Grid layouts for letter and cover page
%% ---------------------------------------------------------------------------
\ifnc@grid
% green node right of a right-aligned label (absolute blocks in the left column)
\newcommand\nc@nodeafter{\ifnc@spine\rlap{\hspace{0.5\nc@colG}\raisebox{0.3em}{\tikz[overlay]{%
  \fill[paper] (0,0) circle (4.3pt); \fill[accent] (0,0) circle (2.9pt);}}}\fi}
% short hairline with green start across the left column only (bplus)
\newcommand\nc@colrule{\noindent\rlap{\textcolor{rule}{\rule[0.225pt]{\nc@colL}{\nc@hair}}}%
  \textcolor{accent}{\rule{6.35mm}{\nc@accentrule}}\par\nointerlineskip\vspace{4pt}}
% letter and cover page: no page number, only the test or internal note in the text column
% (the CV keeps its running head and page numbers from the block above)
\ifnc@cv\else
\fancyhf{}
\fancyhfoffset[L]{\nc@pull}
\ifnc@spine
  \fancyfoot[L]{\hspace*{\dimexpr\nc@colL+\nc@colG\relax}\nc@footnote}
\else
  \fancyfoot[L]{\nc@footnote}
\fi
\fi

\ifnc@brief
  \renewcommand\nc@sizeletter{\fontsize{9.5}{\ifnc@luft 14.5\else 13.8\fi}\selectfont}
  \ifnum\nc@var=1
    % ---- B1: the CV head without photo, classic letter below
    \nc@nolinkstrue
    \nc@headreducedtrue % no keyword line, no links, no birth date in the letter
    \renewcommand\cvsubject[1]{{\leavevmode\nc@textsemibold\fontsize{10.5}{14.5}\selectfont\color{ink}#1\par}\vspace{8pt}}
    \renewcommand\cvletterhead{%
      \sbox\nc@lhbox{\parbox[t]{\linewidth}{\vspace{0pt}\cvheader
        \ifnc@spine\else\vspace{1pt}\nc@fullrule\fi}}%
      \noindent\usebox\nc@lhbox\par}
    % place and date left of the window, on the height of the sender line (54.5 mm)
    \renewcommand\cvplacedate[1]{\AddToShipoutPictureFG*{\AtPageUpperLeft{%
      \put(\LenToUnit{\nc@marginl},\LenToUnit{-54.5mm}){\rmfamily\nc@sizeletter\color{inksoft}#1}}}}
    \renewcommand\cvenclosures[2]{\par\vspace{10pt}{\nc@fmeta #1\ #2\par}}
    \renewcommand\cvclosing[3]{%
      \par\vspace{6pt}{\rmfamily\nc@sizeletter\color{inksoft}#1\par}%
      \ifx\relax#2\relax\vspace{26pt}\else\vspace{2pt}\includegraphics[height=11mm]{#2}\par\vspace{0pt}\fi
      {\rmfamily\nc@sizeletter\color{ink}#3\par}}
  \else
    % ---- B2: margin notes; sender, date and enclosures as labelled blocks in the left column
    \def\nc@datestore{}
    \ifnc@briefkopf
    \nc@nolinkstrue\nc@headreducedtrue
    \renewcommand\cvletterhead{%
      \sbox\nc@lhbox{\parbox[t]{\linewidth}{\vspace{0pt}\cvheader}}%
      \noindent\usebox\nc@lhbox\par}
    \else
    \renewcommand\cvletterhead{%
      \sbox\nc@lhbox{\parbox[t]{\linewidth}{\vspace{0pt}\nc@headmiddle
        \ifnc@briefschmal\vspace{3pt}{\nc@fmeta\hypersetup{urlcolor=inkmuted}\def\cvcomma{, }\def\cvsep{\quad}%
          \nc@firsttrue\nc@item{adresse}\nc@item{telefon}\nc@item{email}\nc@item{web}\par}\fi
        \ifnc@spine\else\vspace{6pt}\nc@fullrule\fi}}%
      \noindent\usebox\nc@lhbox\par
      \ifnc@briefschmal\else
      % sender block: label on the height of the sender line in the window (54.5 mm)
      \AddToShipoutPictureFG*{\AtPageUpperLeft{\put(\LenToUnit{\nc@marginleft},\LenToUnit{-54.5mm}){%
        \parbox[t]{\nc@colL}{\ifnc@spine\RaggedLeft\else\nc@RaggedRightLoose\fi
          \ifnc@spine\else\vspace*{-12pt}\nc@colrule\fi
          \leavevmode\nc@labeltext{\ifnc@en Sender\else Absender\fi}\nc@nodeafter\par\vspace{3pt}%
          {\nc@fmeta\hypersetup{urlcolor=inkmuted}\def\cvcomma{\newline}%
           \nc@iffield{adresse}{\nc@get{adresse}\par}{}%
           \nc@iffield{telefon}{\nc@get{telefon}\par}{}%
           \nc@iffield{email}{\nc@get{email}\par}{}%
           \nc@iffield{web}{\nc@get{web}\par}{}}}}}}\fi}
    \fi
    \renewcommand\cvplacedate[1]{\gdef\nc@datestore{#1}}
    \renewcommand\cvsubject[1]{%
      \ifnc@spine\else\vspace*{-6.5pt}\nc@fullrule\fi
      {\leavevmode\nc@leftcol{\nc@labeltext{\ifnc@betreffrubrik\ifnc@en Application\else Bewerbung\fi\else\ifnc@en Date\else Datum\fi\fi}\par\vspace{2pt}%
         {\nc@fmeta\ifnc@spine\ifnc@briefschmal\def\cvcomma{,\newline}\fi\ifnc@betreffrubrik\def\cvcomma{,\newline}\fi\else\def\cvcomma{,\newline}\fi\nc@datestore\par}}\nc@node
       \nc@textsemibold\fontsize{10.5}{14.5}\selectfont\color{ink}#1\par}\vspace{\ifnc@luft 10pt\else 8pt\fi}}
    \renewcommand\cvclosing[3]{\gdef\nc@clg{#1}\gdef\nc@clsig{#2}\gdef\nc@clname{#3}\global\nc@closingpendingtrue}
    \newcommand\nc@printclosing[1]{%
      \ifnc@beilagengruss
      \par\vspace{8pt}{\leavevmode\ifx\relax#1\relax\else
         \nc@leftcol{\nc@labeltext{\ifnc@en Enclosures\else Beilagen\fi}\par\vspace{2pt}%
           {\nc@fmeta\def\cvlistsep{\newline}#1\par}}\nc@node\fi
       \rmfamily\nc@sizeletter\color{inksoft}\nc@clg\par}%
      \ifx\nc@clsig\@empty\vspace{28pt}\else\vspace{4pt}\includegraphics[height=11.5mm]{\nc@clsig}\par\vspace{3pt}\fi
      {\rmfamily\nc@sizeletter\color{ink}\nc@clname\par}%
      \else
      \par\vspace{8pt}{\rmfamily\nc@sizeletter\color{inksoft}\nc@clg\par}%
      \ifx\nc@clsig\@empty\vspace{26pt}\else\vspace{2pt}\includegraphics[height=11mm]{\nc@clsig}\par\vspace{0pt}\fi
      {\leavevmode\ifx\relax#1\relax\else
         \nc@leftcol{\nc@labeltext{\ifnc@en Enclosures\else Beilagen\fi}\par\vspace{2pt}%
           {\nc@fmeta\def\cvlistsep{\newline}#1\par}}\nc@node\fi
       \rmfamily\nc@sizeletter\color{ink}\nc@clname\par}%
      % the list in the column reaches below the name line: reserve its depth so TeX counts it
      \ifx\relax#1\relax\else\sbox\nc@lcbox{\parbox[t]{\nc@colL}{\leavevmode\nc@labeltext{x}\par\vspace{2pt}%
        {\nc@fmeta\def\cvlistsep{\newline}#1\par}}}\nointerlineskip\vspace{\dp\nc@lcbox}\fi
      \fi
      \global\nc@closingpendingfalse}
    \ifnc@randnotizen\renewcommand\cvmargin[1]{\nc@leftcol{{\nc@fmeta #1}}\nc@node}\fi
    \renewcommand\cvenclosures[2]{\nc@printclosing{#2}}
    \AtEndDocument{\ifnc@closingpending\nc@printclosing{}\fi}
  \fi
\fi

\ifnc@deck
  % cover items: \cvcoveritem{number}{title}{description}
  \newcommand\cvcoverstart[3]{% kicker, target role, company
    \thispagestyle{fancy}%
    \ifnum\nc@var=3 \nc@headreducedtrue\fi
    \cvheader
    \vspace*{\fill}%
    \cvsection{#1}%
    {\leavevmode\nc@emitlabel\nc@textsemibold\fontsize{24}{29}\selectfont\color{ink}#2\par}%
    \vspace{5pt}%
    {\leavevmode\rmfamily\fontsize{13}{17}\selectfont\color{inksoft}#3\par}%
    \vspace*{\fill}%
    \ifnum\nc@var=3\else\setlength\nc@keyw{10mm}\cvsection{\ifnc@en Contents\else Inhalt\fi}\fi}
  \newcommand\cvcoveritem[3]{%
    \ifnum\nc@var=3
      % fixed pitch per item (rueckgrat 18 mm, bplus 16 mm), whether or not it has a description
      \par\ifnc@spine\else\nc@fullrule\fi
      \vbox to \ifnc@spine 18mm\else 13mm\fi{%
        {\leavevmode\nc@leftcol{\nc@fmeta #1}\nc@node\nc@textsemibold\fontsize{10}{13.2}\selectfont\color{ink}#2\par}%
        \ifx\relax#3\relax\else{\leavevmode\nc@fbody #3\par}\fi\vss}%
    \else
      \cvrow{#1}{#2}%
    \fi}
  \newcommand\cvcoverend{\par\vspace*{18mm}} % contents anchored low, last line at about 258 mm
\fi
\fi

\endinput
