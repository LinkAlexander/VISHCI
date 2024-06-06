-- Select all actors, which have no other professions
```SQL
select * from namebasics where primaryprofession LIKE 'actor';
```

--Count the number of alive actors
```SQL
select count(*) from namebasics where primaryprofession LIKE '%actor%' AND deathyear is null;
```

-- Select all actresses, who also have other professions in the film industry
```SQL
select * from namebasics where primaryprofession LIKE '%actress%';
```

-- Select all actresses, which have no other professions
```SQL
select * from namebasics where primaryprofession LIKE 'actress';
```

-- Count the number of alive actresses
```SQL
select count(*) from namebasics where primaryprofession LIKE '%actress%' AND deathyear is null;
```

-- Select the average rating of movies per country, as well as the number of votes
```SQL
SELECT avg(rating.averagerating) AS avg,
sum(rating.numvotes) AS numberOfVotes,
aka.region FROM AKAS AS aka
JOIN ratings AS rating
ON aka.titleid = rating.tconst
GROUP BY aka.region
ORDER BY avg;
```
-- Call tables
```SQL
SELECT * FROM episode;
```
```SQL
SELECT * FROM crew;
```
```SQL
SELECT * FROM principals;
```
```SQL
SELECT * FROM ratings;
```
```SQL
SELECT * FROM akas;
```
```SQL
SELECT * FROM titlebasics;
```
```SQL
SELECT * FROM namebasics;
```

-- Count the genres by year range
```SQL
SELECT count(*), genres
FROM titlebasics
WHERE startyear > 2010 AND startyear < 2020
GROUP BY genres;
```
```SQL
select * from titlebasics where endyear is not null;
```

-- Gebe das Durchschnittliche Rating, Title und Genres aus. Aktuell nur von Erwachsenenfilmen
```SQL
SELECT  r.averagerating, t.originaltitle, t.runtimeminutes, t.genres from titlebasics t
JOIN ratings r on r.tconst = t.tconst
where isadult
AND r.numvotes > 100
--         AND t.genres like '%musical%'
;
```

-- Zähle, wie viele Filme pro Genre im Jahr erzeugt werden
```SQL
SELECT startyear, genres, count(genres) from titlebasics t
WHERE startyear > 1900 AND startyear < 2000
group by startyear, genres;
```

-- Count how many Movies are exported per Country
```SQL
WITH translations AS (
    SELECT 
        original.titleId AS originalTitleId,
        original.region AS originalRegion,
        translation.region AS translationRegion
    FROM 
        akas AS original
    JOIN 
        akas AS translation ON original.titleId = translation.titleId
    WHERE 
        original.region <> translation.region
)
SELECT 
    originalRegion AS region,
    COUNT(DISTINCT originalTitleId) AS numTranslations
FROM 
    translations
GROUP BY 
    originalRegion
ORDER BY 
    numTranslations DESC;



```
Gibt uns:
\N,7682198
DE,4718542
FR,4709399
JP,4693113
IN,4634266
ES,4628495
IT,4613763
PT,4536695
US,1435673
GB,467561
CA,224194
XWW,159815
AU,155040
BR,118582
MX,105598
RU,102943
PL,91474
GR,77963
SE,76424
HU,76168
FI,71663
NL,63336
AR,61766
PH,61016
NO,59000
DK,54375
TR,53451
XWG,46587
EC,41885
CN,37613
SUHH,36195
TW,35286
ZA,32826
SG,32717
KR,32650
AT,29692
BE,29648
RO,28716
UA,28244
BG,27630
HK,25344
CZ,24045
RS,22971
IL,19778
ID,19743
IE,18025
AE,16540
IR,16045
HR,15329
XYU,15040
CL,14810
EG,14791
NZ,14159
VN,13600
CH,13328
VE,12908
TH,12517
LT,11697
SK,11017
CO,9647
DDDE,9581
SI,9539
CSHH,9387
NG,9303
PE,8678
EE,7895
UY,7617
XEU,6677
PK,5426
LV,5368
MY,4854
BD,4319
IS,2733
DO,2544
CU,2494
AL,2218
BA,2191
XAS,2116
LB,1864
UZ,1861
PR,1838
LK,1738
KZ,1566
GE,1515
NP,1418
TN,1320
MA,1289
CY,1200
LU,1199
BY,1145
AZ,1137
SA,1090
DZ,1027
CM,1026
KE,989
MK,987
GH,917
CR,884
AM,876
PA,853
YUCS,833
JM,814
HT,797
KP,784
BO,756
UG,725
LI,673
IQ,658
SY,613
QA,580
XKO,517
KW,512
MT,510
BF,474
PY,448
GT,418
TZ,412
KH,397
JO,396
MN,384
SN,381
MD,351
TT,347
XKV,309
ZW,298
MM,291
ME,288
CI,278
PS,275
AF,269
CG,245
SV,234
XSA,228
KG,216
BJ,211
CD,210
SM,210
TG,199
MZ,193
BH,185
MC,184
ET,169
ZM,168
HN,168
GA,161
BS,151
GI,143
MO,141
CSXX,141
AO,137
NA,130
NI,124
RW,124
SL,121
BW,118
VI,107
GP,105
MW,103
GL,102
MG,102
NE,101
MU,100
MV,99
YE,93
ML,92
PF,91
LA,88
TJ,87
SD,82
FO,80
TM,76
LY,68
GM,68
BT,68
GU,65
BB,62
AD,58
LR,56
GN,55
BI,54
VDVN,52
OM,51
KY,49
MQ,49
BUMM,47
AN,43
IM,42
XPI,42
AW,41
FJ,39
BM,38
SC,38
SO,35
BZ,33
SZ,33
RE,29
CF,29
PG,28
BN,27
SR,27
TD,27
CV,26
GY,25
GF,25
AG,24
GW,21
NC,21
TL,20
MR,20
DM,19
TO,18
LS,15
ER,15
LC,14
VG,12
GQ,12
KM,11
VA,11
AQ,10
MH,10
ST,9
SB,8
VC,8
KN,7
XSI,7
ZRCD,7
VU,7
GD,6
EH,6
AS,6
WS,5
AI,5
CW,4
MP,4
CK,4
XAU,4
KI,4
TC,3
DJ,3
MS,3
CC,2
FM,2
XNA,2
SH,2
TV,1
NU,1
PW,1
JE,1
NR,1

--Ohne Adult movies. Ergebnis ist nicht wesentlich anders
```SQL
WITH movie_exports AS (
    SELECT
        original.region AS exportRegion,
        COUNT(DISTINCT original.titleId) AS numMoviesExported
    FROM
        akas AS original
    JOIN
        akas AS translation ON original.titleId = translation.titleId
    JOIN
        titlebasics ON original.titleId = titlebasics.tconst
    WHERE
        original.region <> translation.region
        AND titlebasics.isAdult = false
    GROUP BY
        original.region
)
SELECT
    exportRegion AS region,
    numMoviesExported
FROM
    movie_exports
ORDER BY
    numMoviesExported DESC;
```

\N,7540294
DE,4704096
FR,4701840
JP,4680903
IN,4630803
ES,4621663
IT,4607677
PT,4532857
US,1337710
GB,461594
CA,218273
XWW,157043
AU,154336
BR,116756
MX,105455
RU,102531
PL,91329
GR,77068
HU,75170
SE,74567
FI,71241
AR,61601
NL,61155
PH,60982
NO,58970
DK,53328
TR,53069
XWG,45320
EC,41874
CN,37507
SUHH,36085
TW,35241
ZA,32811
SG,32707
KR,32602
AT,29612
BE,29554
RO,28695
UA,28198
BG,27616
HK,25264
RS,22950
CZ,22154
IL,19767
ID,19725
IE,17953
AE,16535
IR,16037
HR,15319
XYU,15017
CL,14797
EG,14785
NZ,14134
VN,13594
CH,13130
TH,12511
LT,11697
SK,10907
CO,9612
DDDE,9580
VE,9529
SI,9520
CSHH,9387
NG,9301
PE,8641
EE,7893
UY,7598
XEU,6537
PK,5420
LV,5365
MY,4849
BD,4315
IS,2733
DO,2540
CU,2491
AL,2215
BA,2190
XAS,2089
LB,1860
UZ,1858
PR,1831
LK,1738
KZ,1564
GE,1509
NP,1417
TN,1318
MA,1286
LU,1193
BY,1145
AZ,1137
CY,1137
SA,1090
CM,1023
DZ,1021
KE,989
MK,987
GH,916
CR,878
AM,876
PA,852
YUCS,829
JM,804
HT,797
KP,784
BO,753
UG,724
LI,669
IQ,657
SY,610
QA,580
XKO,516
KW,512
MT,509
BF,474
PY,444
GT,417
TZ,412
KH,397
JO,396
MN,384
SN,379
MD,351
TT,347
XKV,308
ZW,298
MM,291
ME,288
CI,278
PS,274
AF,268
CG,241
SV,232
XSA,226
KG,216
CD,210
BJ,209
SM,209
TG,199
MZ,190
BH,185
MC,184
ET,169
HN,168
ZM,168
GA,161
BS,151
MO,141
CSXX,140
AO,137
NA,130
NI,124
RW,124
SL,121
BW,118
VI,107
GP,105
MW,103
GL,102
MG,102
NE,101
MU,100
MV,99
YE,93
ML,92
PF,91
LA,88
TJ,87
SD,81
FO,80
TM,76
GI,71
BT,68
LY,68
GM,68
GU,65
BB,62
AD,57
LR,56
GN,55
BI,54
VDVN,52
OM,50
MQ,49
KY,49
BUMM,47
AN,43
IM,42
XPI,42
AW,41
FJ,39
BM,38
SO,35
BZ,33
SZ,33
RE,29
CF,29
PG,28
BN,27
SR,27
TD,27
CV,26
GY,25
GF,25
AG,24
GW,21
NC,21
TL,20
MR,20
TO,18
LS,15
ER,15
LC,14
GQ,12
DM,11
VA,11
KM,11
AQ,10
ST,9
SB,8
VC,8
ZRCD,7
XSI,7
KN,7
MH,7
VG,7
VU,7
GD,6
AS,6
EH,6
SC,6
AI,5
WS,5
CW,4
KI,4
CK,4
XAU,4
MP,4
MS,3
DJ,3
XNA,2
CC,2
SH,2
FM,2
JE,1
TV,1
TC,1
NR,1
NU,1
PW,1

-- Gruppiere Actors nach Alter
```SQL
SELECT WIDTH_BUCKET(EXTRACT(YEAR FROM age(current_date, make_date(birthyear, 1, 1))), 0, 100, 10) * 10 AS age_group,
       COUNT(*) AS count
FROM namebasics
WHERE deathyear IS NULL
  AND 'actor' = ANY(primaryprofession)
GROUP BY age_group
ORDER BY age_group;
```
