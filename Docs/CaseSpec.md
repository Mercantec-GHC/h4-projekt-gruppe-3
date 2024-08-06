# Case specs

- Der skal laves to typer af bruger:

  - alle-bruger-typer:

    - upload profil billede
    - navn

  - forældre-bruger:

    - administrere børne profiler.
    - Oprette opgaver, samt administrere opgaverne
    - godkende om opgaver er løst
    - skal kunne se optjente point for børne profiler.
    - skal kunne se mobilens lokation, når opgaven er blevet markeret som løst.
    - Oprette børne profiler, hvor efter at man fra en anden mobil, kan skande en qr kode, som vil tillade en at oprette login til børne profilen.

  - børne-bruger:

    - Skal kunne tage billeder af den løste opgave.
    - skal have en oversigt over sine løste opgaver.
    - skal kunne se hvor mange points de har optjent.
    - når en bruger markere en opgave som løst, så bliver mobilens lokation sent med.
    - kan være tilknyttet flere familie profiler, men points på den enkelte familie deles ikke med andre familier.

- det skal være muligt at oprette familie konto, som har flere forældre til den samme gruppe af børn.

- Opgaver:

  - recurring (boolean)
  - time between recurring.
  - deadline (date-time)
  - start dato (skjult)
  - reward (antal points)
  - description
  - completed dato (skjult)
  - updated dato (skjult)
  - completed by (skjult)
  - assigned to (skjult ?)
  - geo lokation (skjult)
  - dokumentation af opgaven løst (skjult)

- Notifikationer:

  - når der laves nye opgaver skal der sendes en push notifikation til alle relevante børne profiler.
  - send en notifikation til forældre profil, når en opgave er løst
  - send en notifikation til alle relevante parte, når en opgave ændres eller er tæt på at udløbe.

- multi-langauge support:

  - det skal være muligt at have flere sprog i appen.

- Nice-to-have:

  - Familie kalender der giver en oversigt over kommende tasks samt tidligere tasks.
  - Butik hvor man kan veksle optjente points til goodies
  - upgrade profil til paid (mangler klarifikation)
  - det skal være muligt at tjene bagdes, baseret på mængde af tasks man gennemfører.
  - milestone system for antal point om måneden.
