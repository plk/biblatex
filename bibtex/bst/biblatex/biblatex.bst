% Copyright (c) 2006-2011 Philipp Lehman.
%
% Permission is granted to copy, distribute and/or modify this
% software under the terms of the LaTeX Project Public License
% (LPPL), version 1.3.
%
% The LPPL maintenance status of this software is
% 'author-maintained'.
%
% This software is provided 'as is', without warranty of any kind,
% either expressed or implied, including, but not limited to, the
% implied warranties of merchantability and fitness for a
% particular purpose.

% -------------------------------------------------------------------
% Initialization
% -------------------------------------------------------------------

ENTRY {
    % special fields
    entryset
    entrysubtype
    execute
    hyphenation
    keywords
    label
    langid
    langidopts
    options
    presort
    shorthand
    sortkey
    sortname
    sorttitle
    sortyear
    xref
    % data fields
    abstract
    addendum
    address
    afterword
    annotation
    annote
    annotator
    author
    authortype
    bookauthor
    booksubtitle
    booktitle
    booktitleaddon
    chapter
    commentator
    date
    doi
    edition
    editor
    editora
    editorb
    editorc
    editortype
    editoratype
    editorbtype
    editorctype
    eid
    eprint
    eprintclass
    eprinttype
    eventdate
    eventtitle
    eventtitleaddon
    file
    foreword
    gender
    howpublished
    indexsorttitle
    indextitle
    institution
    introduction
    isan
    isbn
    ismn
    isrn
    issn
    issue
    issuetitle
    issuesubtitle
    iswc
    journal
    journaltitle
    journalsubtitle
    language
    library
    location
    bookpagination
    mainsubtitle
    maintitle
    maintitleaddon
    month
    nameaddon
    note
    number
    organization
    origlanguage
    origlocation
    origpublisher
    origtitle
    origdate
    pages
    pagetotal
    pagination
    part
    pdf
    pubstate
    reprinttitle
    holder
    publisher
    school
    series
    shortauthor
    shorteditor
    shorthandintro
    shortjournal
    shortseries
    shorttitle
    subtitle
    title
    titleaddon
    translator
    type
    url
    urldate
    venue
    version
    volume
    volumes
    year
    % aliases
    archiveprefix
    primaryclass
    % custom fields
    namea
    nameb
    namec
    nameatype
    namebtype
    namectype
    lista
    listb
    listc
    listd
    liste
    listf
    usera
    userb
    userc
    userd
    usere
    userf
    verba
    verbb
    verbc
  }
  { skipbib skiplos skiplab useauthor useeditor usetranslator useprefix singletitle }
  { entryoptions labelhash namehash fullhash dateyear dateendyear extrayear labelalpha extraalpha 
    sortinit label.name label.year sortkey.nosort sortkey.name sortkey.year
    sortkey.title sortkey.alpha sort.year sort.alph warningmsg }

INTEGERS { ctrl.debug ctrl.bibtex8 ctrl.maxline ctrl.sorting ctrl.cssort ctrl.sortlos 
           ctrl.maxnames ctrl.minnames ctrl.useauthor ctrl.useeditor ctrl.usetranslator
           ctrl.useprefix ctrl.terseinits ctrl.labelalpha ctrl.singletitle
           ctrl.labeldate citecount 
           tempctra tempctrb tempctrc resvctra resvctrb resvctrc
           last.extra.num }

STRINGS  { ctrl.alphaothers templist tempstrga tempstrgb resvstrga
           last.name last.hash last.year last.extra }

FUNCTION {initialize} {
  "$Revision: 2.8 $"
  #12 entry.max$ substring$
  #-3 entry.max$ substring$
  "Biblatex version: " swap$ * top$
   #0  'ctrl.terseinits :=
   #0  'ctrl.debug :=
   #0  'ctrl.labelalpha :=
   #0  'ctrl.labeldate :=
   #0  'ctrl.singletitle :=
   #0  'ctrl.sorting :=
   #0  'ctrl.sortlos :=
   #1  'ctrl.useauthor :=
   #1  'ctrl.useeditor :=
   #0  'ctrl.usetranslator :=
   #0  'ctrl.useprefix :=
   #1  'ctrl.minnames :=
  #99  'ctrl.maxnames :=
  #79  'ctrl.maxline :=
  "+"  'ctrl.alphaothers :=
}

% -------------------------------------------------------------------
% Strings
% -------------------------------------------------------------------

MACRO {jan} { "01" }
MACRO {feb} { "02" }
MACRO {mar} { "03" }
MACRO {apr} { "04" }
MACRO {may} { "05" }
MACRO {jun} { "06" }
MACRO {jul} { "07" }
MACRO {aug} { "08" }
MACRO {sep} { "09" }
MACRO {oct} { "10" }
MACRO {nov} { "11" }
MACRO {dec} { "12" }

% -------------------------------------------------------------------
% Generic functions
% -------------------------------------------------------------------

FUNCTION {and} {
    'skip$
    { pop$ #0 }
  if$
}

FUNCTION {or} {
    { pop$ #1 }
    'skip$
  if$
}

FUNCTION {not} {
    { #0 }
    { #1 }
  if$
}

FUNCTION {ctrl:control} {
  type$ "control" =
}

FUNCTION {ctrl:set} {
  type$ "set" =
}

FUNCTION {ctrl:skiplos} {
  ctrl:control skiplos or
  ctrl:set not
  and
}

FUNCTION {ctrl:skiplab} {
  ctrl:control skiplab or
  ctrl:set not
  and
}

FUNCTION {ctrl:labelalpha} {
  ctrl.labelalpha ctrl:skiplab not and
  shorthand empty$
  and
}

FUNCTION {ctrl:labeldate} {
  ctrl.labeldate
  ctrl:skiplab not
  and
}

FUNCTION {wrap:braces} {
  duplicate$ empty$
    { pop$ "{}" }
    { "{" swap$ * "}" * }
  if$
}

FUNCTION {delimiter.1} {
  ctrl.bibtex8
    { "0" }
    { "    " }
  if$
}

FUNCTION {delimiter.2} {
  ctrl.bibtex8
    { "1" }
    { "   " }
  if$
}

FUNCTION {delimiter.3} {
  ctrl.bibtex8
    { "2" }
    { "  " }
  if$
}

FUNCTION {open.ended} {
  "9999"
}

FUNCTION {maxline} {
  duplicate$ empty$
    'skip$
    { #1 ctrl.maxline substring$ }
  if$
}

FUNCTION {truncate} {
  duplicate$ empty$
    { pop$ "" }
    { #1 entry.max$ substring$ }
  if$
}

FUNCTION {purify} {
  duplicate$ empty$
    { pop$ "" }
    { purify$
      ctrl.bibtex8
      ctrl.cssort
      and
        'skip$
        { "l" change.case$ }
      if$
      truncate
    }
  if$
}

FUNCTION {normalize} {
  duplicate$ empty$
    { pop$ "" }
    { ctrl.bibtex8
      ctrl.cssort
      and
        'skip$
        { "l" change.case$ }
      if$
      truncate
    }
  if$
}

FUNCTION {enquote} {
  "'" swap$ * "'" *
}

FUNCTION {bol.to.int} {
  "true" =
    { #1 }
    { #0 }
  if$
}

FUNCTION {str.to.int} {
  'resvstrga :=
  resvstrga text.length$ 'resvctra :=
  #1 'resvctrb :=
  #0
  { resvctrb resvctra > not }
    { 'resvctrc :=
      resvstrga resvctrb #1 substring$
      chr.to.int$ "0" chr.to.int$ -
      #0
      { resvctrc #0 > }
        { resvctrc #1 - 'resvctrc :=
          #10 +
        }
      while$
      +
      resvctrb #1 + 'resvctrb :=
    }
  while$
}

FUNCTION {andothers} {
  duplicate$ num.names$ "{ff}{vv}{ll}{jj}" format.name$ "others" =
}

FUNCTION {push} {
  duplicate$ empty$
    { pop$ "" }
    { truncate }
  if$
}

FUNCTION {push:cite} {
  cite$ empty$
    { "Missing citation key" warning$ "" }
    { cite$ }
  if$
}

FUNCTION {push:presort} {
  presort empty$
    { "mm" }
    { presort purify
      #1 #2 substring$
      "l" change.case$ }
  if$
}

FUNCTION {push:fullname} {
  author empty$ not
  useauthor
  and
    { author }
    { editor empty$ not
      useeditor
      and
        { editor }
        { translator empty$ not
          usetranslator
          and
            { translator }
            { "" }
          if$
        }
      if$
    }
  if$
}

FUNCTION {push:shortname:translator} {
  translator empty$ not
  usetranslator
  and
    { translator }
    { "" }
  if$
}

FUNCTION {push:shortname:editor} {
  useeditor
    { shorteditor empty$
        { editor empty$
            { push:shortname:translator }
            { editor }
          if$
        }
        { shorteditor }
      if$
    }
    { push:shortname:translator }
  if$
}

FUNCTION {push:shortname} {
  useauthor
    { shortauthor empty$
        { author empty$
            { push:shortname:editor }
            { author }
          if$
        }
        { shortauthor }
      if$
    }
    { push:shortname:editor }
  if$
}

FUNCTION {push:sorttitle} {
  sorttitle empty$
    { title empty$
        { "" }
        { title }
      if$
    }
    { sorttitle }
  if$
  push
}

FUNCTION {shortname:hash} {
  'tempctrc :=
  'templist :=
  #1 'tempctra :=
  templist num.names$ 'tempctrb :=
  templist andothers
    { tempctrb #1 - 'tempctrb := }
    'skip$
  if$
  tempctrc #0 =
    { tempctrb 'tempctrc := }
    { tempctrb tempctrc >
        { ctrl.minnames 'tempctrc := }
        { ctrl.maxnames 'tempctrc := }
      if$
    }
  if$
  ""
  { tempctra tempctrc > not
    tempctrb #0 >
    and }
    { templist tempctra "{vv{}}{ll{}}{ff{}}{jj{}}" format.name$ *
      tempctra #1 + 'tempctra :=
      tempctrb #1 - 'tempctrb :=
    }
  while$
  templist andothers
  tempctrb #0 >
  or
    { "+" * }
    'skip$
  if$
}

FUNCTION {push:name:namehash} {
  push:shortname duplicate$ empty$
    { pop$ push:sorttitle duplicate$ empty$
        { pop$ push:cite purify }
        'skip$
      if$
    }
    { ctrl.maxnames shortname:hash }
  if$
}

FUNCTION {push:name:fullhash} {
  push:fullname duplicate$ empty$
    { pop$ push:sorttitle duplicate$ empty$
        { pop$ push:cite purify }
        'skip$
      if$
    }
    { #0 shortname:hash }
  if$
}

FUNCTION {check:sortname} {
  sortname empty$
    'skip$
    { pop$ sortname }
  if$
}

FUNCTION {warning} {
  "\item " swap$ * 
  warningmsg empty$
    'skip$
    { warningmsg " " * swap$ * }
  if$
  'warningmsg :=
}

FUNCTION {warning:invalid} {
  "Invalid format of field " swap$ enquote * warning
}

FUNCTION {warning:duplicate} {
  "Can't use " swap$ enquote * " + " * swap$ enquote * warning
}

FUNCTION {pad.number} {
  'tempctra :=
  duplicate$ empty$
    { pop$ "" }
    'skip$
  if$
  { duplicate$ text.length$ tempctra < }
    { "0" swap$ * }
  while$
}

FUNCTION {extract.number} {
  purify$ 'tempstrga :=
  ""
  { tempstrga empty$ not }
    { tempstrga #1 #1 substring$ chr.to.int$ duplicate$
      #47 > swap$
      #58 < and
        { tempstrga #1 #1 substring$ * }
        'skip$
      if$
      tempstrga #2 global.max$ substring$ 'tempstrga :=
    }
  while$
  #1 #9 substring$
}

FUNCTION {format.range}
{ 'tempstrga :=
  ""
  { tempstrga empty$ not }
    { tempstrga #1 #1 substring$ "-" =
      { "\bibrangedash " *
        tempstrga #2 global.max$ substring$ 'tempstrga :=
        { tempstrga #1 #1 substring$ "-" = }
          { tempstrga #2 global.max$ substring$ 'tempstrga := }
        while$
      }
      { tempstrga #1 #1 substring$ *
        tempstrga #2 global.max$ substring$ 'tempstrga :=
      }
      if$
    }
  while$
}

FUNCTION {is.number} {
  #1
  { #0 > }
    { duplicate$ #1 #1 substring$ chr.to.int$ 
      duplicate$ #47 >
      swap$      #58 <
      and
        { #2 global.max$ substring$
          duplicate$ empty$
            { #0 }
            { #1 }
          if$
        }
        { #0 }
      if$
    }
  while$
  empty$
}

FUNCTION {split.date:invalid} {
  #0 'tempctra :=
}

FUNCTION {split.date:check.day} {
  duplicate$ empty$
    'skip$
    { duplicate$ is.number
        { duplicate$ str.to.int
          duplicate$  #0 >
          swap$      #32 <
          and
            { duplicate$ text.length$ #2 <
                { "0" swap$ * }
                'skip$
              if$
            }
            { pop$ "" split.date:invalid }
          if$
        }
        { pop$ "" split.date:invalid }
      if$
    }
  if$
}

FUNCTION {split.date:check.month} {
  duplicate$ empty$
    'skip$
    { duplicate$ is.number
        { duplicate$ str.to.int
          duplicate$  #0 >
          swap$      #13 <
          and
            { duplicate$ text.length$ #2 <
                { "0" swap$ * }
                'skip$
              if$
            }
            { pop$ "" split.date:invalid }
          if$
        }
        { pop$ "" split.date:invalid }
      if$
    }
  if$
}

FUNCTION {split.date:check.year} {
  duplicate$ empty$
    'skip$
    { duplicate$ is.number
        { duplicate$ "0" =
            'skip$
            { duplicate$
              duplicate$ str.to.int #0 >
              swap$    text.length$ #5 <
              and
                'skip$
                { pop$ "" split.date:invalid }
              if$
            }
          if$
        }
        { pop$ "" split.date:invalid }
      if$
    }
  if$
}

FUNCTION {split.date:check.date} {
  duplicate$ empty$
    'skip$
    { duplicate$
      duplicate$ text.length$  #0 >
      swap$      text.length$ #11 <
      and
        'skip$
        { pop$ "" split.date:invalid }
      if$
    }
  if$
}

FUNCTION {split.date:check.range} {
  duplicate$ empty$
    'skip$
    { duplicate$
      duplicate$ text.length$  #0 >
      swap$      text.length$ #22 <
      and
        'skip$
        { pop$ "" split.date:invalid }
      if$
    }
  if$
}

FUNCTION {split.date:date:part} {
  'tempstrgb :=
  ""
  { tempstrgb #1 #1 substring$
    duplicate$ empty$
      { pop$ #0 }
      { "-" = not }
    if$
  }
    { tempstrgb #1 #1 substring$ *
      tempstrgb #2 global.max$ substring$ 'tempstrgb :=
    }
  while$
  tempstrgb #2 global.max$ substring$
}

FUNCTION {split.date:date} {
  duplicate$ empty$
    { pop$ "" "" "" }
    { split.date:date:part swap$ split.date:check.year  swap$
      split.date:date:part swap$ split.date:check.month swap$
      split.date:date:part pop$  split.date:check.day
    }
  if$
}

FUNCTION {split.date:range} {
  duplicate$ empty$
    { pop$ "" "" }
    { 'tempstrgb :=
      ""
      #0 'tempctrb :=
      { tempstrgb #1 #1 substring$
        duplicate$ empty$
          { pop$ #0 }
          { "/" =
              { #1 'tempctrb :=
                #0
              }
              { #1 }
            if$
          }
        if$
      }
        { tempstrgb #1 #1 substring$ *
          tempstrgb #2 global.max$ substring$ 'tempstrgb :=
        }
      while$
      split.date:check.date
      tempstrgb #2 global.max$ substring$
      duplicate$ empty$
      tempctrb #1 =
      and
        { pop$ open.ended }
        'skip$
      if$
      split.date:check.date
    }
  if$
}

FUNCTION {split.date} {
  duplicate$ empty$
    { pop$ pop$ "" "" "" "" "" "" }
    { swap$ 'templist :=
      #1 'tempctra :=
      split.date:check.range
      split.date:range swap$ 'tempstrga :=
      split.date:date tempstrga
      split.date:date
      tempctra
        'skip$
        { pop$ pop$ pop$ pop$ pop$ pop$ "" "" "" "" "" "" 
          templist warning:invalid
        }
      if$
    }
  if$
}

% -------------------------------------------------------------------
% Sorting
% -------------------------------------------------------------------

FUNCTION {sortkey:name:format} {
  'templist :=
  #1 'tempctra :=
  templist num.names$ 'tempctrb :=
  templist andothers
    { tempctrb #1 - 'tempctrb := }
    'skip$
  if$
  tempctrb ctrl.maxnames >
    { ctrl.minnames 'tempctrc := }
    { ctrl.maxnames 'tempctrc := }
  if$
  ""
  { duplicate$ text.length$ entry.max$ #50 - <
    tempctra tempctrc > not and
    tempctrb #0 > and
    }
    { useprefix
        { templist tempctra "{vv}" format.name$
          duplicate$ empty$
            { pop$ "" }
            { "u" change.case$ "t" change.case$ 
              delimiter.3 * }
          if$
          templist tempctra
          "{ll}{" delimiter.3 *
          "ff}{"  delimiter.3 * *
          "jj}" *
          format.name$ *
        }
        { templist tempctra
          "{ll}{" delimiter.3 *
          "ff}{"  delimiter.3 * *
          "vv}{"  delimiter.3 * *
          "jj}" *
          format.name$ }
      if$
      tempctra #1 >
        { delimiter.2 swap$ * }
        'skip$
      if$
      *
      tempctra #1 + 'tempctra :=
      tempctrb #1 - 'tempctrb :=
    }
  while$
  templist andothers
  tempctrb #0 >
  or
    { delimiter.2 * "zzzz" * }
    'skip$
  if$
}

FUNCTION {sortkey:init:label} {
  push:shortname duplicate$ empty$
    { pop$ push:sorttitle }
    { check:sortname sortkey:name:format }
  if$
  purify 'sortkey.name :=
  sortyear empty$
    { dateyear
      dateendyear empty$
        'skip$
        { dateyear dateendyear =
            'skip$
            { dateendyear open.ended =
                'skip$
                { "-" * dateendyear * }
              if$
            }
          if$
        }
      if$
    }
    { sortyear }
  if$
  purify 'sortkey.year :=
  push:sorttitle purify 'sortkey.title :=
}

FUNCTION {sortkey:init:main} {
  push:fullname duplicate$ empty$
    { pop$ push:sorttitle }
    { check:sortname sortkey:name:format }
  if$
  purify 'sortkey.name :=
}

FUNCTION {sortkey:main:string} {
  duplicate$ #1 =
    { pop$
      sortkey.name    delimiter.1 *
      sortkey.title * delimiter.1 *
      sortkey.year  * delimiter.1 *
      volume purify #4 pad.number * delimiter.1 *
    }
    { duplicate$ #2 =
        { pop$
          sortkey.name    delimiter.1 *
          sortkey.year  * delimiter.1 *
          sortkey.title * delimiter.1 *
          volume purify #4 pad.number * delimiter.1 *
        }
        { #3 =
            { sortkey.name   delimiter.1 *
              sortkey.year * delimiter.1 *
              volume purify #4 pad.number * delimiter.1 *
              sortkey.title *
            }
            { "" }
          if$
        }
      if$
    }
  if$
}

FUNCTION {sortkey:main:date:year} {
  duplicate$ empty$
    { pop$ }
    { extract.number #1 #4 substring$
      duplicate$ empty$
        { pop$ }
        { swap$ pop$ }
      if$
    }
  if$
}

FUNCTION {sortkey:main:date} {
  duplicate$ #1 =
    { pop$
      sortyear empty$
        { "9999" dateyear sortkey:main:date:year }
        { sortyear purify }
      if$
    }
    { #2 =
        { sortyear empty$
            { "0" dateyear sortkey:main:date:year }
            { sortyear purify }
          if$
          str.to.int #9999 swap$ - int.to.str$
        }
        { "" }
      if$
    }
  if$
  sortkey.name  * delimiter.1 *
  sortkey.title * delimiter.1 *
  volume purify #4 pad.number * delimiter.1 *
}

FUNCTION {sortkey:main} {
  ctrl.sorting #0 =
    { sortkey.nosort }
    { sortkey:init:main
      ""
      ctrl.sorting #10 <
        { sortkey empty$
            { ctrl.sorting sortkey:main:string }
            { sortkey }
          if$
        }
        { ctrl.sorting #20 <
            { shorthand empty$
                { sortkey.alpha * }
                { shorthand purify * }
              if$
              delimiter.1 *
              ctrl.sorting #10 - sortkey:main:string
            }
            { ctrl.sorting #30 <
                { sortkey empty$
                    { ctrl.sorting #20 - sortkey:main:date }
                    { sortkey }
                  if$
                }
                { push:cite purify }
              if$
            }
          if$
        }
      if$
      *
      duplicate$ #1 text.prefix$ "u" change.case$ 'sortinit :=
      push:presort delimiter.1 * swap$ *
    }
  if$
  truncate
}

% -------------------------------------------------------------------
% Output
% -------------------------------------------------------------------

FUNCTION {output:indent:field} {
  duplicate$ empty$
    'skip$
    { "  " swap$ * write$ newline$ }
  if$
}

FUNCTION {output:indent:subfield} {
  duplicate$ empty$
    'skip$
    { "    " swap$ * write$ newline$ }
  if$
}

FUNCTION {output:write:field} {
  duplicate$ empty$
    { pop$ pop$ }
    { swap$ "\field" swap$ wrap:braces *
      swap$ wrap:braces * output:indent:field }
  if$
}

FUNCTION {output:write:year} {
  duplicate$ empty$
    { pop$ pop$ }
    { duplicate$ open.ended =
        { pop$ "" }
        'skip$
      if$
      swap$ "\field" swap$ wrap:braces *
      swap$ wrap:braces * output:indent:field 
      }
  if$
}

FUNCTION {output:write:multi} {
  duplicate$ empty$
    { pop$ pop$ }
    { swap$ "\field" swap$ wrap:braces * "{%" * output:indent:field
      "%" * output:indent:field
      "}"  output:indent:field
    }
  if$
}

FUNCTION {output:write:bool} {
  #0 >
    { "\true"  }
    { "\false" }
  if$
  swap$ wrap:braces * output:indent:field
}

FUNCTION {output:write:count} {
  int.to.str$ swap$ "\count" swap$ wrap:braces *
  swap$ wrap:braces * output:indent:field
}

FUNCTION {output:write:string} {
  duplicate$ empty$
    { pop$ pop$ }
    { swap$ "\strng" swap$ wrap:braces *
      swap$ wrap:braces * output:indent:field }
  if$
}

FUNCTION {output:write:range} {
  duplicate$ empty$
    { pop$ pop$ }
    { format.range output:write:field }
  if$
}

FUNCTION {output:write:number} {
  duplicate$ empty$
    { pop$ pop$ }
    { duplicate$ is.number
        'skip$
        { swap$ warning:invalid "" }
      if$
      output:write:field
    }
  if$
}

FUNCTION {output:write:gender} {
  duplicate$ empty$
    { pop$ pop$ }
    { 'tempstrga :=
      tempstrga "sf" =
      tempstrga "sm" = or
      tempstrga "sn" = or
      tempstrga "pf" = or
      tempstrga "pm" = or
      tempstrga "pn" = or
      tempstrga "pp" = or
        { tempstrga output:write:field }
        { warning:invalid }
      if$
    }
  if$
}

FUNCTION {output:write:verb} {
  duplicate$ empty$
    { pop$ pop$ }
    { 'tempstrga :=
      "\verb" swap$ wrap:braces * output:indent:field
      { tempstrga empty$ not }
        { "\verb " tempstrga #1 ctrl.maxline #8 - substring$ * output:indent:field
          tempstrga ctrl.maxline #7 - global.max$ substring$ 'tempstrga :=
        }
      while$
      "\endverb" output:indent:field }
  if$
}

FUNCTION {output:write:name:last} {
  templist tempctra "{ll}" format.name$
  duplicate$ 'tempstrga :=
  wrap:braces
  templist tempctra
  ctrl.terseinits
    { "{l{}}" format.name$ }
    { "{l.}"  format.name$
      duplicate$ tempstrga "." * =
        { duplicate$ text.length$ #1 - text.prefix$ }
        'skip$
      if$
    }
  if$
  wrap:braces *
}

FUNCTION {output:write:name:first} {
  templist tempctra "{ff}" format.name$
  duplicate$ 'tempstrga :=
  wrap:braces
  templist tempctra
  ctrl.terseinits
    { "{f{}}" format.name$ }
    { "{f.}"  format.name$
      duplicate$ tempstrga "." * =
        { duplicate$ text.length$ #1 - text.prefix$ }
        'skip$
      if$
    }
  if$
  wrap:braces *
}

FUNCTION {output:write:name:prefix} {
  templist tempctra "{vv}" format.name$
  duplicate$ 'tempstrga :=
  duplicate$ duplicate$ text.length$ duplicate$ substring$ "'" =
    { #1 'tempctrc := }
    { #0 'tempctrc := }
  if$
  wrap:braces
  templist tempctra
  ctrl.terseinits
    { "{v{}}" format.name$ }
    { "{v.}"  format.name$
      tempctrc
        { duplicate$ text.length$ #1 - text.prefix$ "'" * }
        { duplicate$ tempstrga "." * =
            { duplicate$ text.length$ #1 - text.prefix$ }
            'skip$
          if$
        }
      if$
    }
  if$
  wrap:braces *
}

FUNCTION {output:write:name:suffix} {
  templist tempctra "{jj}" format.name$
  duplicate$ 'tempstrga :=
  wrap:braces
  templist tempctra
  ctrl.terseinits
    { "{j{}}" format.name$ }
    { "{j.}"  format.name$
      duplicate$ tempstrga "." * =
        { duplicate$ text.length$ #1 - text.prefix$ }
        'skip$
      if$
    }
  if$
  wrap:braces *
}

FUNCTION {output:write:name} {
  duplicate$ empty$
    { pop$ pop$ }
    { 'templist :=
      'tempstrga :=
      #1 'tempctra :=
      templist num.names$ 'tempctrb :=
      templist andothers
        { tempctrb #1 - 'tempctrb :=
          "more" tempstrga * #1 output:write:bool
        }
        'skip$
      if$
      "\name" tempstrga wrap:braces *
      tempctrb int.to.str$ wrap:braces *
      "" wrap:braces *
      "{%" * output:indent:field
      { tempctrb #0 > }
        { "{{}%" output:indent:subfield
          " " output:write:name:last   * "%"  * output:indent:subfield
	  " " output:write:name:first  * "%"  * output:indent:subfield
          " " output:write:name:prefix * "%"  * output:indent:subfield
          " " output:write:name:suffix * "}%" * output:indent:subfield
          tempctra #1 + 'tempctra :=
          tempctrb #1 - 'tempctrb :=
        }
      while$
      "}" output:indent:field
    }
  if$
}

FUNCTION {output:write:list} {
  duplicate$ empty$
    { pop$ pop$ }
    { 'templist :=
      'tempstrga :=
      templist num.names$ 'tempctra :=
      templist andothers
        { tempctra #1 - 'tempctra :=
          "more" tempstrga * #1 output:write:bool
        }
        'skip$
      if$
      "\list" tempstrga wrap:braces *
      tempctra int.to.str$ wrap:braces *
      "{%" * output:indent:field
      #1 'tempctra :=
      #1 'tempctrb :=
      #0 'tempctrc :=
      { templist purify tempctrb global.max$ substring$ num.names$ #0 > }
        { templist tempctrb #1 substring$ "{" =
	    { tempctrc #1 + 'tempctrc :=
	      tempctrb #1 + 'tempctrb := }
	    { templist tempctrb #1 substring$ "}" =
		{ tempctrc #1 - 'tempctrc :=
		  tempctrb #1 + 'tempctrb := }
		{ templist tempctrb #5 substring$
        	  duplicate$ " AND " =
        	  swap$      " and " =
        	  or
		  tempctrc #1 <
		  and
        	    { templist tempctra tempctrb tempctra - substring$
        	      wrap:braces "%" * output:indent:subfield
        	      tempctrb #5 + duplicate$
        	      'tempctra :=
        	      'tempctrb :=
        	    }
        	    { tempctrb #1 + 'tempctrb := }
        	  if$
		}
              if$
	    }
          if$
        }
      while$
      templist tempctra global.max$ substring$
      duplicate$ "others" =
        { pop$ }
        { wrap:braces "%" * output:indent:subfield }
      if$
      "}" output:indent:field
    }
  if$
}

FUNCTION {output:specials} {
  entryset empty$
    'skip$
    { ctrl:set
        { "\set"   }
        { "\inset" }
      if$
      entryset wrap:braces * output:indent:field 
    }
  if$
  xref empty$
    'skip$
    { "\xref" xref wrap:braces * output:indent:field }
  if$
  keywords empty$
    'skip$
    { "\keyw" keywords wrap:braces * output:indent:field }
  if$
  "entrysubtype"    entrysubtype    output:write:field
  "crossref"        crossref        output:write:string
  "execute"         execute         output:write:field
  "namehash"        namehash        output:write:string
  "fullhash"        fullhash        output:write:string
  "gender"          gender          output:write:gender
  "shorthand"       shorthand       output:write:field
  shorthand empty$
    { label }
    { shorthand }
  if$
  "label"           swap$           output:write:field
  ctrl.labelalpha
    { "labelalpha"  labelalpha      output:write:field
      "extraalpha"  extraalpha      output:write:field
    }
    'skip$
  if$
  ctrl:labeldate
  dateyear empty$ not
  and
    { "labelyear"
      dateyear
      dateendyear empty$
        'skip$
        { dateyear dateendyear =
            'skip$
            { dateendyear open.ended =
                'skip$
                { "\bibdatedash " * dateendyear * }
              if$
            }
          if$
        }
      if$
      output:write:field
      "extrayear"   extrayear       output:write:field
    }
    'skip$
  if$
  "sortinit"        sortinit        output:write:field
  singletitle
    { "singletitle" #1 output:write:bool }
    'skip$
  if$
}

FUNCTION {output:names} {
  "author"          author          output:write:name
  "authortype"      authortype      output:write:field
  "shortauthor"     shortauthor     output:write:name
  "bookauthor"      bookauthor      output:write:name
  "editor"          editor          output:write:name
  "editortype"      editortype      output:write:field
  "editora"         editora         output:write:name
  "editoratype"     editoratype     output:write:field
  "editorb"         editorb         output:write:name
  "editorbtype"     editorbtype     output:write:field
  "editorc"         editorc         output:write:name
  "editorctype"     editorctype     output:write:field
  "shorteditor"     shorteditor     output:write:name
  "translator"      translator      output:write:name
  "annotator"       annotator       output:write:name
  "commentator"     commentator     output:write:name
  "introduction"    introduction    output:write:name
  "foreword"        foreword        output:write:name
  "afterword"       afterword       output:write:name
  "holder"          holder          output:write:name
}

FUNCTION {output:lists} {
  "language"        language        output:write:list
  "organization"    organization    output:write:list
  "origlocation"    origlocation    output:write:list
  "origpublisher"   origpublisher   output:write:list
  "publisher"       publisher       output:write:list
}

FUNCTION {output:fields.1} {
  "abstract"        abstract        output:write:multi
  "addendum"        addendum        output:write:field
  "bookpagination"  bookpagination  output:write:field
  "booksubtitle"    booksubtitle    output:write:field
  "booktitleaddon"  booktitleaddon  output:write:field
  "booktitle"       booktitle       output:write:field
  "chapter"         chapter         output:write:field
  "doi"             doi             output:write:verb
  "edition"         edition         output:write:field
  "eid"             eid             output:write:field
  "eprint"          eprint          output:write:verb
  "eventtitle"      eventtitle      output:write:field
  "eventtitleaddon" eventtitleaddon output:write:field
  "howpublished"    howpublished    output:write:field
  "indexsorttitle"  indexsorttitle  output:write:field
  "indextitle"      indextitle      output:write:field
  "isan"            isan            output:write:field
  "isbn"            isbn            output:write:field
  "ismn"            ismn            output:write:field
}

FUNCTION {output:fields.2} {
  "isrn"            isrn            output:write:field
  "issn"            issn            output:write:field
  "issue"           issue           output:write:field
  "issuesubtitle"   issuesubtitle   output:write:field
  "issuetitle"      issuetitle      output:write:field
  "iswc"            iswc            output:write:field
  "journalsubtitle" journalsubtitle output:write:field
  "langidopts"      langidopts      output:write:field
  "library"         library         output:write:field
  "mainsubtitle"    mainsubtitle    output:write:field
  "maintitleaddon"  maintitleaddon  output:write:field
  "maintitle"       maintitle       output:write:field
  "nameaddon"       nameaddon       output:write:field
  "note"            note            output:write:field
  "number"          number          output:write:field
  "origlanguage"    origlanguage    output:write:field
  "origtitle"       origtitle       output:write:field
  "pages"           pages           output:write:range
  "pagetotal"       pagetotal       output:write:range
  "pagination"      pagination      output:write:field
  "part"            part            output:write:range
}

FUNCTION {output:fields.3} {
  "pubstate"        pubstate        output:write:field
  "reprinttitle"    reprinttitle    output:write:field
  "series"          series          output:write:field
  "shorthandintro"  shorthandintro  output:write:field
  "shortjournal"    shortjournal    output:write:field
  "shortseries"     shortseries     output:write:field
  "shorttitle"      shorttitle      output:write:field
  "subtitle"        subtitle        output:write:field
  "titleaddon"      titleaddon      output:write:field
  "title"           title           output:write:field
  "url"             url             output:write:verb
  "venue"           venue           output:write:field
  "version"         version         output:write:field
  "volumes"         volumes         output:write:field
  "volume"          volume          output:write:field
}

FUNCTION {output:dates.1} {
  "date" date split.date
  "day"      swap$ output:write:field
  duplicate$ empty$
    { month empty$
        'skip$
        { month is.number
            { month str.to.int
              duplicate$  #0 >
              swap$      #13 <
              and
                { pop$ month #2 pad.number  }
                { "month" warning:invalid }
              if$
            }
            { "month" warning:invalid }
          if$
        }
      if$
    }
    { month empty$
        'skip$
        { "month" "date" warning:duplicate }
      if$
    }
  if$
  "month"    swap$ output:write:field
  duplicate$ empty$
    { year empty$
        'skip$
        { pop$ year }
      if$
    }
    { year empty$
        'skip$
        { "year" "date" warning:duplicate }
      if$
    }
  if$
  "year"     swap$ output:write:field
  "endday"   swap$ output:write:field
  "endmonth" swap$ output:write:field
  "endyear"  swap$ output:write:year
}

FUNCTION {output:dates.2} {
  "origdate" origdate split.date
  "origday"       swap$ output:write:field
  "origmonth"     swap$ output:write:field
  "origyear"      swap$ output:write:field
  "origendday"    swap$ output:write:field
  "origendmonth"  swap$ output:write:field
  "origendyear"   swap$ output:write:year
  "eventdate" eventdate split.date
  "eventday"      swap$ output:write:field
  "eventmonth"    swap$ output:write:field
  "eventyear"     swap$ output:write:field
  "eventendday"   swap$ output:write:field
  "eventendmonth" swap$ output:write:field
  "eventendyear"  swap$ output:write:year
  "urldate" urldate split.date
  "urlday"        swap$ output:write:field
  "urlmonth"      swap$ output:write:field
  "urlyear"       swap$ output:write:field
  "urlendday"     swap$ output:write:field
  "urlendmonth"   swap$ output:write:field
  "urlendyear"    swap$ output:write:year
}

FUNCTION {output:user} {
  "namea"           namea           output:write:name
  "nameatype"       nameatype       output:write:field
  "nameb"           nameb           output:write:name
  "namebtype"       namebtype       output:write:field
  "namec"           namec           output:write:name
  "namectype"       namectype       output:write:field
  "lista"           lista           output:write:list
  "listb"           listb           output:write:list
  "listc"           listc           output:write:list
  "listd"           listd           output:write:list
  "liste"           liste           output:write:list
  "listf"           listf           output:write:list
  "usera"           usera           output:write:field
  "userb"           userb           output:write:field
  "userc"           userc           output:write:field
  "userd"           userd           output:write:field
  "usere"           usere           output:write:field
  "userf"           userf           output:write:field
  "verba"           verba           output:write:verb
  "verbb"           verbb           output:write:verb
  "verbc"           verbc           output:write:verb
}

FUNCTION {output:warning} {
  warningmsg empty$
    'skip$
    { "\warn" warningmsg wrap:braces * output:indent:field }
  if$
}

FUNCTION {output:compat.1} {
  "langid" langid
  duplicate$ empty$
    { pop$ hyphenation }
    { hyphenation empty$
        'skip$
        { "hyphenation" "langid" warning:duplicate }
      if$
    }
  if$
  output:write:field 
  "location" location
  duplicate$ empty$
    { pop$ address }
    { address empty$
        'skip$
        { "address" "location" warning:duplicate }
      if$
    }
  if$
  output:write:list
  "institution" institution
  duplicate$ empty$
    { pop$ school }
    { school empty$
        'skip$
        { "school" "institution" warning:duplicate }
      if$
    }
  if$
  output:write:list
  "file" file
  duplicate$ empty$
    { pop$ pdf }
    { pdf empty$
        'skip$
        { "pdf" "file" warning:duplicate }
      if$
    }
  if$
  output:write:verb
}

FUNCTION {output:compat.2} {
  "type" type
  duplicate$ empty$
    { type$ "patent"        =
      type$ "techreport"    = or
      type$ "phdthesis"     = or
        { pop$ type$ }
        { type$ "mastersthesis" =
            { pop$ "mathesis" }
            'skip$
          if$
        }
      if$
    }
    'skip$
  if$
  output:write:field
  "journaltitle" journaltitle
  duplicate$ empty$
    { pop$ journal }
    { journal empty$
        'skip$
        { "journal" "journaltitle" warning:duplicate }
      if$
    }
  if$
  output:write:field
  "annotation" annotation
  duplicate$ empty$
    { pop$ annote }
    { annote empty$
        'skip$
        { "annote" "annotation" warning:duplicate }
      if$
    }
  if$
  output:write:multi
}

FUNCTION {output:compat.3} {
  "eprinttype" eprinttype
  duplicate$ empty$
    { pop$ archiveprefix }
    { archiveprefix empty$
        'skip$
        { "archiveprefix" "eprinttype" warning:duplicate }
      if$
    }
  if$
  output:write:field
  "eprintclass" eprintclass
  duplicate$ empty$
    { pop$ primaryclass }
    { primaryclass empty$
        'skip$
        { "primaryclass" "eprintclass" warning:duplicate }
      if$
    }
  if$
  output:write:field
}

FUNCTION {output:debug} {
  "% sort.key$ = " sort.key$ * maxline write$ newline$
  sort.year empty$
    'skip$
    { "% sort.year = " sort.year * maxline write$ newline$ }
  if$
  sort.alph empty$
    'skip$
    { "% sort.alph = " sort.alph * maxline write$ newline$ }
  if$
}

FUNCTION {output:entry} {
  'tempstrga :=
  newline$
  ctrl.debug
    { output:debug }
    'skip$
  if$
  "\entry"
  push:cite wrap:braces *
  tempstrga wrap:braces *
  entryoptions wrap:braces *
  write$ newline$
  output:names
  output:lists
  output:specials
  output:fields.1
  output:fields.2
  output:fields.3
  output:compat.1
  output:compat.2
  output:compat.3
  output:dates.1
  output:dates.2
  output:user
  output:warning
  "\endentry" write$ newline$
}

FUNCTION {control}        { skip$ }
FUNCTION {set}            { type$ output:entry }

FUNCTION {article}        { type$ output:entry }
FUNCTION {bibnote}        { type$ output:entry }
FUNCTION {book}           { type$ output:entry }
FUNCTION {mvbook}         { type$ output:entry }
FUNCTION {inbook}         { type$ output:entry }
FUNCTION {bookinbook}     { type$ output:entry }
FUNCTION {booklet}        { type$ output:entry }
FUNCTION {collection}     { type$ output:entry }
FUNCTION {mvcollection}   { type$ output:entry }
FUNCTION {incollection}   { type$ output:entry }
FUNCTION {manual}         { type$ output:entry }
FUNCTION {misc}           { type$ output:entry }
FUNCTION {online}         { type$ output:entry }
FUNCTION {patent}         { type$ output:entry }
FUNCTION {periodical}     { type$ output:entry }
FUNCTION {proceedings}    { type$ output:entry }
FUNCTION {mvproceedings}  { type$ output:entry }
FUNCTION {inproceedings}  { type$ output:entry }
FUNCTION {reference}      { type$ output:entry }
FUNCTION {mvreference}    { type$ output:entry }
FUNCTION {inreference}    { type$ output:entry }
FUNCTION {report}         { type$ output:entry }
FUNCTION {suppbook}       { type$ output:entry }
FUNCTION {suppcollection} { type$ output:entry }
FUNCTION {suppperiodical} { type$ output:entry }
FUNCTION {thesis}         { type$ output:entry }
FUNCTION {unpublished}    { type$ output:entry }

FUNCTION {artwork}        { type$ output:entry }
FUNCTION {audio}          { type$ output:entry }
FUNCTION {commentary}     { type$ output:entry }
FUNCTION {image}          { type$ output:entry }
FUNCTION {jurisdiction}   { type$ output:entry }
FUNCTION {legal}          { type$ output:entry }
FUNCTION {legislation}    { type$ output:entry }
FUNCTION {letter}         { type$ output:entry }
FUNCTION {movie}          { type$ output:entry }
FUNCTION {music}          { type$ output:entry }
FUNCTION {performance}    { type$ output:entry }
FUNCTION {review}         { type$ output:entry }
FUNCTION {software}       { type$ output:entry }
FUNCTION {standard}       { type$ output:entry }
FUNCTION {video}          { type$ output:entry }

FUNCTION {customa}        { type$ output:entry }
FUNCTION {customb}        { type$ output:entry }
FUNCTION {customc}        { type$ output:entry }
FUNCTION {customd}        { type$ output:entry }
FUNCTION {custome}        { type$ output:entry }
FUNCTION {customf}        { type$ output:entry }

FUNCTION {conference}     { "inproceedings" output:entry }
FUNCTION {electronic}     { "online"        output:entry }
FUNCTION {mastersthesis}  { "thesis"        output:entry }
FUNCTION {other}          { "misc"          output:entry }
FUNCTION {phdthesis}      { "thesis"        output:entry }
FUNCTION {techreport}     { "report"        output:entry }
FUNCTION {www}            { "online"        output:entry }
FUNCTION {default.type}   { "misc"          output:entry }

% -------------------------------------------------------------------
% Input
% -------------------------------------------------------------------

FUNCTION {input:control:parse} {
  'tempstrga :=
  "" 'tempstrgb :=
  #1 'tempctra  :=
  { tempstrga empty$ not
    tempctra and }
    { tempstrga #1 #1 substring$ ":" =
        { #0 'tempctra := }
        { tempstrgb tempstrga #1 #1 substring$ * 'tempstrgb := }
      if$
      tempstrga #2 global.max$ substring$ 'tempstrga :=
    }
  while$
  tempstrga
  tempstrgb
}

FUNCTION {input:control:options} {
  input:control:parse str.to.int
}

% This version corresponds to the .bbl version, *not* the biblatex version!
FUNCTION {input:control:version} {
  input:control:parse
  "$Revision: 2.3 $"
  #12 entry.max$ substring$
  #-3 entry.max$ substring$
  'tempstrga :=
  duplicate$ tempstrga =
    { pop$ }
    { "Version mismatch: biblatex.bst=" tempstrga *
      ", biblatex.sty=" * swap$ * warning$
      pop$ "" }
  if$
}

FUNCTION {input:control} {
  options empty$
    'skip$
    { options input:control:version
      duplicate$ empty$
        { pop$ }
        { input:control:options 'ctrl.debug :=
          input:control:options 'ctrl.bibtex8 :=
          input:control:options 'ctrl.cssort :=
          input:control:options 'ctrl.terseinits :=
          input:control:options 'ctrl.useprefix :=
          input:control:options 'ctrl.useauthor :=
          input:control:options 'ctrl.useeditor :=
          input:control:options 'ctrl.usetranslator :=
          input:control:options 'ctrl.labelalpha :=
          input:control:options 'ctrl.labeldate :=
          input:control:options 'ctrl.singletitle :=
          input:control:options 'ctrl.sorting :=
          input:control:options 'ctrl.sortlos :=
          input:control:options 'ctrl.maxnames :=
          input:control:options 'ctrl.minnames :=
          input:control:options 'ctrl.maxline :=
          'ctrl.alphaothers :=
        }
      if$
      ctrl.maxline #49 <
        { #49 'ctrl.maxline := }
        { ctrl.maxline #79 >
            { #79 'ctrl.maxline := }
            'skip$
          if$
        }
      if$
    }
  if$
}

FUNCTION {input:options:add} {
  entryoptions empty$
    'skip$
    { entryoptions ", " * 'entryoptions := }
  if$
  entryoptions swap$ * 'entryoptions :=
  duplicate$ empty$
    { pop$ }
    { "=" swap$ * entryoptions swap$ * 'entryoptions := }
  if$
}

FUNCTION {input:options:known} {
  duplicate$ empty$
    { tempstrgb input:options:add
      #1 }
    { duplicate$ "true" =
        { pop$ "" tempstrgb input:options:add 
          #1 }
        { duplicate$ tempstrgb input:options:add
          bol.to.int 
        }
      if$
    }
  if$
}

FUNCTION {input:options:parse} {
  'tempstrgb :=
  tempstrgb "useprefix" =
    { input:options:known 'useprefix := }
    { tempstrgb "useauthor" =
        { input:options:known 'useauthor := }
        { tempstrgb "useeditor" =
            { input:options:known 'useeditor := }
            { tempstrgb "usetranslator" =
                { input:options:known 'usetranslator := }
                { tempstrgb "skipbib" =
                    { input:options:known 'skipbib := }
                    { tempstrgb "skiplos" =
                        { input:options:known 'skiplos := }
                        { tempstrgb "skiplab" =
                            { input:options:known 'skiplab := }
                            { tempstrgb "dataonly" = 
                                { input:options:known 
                                  duplicate$ 'skipbib :=
                                  duplicate$ 'skiplos := 
                                             'skiplab := 
                                }
                                { tempstrgb input:options:add }
                              if$
                            }
                          if$
                        }
                      if$
                    }
                  if$
                }
              if$
            }
          if$
        }
      if$
    }
  if$
}

FUNCTION {input:options:extract} {
  'tempstrgb :=
  #1 'tempctrb :=
  { tempstrgb text.length$ #0 > }
    { tempstrgb tempctrb #1 substring$ "=" =
        { tempstrgb tempctrb #1 + global.max$ substring$
          tempstrgb #1 tempctrb #1 - substring$
          input:options:parse
          "" 'tempstrgb :=
        }
        { tempstrgb text.length$ tempctrb =
            { "" tempstrgb input:options:parse
              "" 'tempstrgb :=
            }
            { tempctrb #1 + 'tempctrb := }
          if$
        }
      if$
    }
  while$
}

FUNCTION {input:options} {
  options 'tempstrga :=
  #1 'tempctra :=
  { tempstrga text.length$ #0 > }
    { tempstrga tempctra #1 substring$ "," =
        { tempstrga #1 tempctra #1 - substring$ input:options:extract
          tempctra #1 + 'tempctra :=
          { tempstrga tempctra #1 substring$ " " =
            tempctra tempstrga text.length$ > not
            and
          }
            { tempctra #1 + 'tempctra := }
          while$
          tempstrga tempctra global.max$ substring$ 'tempstrga :=
          #1 'tempctra :=
        }
        { tempstrga text.length$ tempctra =
            { tempstrga input:options:extract
              "" 'tempstrga :=
            }
            { tempctra #1 + 'tempctra := }
          if$
        }
      if$
    }
  while$
}

FUNCTION {input:iterate} {
  ctrl:control
    { input:control }
    { citecount #1 + 'citecount :=
      citecount int.to.str$ #9 pad.number 'sortkey.nosort :=
      ctrl.useprefix 'useprefix :=
      ctrl.useauthor 'useauthor :=
      ctrl.useeditor 'useeditor :=
      ctrl.usetranslator 'usetranslator :=
      ctrl.singletitle
        { #1 'singletitle := }
        'skip$
      if$
      options empty$
        'skip$
        { input:options }
      if$
      ctrl:set entryset empty$ or
        'skip$
        { #1 'skipbib :=
          #1 'skiplos := 
          #1 'skiplab := 
        }
      if$
      "date" date split.date
      pop$ pop$ 'dateyear    :=
      pop$ pop$ 'dateendyear :=
      dateyear empty$
        { year empty$
            'skip$
            { year 'dateyear := }
          if$
        }
        'skip$
      if$
    }
  if$
}

READ

EXECUTE {initialize}

ITERATE {input:iterate}

% -------------------------------------------------------------------
% Generate labels
% -------------------------------------------------------------------

FUNCTION {makelabel:name:format} {
  'templist :=
  #1 'tempctra :=
  templist num.names$ 'tempctrb :=
  templist andothers
    { tempctrb #1 - 'tempctrb := }
    'skip$
  if$
  tempctrb ctrl.maxnames >
    { ctrl.minnames 'tempctrc := }
    { ctrl.maxnames 'tempctrc := }
  if$
  ""
  { duplicate$ text.length$ entry.max$ #50 - <
    tempctra tempctrc > not and
    tempctrb #0 > and
    }
    { useprefix
        { templist tempctra "{vv}" format.name$
          duplicate$ empty$
            { pop$ "" }
            { "u" change.case$ "t" change.case$ 
              delimiter.3 * }
          if$
        }
        { "" }
      if$
      templist tempctra "{ll}" format.name$ *
      tempctra #1 >
        { delimiter.2 swap$ * }
        'skip$
      if$
      *
      tempctra #1 + 'tempctra :=
      tempctrb #1 - 'tempctrb :=
    }
  while$
  templist andothers
  tempctrb #0 >
  or
    { delimiter.2 * "zzzz" * }
    'skip$
  if$
}

FUNCTION {makelabel:name:full} {
  duplicate$ num.names$ #1 =
    { #1
      "{ll}{" delimiter.3 *
      "ff}{" delimiter.3 * *
      "vv}{" delimiter.3 * *
      "jj}" *
      format.name$
    }
    { pop$ "" }
  if$
}

FUNCTION {makelabel:alpha:format} {
  duplicate$ empty$
    { pop$ "" }
    { 'templist :=
      #1 'tempctra :=
      templist andothers
        { templist num.names$ #1 - 'tempctrb := }
        { templist num.names$ 'tempctrb := }
      if$
      tempctrb ctrl.maxnames >
        { ctrl.minnames 'tempctrb := }
        'skip$
      if$
      tempctrb #1 >
        { ""
          { tempctrb #0 > }
            { templist tempctra "{l{}}" format.name$ *
              tempctra #1 + 'tempctra :=
              tempctrb #1 - 'tempctrb :=
            }
          while$
        }
        { templist #1 "{l{}}" format.name$ }
      if$
      duplicate$ text.length$ #2 <
        { pop$
          useprefix
            { templist #1 "{v{}}" format.name$ #2 text.prefix$
              templist #1 "{ll}"  format.name$ *
            }
            { templist #1 "{ll}" format.name$ }
          if$
          #3 text.prefix$
        }
        'skip$
      if$
    }
  if$
  templist num.names$ ctrl.maxnames >
  templist andothers
  or
    { ctrl.alphaothers * }
    'skip$
  if$
}

FUNCTION {makelabel:alpha:year} {
  dateyear purify
  #1  #4 substring$
  #-1 #2 substring$
}

FUNCTION {makelabel:hash:format} {
  'templist :=
  #1 'tempctra :=
  templist num.names$ 'tempctrb :=
  templist andothers
    { tempctrb #1 - 'tempctrb := }
    'skip$
  if$
  tempctrb ctrl.maxnames >
    { ctrl.minnames 'tempctrc := }
    { ctrl.maxnames 'tempctrc := }
  if$
  ""
  { tempctra tempctrc > not
    tempctrb #0 >
    and }
    { templist tempctra
      useprefix
        { "{v{}}{l{}}{j{}}{f{}}" }
        { "{l{}}{j{}}{f{}}{v{}}" }
      if$
      format.name$ purify$ *
      tempctra #1 + 'tempctra :=
      tempctrb #1 - 'tempctrb :=
    }
  while$
  templist andothers
  tempctrb #0 >
  or
    { "+" * }
    'skip$
  if$
}

FUNCTION {makelabel:hash:format:full} {
  'templist :=
  #1 'tempctra :=
  templist num.names$ 'tempctrb :=
  templist andothers
    { tempctrb #1 - 'tempctrb := }
    'skip$
  if$
  ""
  { tempctrb #0 > }
    { templist tempctra
      useprefix
        { "{v{}}{l{}}{j{}}{f{}}" }
        { "{l{}}{j{}}{f{}}{v{}}" }
      if$
      format.name$ purify$ *
      tempctra #1 + 'tempctra :=
      tempctrb #1 - 'tempctrb :=
    }
  while$
  templist andothers
    { "+" * }
    'skip$
  if$
}

FUNCTION {makelabel:ctrl:alpha} {
  ctrl:labelalpha
    { label empty$
        { push:cite purify #1 #3 substring$
          "u" change.case$ "t" change.case$ }
        { label makelabel:alpha:year * }
      if$
    }
    { "" }
  if$
}

FUNCTION {makelabel:ctrl:alpha:format} {
  ctrl:labelalpha
    { label empty$
        { makelabel:alpha:format }
        { pop$ label }
      if$
      makelabel:alpha:year *
    }
    { pop$ "" }
  if$
}

FUNCTION {makelabel:label} {
  push:shortname empty$
    { push:sorttitle 'label.name :=
      makelabel:ctrl:alpha 'labelalpha :=
    }
    { push:shortname
      duplicate$ makelabel:name:format 'label.name :=
      duplicate$ makelabel:hash:format 'namehash :=
      makelabel:ctrl:alpha:format 'labelalpha :=
    }
  if$
  push:fullname empty$
    'skip$
    { push:fullname makelabel:hash:format:full 'fullhash := }
  if$
}

% -------------------------------------------------------------------
% Sort labels
% -------------------------------------------------------------------

FUNCTION {labelsort:label} {
  sortkey:init:label
  makelabel:label
}

FUNCTION {labelsort:main} {
  ctrl:skiplab not
  ctrl.singletitle ctrl.labeldate or
  and
    { label.name purify delimiter.1 *
      sortkey.year * delimiter.1 *
      push:presort * delimiter.1 *
      sortkey empty$
        { sortkey.name * delimiter.1 * sortkey.title }
        { sortkey }
      if$
      *
      truncate
    }
    { "" }
  if$
  duplicate$
  'sort.key$ :=
  'sort.year :=
}

FUNCTION {labelsort:alph} {
  ctrl:labelalpha
    { labelalpha normalize delimiter.1 *
      push:presort * delimiter.1 *
      sortkey empty$
        { ctrl.sorting #10 >
          ctrl.sorting #20 <
          and
            { ctrl.sorting #10 - }
            { #2 }
          if$
          sortkey:main:string
        }
        { sortkey }
      if$
      *
      truncate
    }
    { "" }
  if$
  duplicate$
  'sort.key$ :=
  'sort.alph :=
}

FUNCTION {labelsort:hash} {
  ctrl:control
  namehash empty$
  or
    { "zzzz" 'sort.key$ := }
    { namehash purify delimiter.1 *
      push:shortname duplicate$ empty$
        { pop$ "zzzz" * }
        { sortkey:name:format purify * }
      if$
      truncate 'sort.key$ :=
    }
  if$
}

FUNCTION {labelsort:fullhash} {
  ctrl:control
  fullhash empty$
  or
    { "zzzz" 'sort.key$ := }
    { fullhash purify delimiter.1 *
      push:shortname duplicate$ empty$
        { pop$ "zzzz" * }
        { sortkey:name:format purify * }
      if$
      truncate 'sort.key$ :=
    }
  if$
}

% -------------------------------------------------------------------

FUNCTION {labelsort:init} {
  "" 'last.name  :=
  "" 'last.year  :=
  "" 'last.hash  :=
  "" 'last.extra :=
  #1 'last.extra.num :=
}

FUNCTION {labelsort:main:init} {
  "" 'last.name  :=
}

FUNCTION {labelsort:hash:init} {
  "" 'last.name :=
  #1 'last.extra.num :=
}

FUNCTION {labelsort:namehash:iterate} {
  ctrl:control
  namehash empty$
  or
    'skip$
    { namehash last.hash =
        { push:name:namehash last.name =
            'skip$
            { last.extra.num #1 + 'last.extra.num := }
          if$
          last.extra.num int.to.str$ 'labelhash :=
        }
        { #1  'last.extra.num :=
          "1" 'labelhash  :=
        }
      if$
      namehash 'last.hash :=
      push:name:namehash 'last.name :=
    }
  if$
}

FUNCTION {labelsort:namehash:reverse} {
  ctrl:control
  namehash empty$
  or
    'skip$
    { push:name:namehash last.name =
        { last.extra "1" =
            { "1" 'labelhash := }
            'skip$
          if$
        }
        { last.extra "2" =
            { "1" 'labelhash := }
            'skip$
          if$
        }
      if$
      labelhash 'last.extra :=
      push:name:namehash 'last.name  :=
      namehash labelhash * 'namehash :=
    }
  if$
}

FUNCTION {labelsort:fullhash:iterate} {
  ctrl:control
  fullhash empty$
  or
    'skip$
    { fullhash last.hash =
        { push:name:fullhash last.name =
            'skip$
            { last.extra.num #1 + 'last.extra.num := }
          if$
          last.extra.num int.to.str$ 'labelhash :=
        }
        { #1  'last.extra.num :=
          "1" 'labelhash  :=
        }
      if$
      fullhash 'last.hash :=
      push:name:fullhash 'last.name :=
    }
  if$
}

FUNCTION {labelsort:fullhash:reverse} {
  ctrl:control
  fullhash empty$
  or
    'skip$
    { push:name:fullhash last.name =
        { last.extra "1" =
            { "1" 'labelhash := }
            'skip$
          if$
        }
        { last.extra "2" =
            { "1" 'labelhash := }
            'skip$
          if$
        }
      if$
      labelhash 'last.extra :=
      push:name:fullhash 'last.name  :=
      fullhash labelhash * 'fullhash :=
    }
  if$
}

FUNCTION {labelsort:main:singletitle} {
  ctrl.singletitle
    { label.name last.name =
        { #0 'singletitle := }
        'skip$
      if$
      label.name 'last.name :=
    }
    'skip$
  if$
}

FUNCTION {labelsort:main:year:iterate} {
  ctrl:labeldate
    { label.name
      dateyear empty$
         'skip$
         { " " * dateyear *
           dateendyear empty$
             'skip$
             { dateyear dateendyear =
                 'skip$
                 { dateendyear open.ended =
                     'skip$
                     { "-" * dateendyear * }
                   if$
                 }
               if$
             }
           if$
         }
      if$
      'label.year :=
      label.year last.year =
        { last.extra.num #1 + 'last.extra.num :=
          last.extra.num int.to.str$ 'extrayear :=
        }
        { #1 'last.extra.num :=
          "" 'extrayear :=
          label.year 'last.year :=
        }
      if$
    }
    'skip$
  if$
}

FUNCTION {labelsort:main:year:reverse} {
  ctrl:labeldate
    { last.extra "2" =
        { "1" 'extrayear := }
        'skip$
      if$
      extrayear 'last.extra :=
    }
    'skip$
  if$
}

FUNCTION {labelsort:main:iterate} {
  ctrl:skiplab
    'skip$
    { labelsort:main:singletitle
      labelsort:main:year:iterate
    }
  if$
}

FUNCTION {labelsort:main:reverse} {
  ctrl:skiplab
    'skip$
    { labelsort:main:singletitle
      labelsort:main:year:reverse
    }
  if$
}

FUNCTION {labelsort:alph:iterate} {
  ctrl:labelalpha
    { labelalpha last.year =
        { last.extra.num #1 + 'last.extra.num :=
          last.extra.num int.to.str$ 'extraalpha :=
        }
        { #1 'last.extra.num :=
          "" 'extraalpha :=
        }
      if$
      labelalpha 'last.year :=
    }
    'skip$
  if$
}

FUNCTION {labelsort:alph:reverse} {
  ctrl:labelalpha
    { last.extra "2" =
        { "1" 'extraalpha := }
        'skip$
      if$
      extraalpha 'last.extra :=
      labelalpha empty$
        'skip$
        { extraalpha empty$
            { labelalpha normalize 'sortkey.alpha := }
            { labelalpha normalize extraalpha #4 pad.number * 'sortkey.alpha := }
          if$
        }
      if$
    }
    'skip$
  if$
}

ITERATE {labelsort:label}

EXECUTE {labelsort:init}

ITERATE {labelsort:hash}

SORT

EXECUTE {labelsort:hash:init}

ITERATE {labelsort:namehash:iterate}

EXECUTE {labelsort:hash:init}

REVERSE {labelsort:namehash:reverse}

EXECUTE {labelsort:init}

ITERATE {labelsort:fullhash}

SORT

EXECUTE {labelsort:hash:init}

ITERATE {labelsort:fullhash:iterate}

EXECUTE {labelsort:hash:init}

REVERSE {labelsort:fullhash:reverse}

EXECUTE {labelsort:init}

ITERATE {labelsort:main}

SORT

EXECUTE {labelsort:init}

EXECUTE {labelsort:main:init}

ITERATE {labelsort:main:iterate}

EXECUTE {labelsort:main:init}

REVERSE {labelsort:main:reverse}

EXECUTE {labelsort:init}

ITERATE {labelsort:alph}

SORT

ITERATE {labelsort:alph:iterate}

REVERSE {labelsort:alph:reverse}

% -------------------------------------------------------------------
% Sort bibliography, write .bbl file
% -------------------------------------------------------------------

FUNCTION {mainsort} {
  ctrl:control
    { "" }
    { sortkey:main }
  if$
  'sort.key$ :=
}

FUNCTION {lossort} {
  ctrl.sortlos
    { shorthand empty$
      ctrl:skiplos or
        { "" }
        { shorthand }
      if$
      truncate
      'sort.key$ :=
    }
    'skip$
  if$
}

ITERATE {mainsort}

SORT

% This version corresponds to the .bbl version, *not* the biblatex version!
FUNCTION {output:main:begin} {
  "% $ biblatex auxiliary file $"                               write$ newline$
  "% $ biblatex version " "$Revision: 2.3 $"
  #12 entry.max$ substring$ #-3 entry.max$ substring$ * " $" *  write$ newline$
  "% Do not modify the above lines!"                            write$ newline$
  "%"                                                           write$ newline$
  "% This is an auxiliary file used by the 'biblatex' package." write$ newline$
  "% This file may safely be deleted. It will be recreated as"  write$ newline$
  "% required."                                                 write$ newline$
  "%"                                                           write$ newline$
  "\begingroup"                                                 write$ newline$
  "\makeatletter"                                               write$ newline$
  "\@ifundefined{ver@biblatex.sty}"                             write$ newline$
  "  {\@latex@error"                                            write$ newline$
  "     {Missing 'biblatex' package}"                           write$ newline$
  "     {The bibliography requires the 'biblatex' package.}"    write$ newline$
  "      \aftergroup\endinput}"                                 write$ newline$
  "  {}"                                                        write$ newline$
  "\endgroup"                                                   write$ newline$
}

FUNCTION {output:main:preamble} {
  preamble$ empty$
    'skip$
    { newline$
      "\preamble{%" write$ newline$
      preamble$ write$ newline$
      "}" write$ newline$
    }
  if$
}

FUNCTION {output:main:end} {
  newline$
  "\endinput" write$ newline$
}

FUNCTION {output:los:begin} {
  newline$
  "\lossort" write$ newline$
}

FUNCTION {output:los:iterate} {
  shorthand empty$
  ctrl:skiplos or
    'skip$
    { "  \key{" push:cite * "}" * write$ newline$ }
  if$
}

FUNCTION {output:los:end} {
  "\endlossort" write$ newline$
}


EXECUTE {output:main:begin}

EXECUTE {output:main:preamble}

ITERATE {call.type$}

ITERATE {lossort}

SORT

EXECUTE {output:los:begin}

ITERATE {output:los:iterate}

EXECUTE {output:los:end}

EXECUTE {output:main:end}

% -------------------------------------------------------------------
