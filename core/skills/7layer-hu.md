---
scope: shared
context: fork
allowed-tools:
  - Read
  - Grep
  - Glob
  - Agent
argument-hint: "client — Kliens slug (pl. wellis, diego)"
---

# Skill: 7 Rétegű Marketing Diagnózis (`/7layer`)

## Cél

> **Output posture:** Present observations with questions, not conclusions. Show calculations. Invite disagreement. See `core/methodology/DISCOVERY_NOT_PRONOUNCEMENT.md`.

> **Multi-domain előfeltétel:** Ha az ügyfélnek 2+ domainje van, ELŐSZÖR töltsd be a `DOMAIN_CHANNEL_MAP.md`-t. Az L5 (Csatornák) és L6 (Ügyfél) diagnózis domainenként KELL — csatorna-teljesítmény és ügyfélprofil eltér domainek között. Lásd: `core/methodology/MULTI_DOMAIN_ANALYSIS_RULE.md`.

> **Confidence scoring:** Minden réteg-értékelés és megállapítás egységes konfidencia-pontszámot kap: `core/methodology/CONFIDENCE_ENGINE.md`. Score = min(Source Confidence, Evidence Class, Assumption Status).

> **Recommendation dedup:** REC létrehozása előtt MINDIG ellenőrizd a `RECOMMENDATION_LOG.md`-t az ügyfél könyvtárban. Lásd: `core/methodology/RECOMMENDATION_DEDUP_RULE.md`. REC létrehozása után append a logba.

Egy vállalkozás marketingjét diagnosztizálja az Arcanian 7-Layer Marketing Control Framework segítségével. Megtalálja az ELSŐDLEGES SZŰK KERESZTMETSZETET — a legmélyebb réteget, ami blokkolja a növekedést — és megmutatja, hogyan kaszkádolnak a problémák a rétegek között. Egy Mintázat Térképet ad, ami láthatóvá teszi a láthatatlant.

**Az Arcanian Alapelv:**
> "Every campaign result reveals the assumption that created it."
> *"Minden kampányeredmény feltárja azt a feltételezést, ami létrehozta."*

**A KONTROLL Alapelv:**
> "Te irányítod a marketinget — nem fordítva."

**Az EGYSÉG Alapelv:**
> Az értékesítés és a marketing EGY rendszer. Rendszerszinten ugyanazokon a rétegeken törnek el.
> Ha az L2 (ügyfélidentitás) törött, az egyformán rontja a marketing üzeneteket ÉS az értékesítési beszélgetéseket.
> Ha az L4 (ajánlat) törött, a marketing olyan leadeket generál, amiket az értékesítés nem tud lezárni.
> A marketinget nem lehet az értékesítés nélkül javítani, és fordítva — mert ugyanazokat a rétegeket használják.
> Ez a keretrendszer a RENDSZERT diagnosztizálja, nem a "marketinget" vagy az "értékesítést" külön funkcióként.

## Forrás Referenciák
- **The Arcanian Methodology** — Alapkeretrendszer dokumentum (Hermetikus alap)
- **7-Layer Marketing Control Framework** — Ügyfél guide
- **Identitás-réteg overlay** — Személy- és vállalati identitás-szintű térképezés L1/L2 mélységben
- 22 év marketing mintázat-felismerés, rendszerbe foglalva

## Trigger
Használd ezt a skillt, amikor:
- Az ügyfél azt mondja "a marketing nem működik", de nem tudja megmondani, miért
- Csökkenő ROAS, emelkedő CPC-k, lapos növekedés — tünetek diagnózis nélkül
- "Mindent kipróbáltunk" (mindent kipróbáltak a ROSSZ rétegen)
- Ügynökséget váltottak, kreatívokat frissítették, büdzsét emelték — ugyanaz az eredmény
- Az ügyfélnek second opinion kell a marketing irányáról
- Bármilyen taktikai munka előtt — először diagnosztizálj, utána hajtsd végre
- Nexus: Diagnostic futtatása (48 órás marketing röntgen)
- Az ügyfélnek specifikus kérdése van, de mélyebb rétegeket gyanítasz

## Mi Ez — És Mi NEM Ez

> **Mi NEM ötletelünk. Mi diagnosztizálunk.**

A legtöbb ember úgy gondol a marketingre, mint valami fluid, ötletelős valamire. "Kéne egy jó ötlet." "Mi lenne, ha megpróbálnánk ezt?" "Ötleteljünk egyet."

**Ez nem az, amit csinálunk.**

Amit mi csinálunk, az közelebb áll egy orvosi röntgenhez, mint egy brainstorming meetinghez. Nem ötleteket adunk — mintázatokat mutatunk meg. Nem arról beszélünk, mit lehetne csinálni — megmutatjuk, mi van eltörve és miért.

| Mi NEM csinálunk | Mit csinálunk |
|---|---|
| Ötletelés | Diagnózis |
| "Mi lenne, ha..." | "Ez van, és ez okozza" |
| Kreatív brainstorming | Mintázat-felismerés |
| Több ötlet a halomra | Kevesebb, de a jó dolog |
| Vélemény | Rendszer-alapú elemzés |
| Tanácsadás, amit aztán senki nem csinál meg | Egyértelmű prioritások, amiket másnap el lehet kezdeni |

**A marketing nem ötletelés. A marketing rendszer.** Nálunk a keret adja a folyamatot — nem fordítva. A 7-rétegű keretrendszer megmutatja, mi a sorrend, mi az ok, mi a prioritás. Nem te találgatod — a rendszer mutatja meg. Ha rendszerként kezeled, kontrollálható. Ha ötletelésként kezeled, szerencsejáték.

---

## A Keretrendszer

### A 7 Réteg (Belülről Kifelé)

```
┌─────────────────────────────────────────────────────────────────┐
│                                                                 │
│   LEGKÜLSŐ (legkevesebb kontroll)                               │
│                                                                 │
│   L7: Market (Piac) ─────────► Változik alattunk a játék?        │
│           │                                                     │
│   L6: Customer (Ügyfél) ─────► Kik ők — és milyen identitást    │
│           │                     kapnak, ha tőlünk vesznek?       │
│           │                                                     │
│   L5: Channels (Csatornák) ──► Hol nyerünk ténylegesen?         │
│           │                                                     │
│   L4: Offer (Ajánlat) ───────► Hogyan van csomagolva és árazva?│
│           │                                                     │
│   L3: Product (Termék) ──────► Mit szállítunk konkrétan?        │
│           │                                                     │
│   L2: Identity (Identitás) ──► Kik vagyunk? Mit képviselünk?    │
│           │                     (Márkaidentitás — tartalmazza    │
│           │                      az értéket)                     │
│   L1: Core (Mag) ────────────► Végre tudjuk hajtani? Milyen hit │
│                                  hajtja az egészet?             │
│   LEGBELSŐ (legtöbb kontroll)                                   │
│                                                                 │
│   A problémák kifelé áramlanak (L1→L7).                         │
│   A javítások befelé haladnak (L7→L1).                          │
│   A tünetek 2-3 réteggel az okuktól jelennek meg.               │
│                                                                 │
│   OVERLAY-EK (nem rétegek — az összehangolásból születnek):     │
│   • Brand = L3-L7 összehangolásából születik                    │
│   • Pozíció = L2 × L3 × L4 összehangolásából születik          │
│     "Miért mi, nem ők?" → Identitás + Termék + Ajánlat         │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Gyors Referencia

| Réteg | Név | Központi Kérdés | Árnyék (Rejtett Feltételezés) | Mikor Ez a Szűk Keresztmetszet |
|-------|-----|-----------------|-------------------------------|-------------------------------|
| **L7** | Market (Piac) | Változik alattunk a játék? | "Ismerjük a piacunkat" | Meglepetésszerű piaci változások, új belépők átírják a szabályokat, külső erők érvénytelenítik a stratégiát |
| **L6** | Customer (Ügyfél) | Kik ők — és milyen identitást kapnak? | "Mindenkit kiszolgálunk" | Termék jó, de identitás-ütközés blokkolja a vásárlást, nincs törzsi lojalitás |
| **L5** | Channels (Csatornák) | Hol nyerünk? | "Minden csatornán ott vagyunk" | Szétaprózódás, kimerült csapat, költés nő de eredmény stagnál |
| **L4** | Offer (Ajánlat) | Hogyan van csomagolva? | "Az ár jó" | "Majd gondolkodom rajta", magas elhagyási arány, nincs sürgősség |
| **L3** | Product (Termék) | Mit szállítunk? | "A termékünk magáért beszél" | Termék-piac eltérés, feature bloat, nincs megkülönböztetés |
| **L2** | Identity (Identitás) | Kik vagyunk? Mit képviselünk? | "Tudjuk, kik vagyunk" | Nem konzisztens üzenetek, belső zavar az identitásról, az érték nincs kommunikálva |
| **L1** | Core (Mag) | Végre tudjuk hajtani? | "Mindent jól csinálunk" | Láthatatlan plafon, visszatérő problémák, kapacitáshiány |

---

## Módok

Ez a skill **három módban** működik.

```
┌─────────────────────────────────────────────────────────────────┐
│                    7-LAYER ELEMZÉSI MÓDOK                        │
│                                                                 │
│  MÓD 1: RÖNTGEN (Gyors Diagnosztika)                           │
│  Input: Weboldal + kimondott kihívás                            │
│  Output: Top 5 probléma, rangsorolva, elsődleges                │
│          szűk keresztmetszettel                                 │
│  Idő: Gyors — a Nexus: Diagnostic termék (48 óra)              │
│                                                                 │
│  MÓD 2: MINTÁZAT TÉRKÉP (Teljes Diagnózis)                     │
│  Input: Minden elérhető adat az összes rétegből                 │
│  Output: Teljes 7 rétegű térkép kaszkád kapcsolatokkal          │
│  Idő: Alapos — több kontextus kell hozzá                        │
│                                                                 │
│  MÓD 3: CONSTRAINT DRILL (Egyetlen Réteg Mélyfúrás)            │
│  Input: Azonosított akadály-réteg + minden kapcsolódó adat      │
│  Output: Gyökérok elemzés + akcióterv az adott réteghez         │
│  Idő: Fókuszált — miután az elsődleges akadály ismert           │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## MÓD 1: RÖNTGEN (Gyors Diagnosztika)

### Szükséges Input
- Cég weboldal URL vagy leírás
- Mit árulnak
- A kimondott marketing kihívásuk vagy céljuk
- Bármilyen elérhető adat (bevétel, forgalom, konverzió, költés — opcionális)

### Folyamat

**1. lépés: Mind a 7 Réteg Átvizsgálása**

Minden rétegnél keress erősség- vagy gyengeség-jeleket. Használj nyelvi markereket, webes szöveget, kimondott célokat és elérhető adatokat.

**2. lépés: Problémák Azonosítása Rétegenként**

Értékeld minden réteget:
- **Erős** — összehangolt, működik, nincsenek piros zászlók
- **Figyelmet Igényel** — nincs összehangolva vagy nem egyértelmű, de még nem kritikus
- **Szűk Keresztmetszet** — aktívan blokkolja a növekedést, kaszkádol más rétegekbe

**3. lépés: Tünet Visszavezetése az Okra**

Az ügyfél kimondott problémája szinte sosem ott van, ahol a valódi probléma. Vezesd vissza:

```
ÜGYFÉL MONDJA:              →  TÜNET RÉTEG    →  VALÓDI OK RÉTEGE
"A hirdetések nem működnek"     L5 (Channels)     L4 (Offer) vagy L3 (Product)
"Senki nem vesz"                L4 (Offer)        L2 (Identity) vagy L6 (Customer)
"Nem tudunk nőni"               L7 (Market)       L1 (Core) vagy L3 (Product) vagy L6 identitás-ütközés
"Túl drága"                     L4 (Offer)        L2 (Identity) — az érték nincs kommunikálva
"Rossz ügyfelek jönnek"         L6 (Customer)     L3 (Product) — rossz piacra épült
"Az ügynökség nem teljesít"     L5 (Channels)     L1 (Core) — senki sem birtokolja a stratégiát
"Gyenge a brand"                Overlay           L7→L2→L3 kaszkád — az identitás nem tiszta
```

**4. lépés: Az Elsődleges Szűk Keresztmetszet Megtalálása**

Az elsődleges szűk keresztmetszet a **legmélyebb réteg**, amit ha javítasz, az feloldja a felette lévő rétegeket. Ez az emelőpont.

**5. lépés: Top 5 Probléma Rangsorolása**

### Output Formátum

```
## MARKETING RÖNTGEN: [Cégnév]

### Üzleti Kontextus
[Rövid összefoglaló]

---

### Réteg Átvizsgálás

| Réteg | Státusz | Fő Megállapítás |
|-------|---------|-----------------|
| L7: Market | [Erős/Figyelmet Igényel/Szűk Keresztmetszet] | [Egysoros megállapítás] |
| L6: Customer | ... | ... |
| L5: Channels | ... | ... |
| L4: Offer | ... | ... |
| L3: Product | ... | ... |
| L2: Identity | ... | ... |
| L1: Core | ... | ... |

---

### TOP 5 PROBLÉMA (üzleti hatás szerint rangsorolva)

1. **[Probléma]** — [X]. réteg
   Miért számít: [Hatás az üzletre]
   Mit kell tenni: [Konkrét lépés]

2. ...

---

### ELSŐDLEGES SZŰK KERESZTMETSZET
**Réteg:** [X] — [Név]
**Miért ez a réteg:** [Hogyan oldja fel a többi réteget, ha javítjuk]

### KASZKÁD TÉRKÉP
[Mutasd meg, hogyan áramlik az elsődleges akadály más réteg-problémákba]

### A DRÁGA HIBA
[Mit fognak valószínűleg megpróbálni javítani helyette — és miért nem fog működni]

### MIT CSINÁLJ ELŐSZÖR
[Egy egyértelmű következő lépés]
```

---

## MÓD 2: MINTÁZAT TÉRKÉP (Teljes Diagnózis)

### Szükséges Input
Minden elérhető kontextus:
- Weboldal, landing oldalak, social profilok
- Kimondott marketing célok és kihívások
- Bevétel, forgalom, konverziós adatok
- Hirdetési költés és ROAS adatok
- Ügyfél leírások és szegmensek
- Versenytárs információk
- Csapat felépítés és kapacitás
- Amit már megpróbáltak

### Folyamat

Elemezd alaposan minden réteget az alábbi diagnosztikai kérdésekkel, majd térképezd fel a rétegek közötti kapcsolatokat.

### Layer 7: Market (Piac — Csak Makro Erők)

Az L7 a JÁTÉK MAGA — nem a játékosok. A versenytárs-elemzés a Versenytárs Mátrixba tartozik (lásd lent), nem ide. Az L7 azokat az erőket rögzíti, amik mindenkinek megváltoztatják a szabályokat.

**Diagnosztikai Kérdések:**
1. Ez a piac növekszik, stagnál vagy zsugorodik — és mi hajtja a trendet?
2. Milyen makro erők formálják át ezt a piacot? (szabályozás, technológia, gazdaság, kultúra)
3. Új piaci belépők (Amazon, Temu, Allegro, EMAG) változtatják meg a versenyképet?
4. Milyen külső megrázkódtatások érvényteleníthetik a jelenlegi stratégiát? (árfolyam-változás, ellátási lánc, kereskedelmi politika)
5. Szezonális vagy politikai ciklusok befolyásolják a vásárlói magatartást? (választások, szélsőséges időjárás, ünnepek)
6. Mit csinálnak az ügyfelek ahelyett, hogy BÁRKITŐL vennének ebben a kategóriában? (a "nem csinálok semmit" alternatíva)

**Felismerendő Mintázatok:**

| Mintázat | Tünet | Valódi Probléma |
|----------|-------|-----------------|
| "Ismerjük a piacunkat" | Meglepetésszerű fordulatok | Makro erőket nem követik |
| Zsugorodó piac | Csökkenés optimalizálás ellenére | Piac-váltás, nem végrehajtási hiba |
| Új belépő megrázkódtatás | Hirtelen árnyomás, elvesztett piaci részesedés | Platform/piactér átírja a játékot |
| Szabályozási/gazdasági vakfolt | Stratégia egyik napról a másikra érvényét veszti | Külső erőket nem monitorozzák |
| A "nem csinálok semmit" alternatíva figyelmen kívül hagyása | Ügyfelek inakcióra szavaznak | Kategória-keresleti probléma, nem brand probléma |

### Layer 6: Customer (Ügyfél — Ügyfél-identitással)

Az L6-nak két dimenziója van: KI az ügyfél, és milyen IDENTITÁST kap (vagy vetít ki), ha tőled vásárol. Az identitás-dimenzió gyakran láthatatlan, de mindent felülír — az ügyfél rosszabb opciót is választ, ha az jobban illik az identitásához.

**Diagnosztikai Kérdések — Kik Ők:**
1. Le tudják írni az ideális ügyfelük tipikus keddijét?
2. Mi tartja ébren éjszaka ezt az embert ezzel a problémával kapcsolatban?
3. Mit próbáltak már, ami nem működött?
4. Mit gépelne be a Google-be este 11-kor?
5. Ki fizet vs. ki használja?

**Diagnosztikai Kérdések — Ügyfél-identitás:**
6. Milyen identitást kap vagy vetít ki az ügyfél, ha tőled vásárol?
7. Milyen "törzsbe" lép be az ügyfél, ha téged választ? (Apple törzs, árérzékeny törzs, lázadó törzs...)
8. A márkád/terméked ÜTKÖZIK az ügyfél önképével? Szégyellenné magát vagy büszke lenne, ha tőled venne?
9. Mit mondana magáról az ügyfél, ha ajánlana téged egy barátjának?
10. A jelenlegi identitását célzod meg, vagy az aspirációs identitását?

**Az Identitás Alapelv:**
A nagy márkák nem terméket adnak el — identitást adnak el. A Coca-Cola az odatartozás érzését adja el. Az Apple a kreatív lázadást. Balázs Kicks azt, hogy "én benne vagyok a körben, aki tudja." Ez akkor is lefut, ha nem menedzseled. Az identitás-ütközés blokkolja az eladást, még akkor is, ha az ajánlat, a termék és a csatornák tökéletesek. A cég Identitása (L2) összhangban kell legyen az ügyfél vágyott identitásával (L6) — ez az L2↔L6 híd.

**Felismerendő Mintázatok:**

| Mintázat | Tünet | Valódi Probléma |
|----------|-------|-----------------|
| "Mindenkit kiszolgálunk" | Felhígított üzenetek | Nincs egyértelmű ügyfél-definíció |
| Csak demográfiai targeting | Elérés van, konverzió nincs | Hiányzik a pszichográfiai mélység |
| Ügyfél ≠ Felhasználó | Terméket szeretik, de nem fogy | Rossz embernek értékesítenek |
| Feltételezett tudás | "Nyilván tudják" | Szakadék közted és a piac között |
| Identitás-ütközés | Tökéletes ajánlat, nincs konverzió | Az ügyfél önképe ütközik a tőled vásárlással |
| Nincs törzsi jelzés | Nincs szájról-szájra, nincs lojalitás | A tőled vásárlás nem mond semmit az ügyfélről |
| Rossz identitás célozva | Csak árérzékeny vevők jönnek | L2 identitás nem illeszkedik az aspirációs ügyfél-identitáshoz |

### Layer 5: Channels (Csatornák)

**Diagnosztikai Kérdések:**
1. Hol töltik ténylegesen az idejüket a legjobb ügyfeleik?
2. Melyik EGY csatorna hozza a legtöbb valódi eredményt?
3. Szétaprózódnak vagy mélyre mennek?
4. A csatorna illeszkedik az ügyfél vásárlási útjához?
5. Melyik csatornán vannak azért mert "ott kell lenni" vs. mert működik?

**Felismerendő Mintázatok:**

| Mintázat | Tünet | Valódi Probléma |
|----------|-------|-----------------|
| Szétaprózódás | Közepes eredmények mindenhol | Nincs csatorna-mesterség |
| Platform-ugrálás | Mindig elölről kezdik | Csillogó tárgy szindróma |
| Rossz csatorna az ajánlathoz | Magas költés, alacsony megtérülés | Csatorna-ajánlat eltérés |
| Csatorna-első stratégia | Taktika stratégia nélkül | L5 megelőzi L1-L4-et |

### Layer 4: Offer (Ajánlat — A Csomag)

**Diagnosztikai Kérdések:**
1. Miért kellene valakinek MA vennie, nem jövő hónapban?
2. Milyen kockázatot érez a vásárlás megfontolásánál?
3. 5 másodperc alatt megérti az árazást?
4. Az árazás azokat az ügyfeleket vonzza, akiket akarnak?
5. Mi a garancia? Elég erős?

**Felismerendő Mintázatok:**

| Mintázat | Tünet | Valódi Probléma |
|----------|-------|-----------------|
| Nincs sürgősség | "Majd gondolkodom rajta" | Nincs ok most cselekedni |
| Nincs kockázat-átvállalás | Magas elhagyási arány | Túl sok észlelt kockázat |
| Zavaros opciók | Döntési bénulás | Túl sok választási lehetőség |
| Ár-érték eltérés | Rossz ügyfelek | Az árazás rossz pozicionálást jelez |

### Layer 3: Product (Termék — A Szállítmány)

**Diagnosztikai Kérdések:**
1. Konkrétan mit kap az ügyfél?
2. Hogyan viszonyul a termék/szolgáltatás az alternatívákhoz (direkt és indirekt)?
3. Mit használnak az ügyfelek leginkább abból, amit építettek?
4. Van szakadék a termék funkciói és a piac igényei között?
5. A termék természetes szószólókat hoz létre (szájról szájra)?
6. Min kellene változtatni a terméken, hogy 2×-es árat kérhessenek?

**Felismerendő Mintázatok:**

| Mintázat | Tünet | Valódi Probléma |
|----------|-------|-----------------|
| "A termékünk magáért beszél" | Nincs ajánlás, alacsony ismertség | Termék-piac eltérés |
| Feature bloat | Zavart ügyfelek, hosszú értékesítési ciklus | Mindenkinek épít = senkinek nem hasznos |
| Versenytárs másolata | Árháború, nincs lojalitás | Nincs valódi termék-megkülönböztetés |
| Túltervezett megoldás | Magas ár, alacsony adaptáció | Rossz közönségnek épült |
| Megkülönböztetetlen szolgáltatás | Ügyfelek olcsóbb opcióra váltanak | Nincs egyedi szállítmány |

### Layer 2: Identity (Identitás — Márkaidentitás, tartalmazza az értéket)

**Diagnosztikai Kérdések:**
1. Egy mondatban — mit képviselünk?
2. Mi a különbség aközött, ahogy mi látjuk magunkat, és ahogy az ügyfelek látnak?
3. Milyen átalakulást vesznek valójában az ügyfelek?
4. Mit szeretnek a legjobb ügyfeleik, amit alig említünk?
5. Ha megdupláznák az árat, mi indokolná?
6. Minden csapattag ugyanúgy tudja elmondani, miért létezik a cég?

**Felismerendő Mintázatok:**

| Mintázat | Tünet | Valódi Probléma |
|----------|-------|-----------------|
| "Egy kicsit mindent csinálunk" | Nem konzisztens üzenetek | Nincs egyértelmű identitás |
| Feature-fókuszú értékesítés | Ár-kifogások | Az érték nincs kommunikálva |
| "Nyilvánvaló, mit kínálunk" | Alacsony konverzió | Az ügyfelek másképp látják |
| Eltérő percepció | Magas lemorzsolódás | Teljesítés ≠ elvárás |
| Belső nézeteltérés az identitásról | Kevert jelek a piac felé | Nincs közös alap |

### Layer 1: Core (Mag — Alapok)

**Diagnosztikai Kérdések:**
1. Van kapacitásuk végrehajtani, amit terveznek?
2. Milyen meggyőződéseiket nem kérdőjelezték meg soha a piacukról?
3. Mit csinálnának másképp, ha tudnák, hogy működni fog?
4. Mi az, ami "egyszerűen így van" az iparágukban?
5. Melyik meggyőződés lenne a legfájdalmasabb, ha tévedés lenne?
6. Ki a felelős, amikor a marketing nem működik?

**Felismerendő Mintázatok:**

| Mintázat | Tünet | Valódi Probléma |
|----------|-------|-----------------|
| "Nem kérhetünk többet" | Alulárazott, túlterhelt | Korlátozó hit az értékről |
| "A piacunk nem fizet annyit" | Alacsony bevétel, magas erőfeszítés | Feltételezés, nem tény |
| "Így kell csinálnunk" | Beragadt minták | Iparági hiedelem, nem igazság |
| "Növekedés = áldozat" | Kiégés, ellenérzés | Megvizsgálatlan siker-definíció |
| Túlterhelt csapat | Végrehajtási kudarcok | Nincs kapacitás arra, amit terveznek |

### Kapcsolatok Feltérképezése

Minden réteg elemzése után térképezd fel a KASZKÁDOT — hogyan áramlanak a problémák egyik rétegből a másikba:

```
MINTÁZAT TÉRKÉP: [Cég]

[Legmélyebb probléma-réteg]
        │
        ▼ betáplál ide
[Következő érintett réteg]
        │
        ▼ felerősíti
[Következő érintett réteg]
        │
        ▼
= TÜNET (amit az ügyfél jelez)

ELSŐDLEGES AKADÁLY: [X]. réteg
```

### Output Formátum

```
## 7-LAYER MINTÁZAT TÉRKÉP: [Cégnév]

### Üzleti Kontextus
[Összefoglaló]

---

### Layer 7: Market (Piac)
**Státusz:** [Erős / Figyelmet Igényel / Szűk Keresztmetszet]
**Megállapítások:**
- [Fő megfigyelések]
**Árnyék (Rejtett Feltételezés):**
- [Amit hisznek, de nem biztos, hogy igaz]
**Piros Zászlók:**
- [Figyelmeztető jelek]

[Ismételd L6-tól L1-ig — a legmélyebb mindig utolsó]

---

### A MINTÁZAT TÉRKÉP (Kaszkád)

[Vizuális kaszkád, ami megmutatja, hogyan kapcsolódnak a problémák a rétegek között]

---

### ELSŐDLEGES SZŰK KERESZTMETSZET
**Réteg:** [X] — [Név]
**Miért ez a réteg:** [Hogyan oldja fel a felette lévőket, ha javítjuk]

### MÁSODLAGOS AKADÁLYOK
[Más rétegek, amik figyelmet igényelnek, prioritás sorrendben]

---

### JAVASOLT LÉPÉSEK
1. [Legfontosabb — az elsődleges akadályt kezeli]
2. [Második lépés]
3. [Harmadik lépés]

### MIT NE CSINÁLJ
[A Drága Hiba — mit fognak megpróbálni helyette, és miért fog kudarcot vallani]

### AZ IRÁNY SZABÁLY
A problémák kifelé áramlanak (L1→L7). A javítások befelé haladnak.
[Magyarázd el a konkrét kaszkádot ebben az üzletben]
```

---

## MÓD 3: CONSTRAINT DRILL (Egyetlen Réteg Mélyfúrás)

Arra az esetre, amikor az elsődleges akadály már azonosított és mélyebb elemzést igényel.

### Szükséges Input
- Melyik rétegbe kell mélyfúrni
- Minden elérhető adat, ami az adott réteghez releváns
- Mit próbáltak már ezen a rétegen
- Hogyan kapcsolódik ez a réteg más réteg-problémákhoz

### Folyamat

**1. lépés: Minden probléma feltérképezése a rétegen belül**
Nem csak egy probléma — minden, ami ezen a szinten történik.

**2. lépés: A gyökérok megtalálása a rétegen belül**
Még egyetlen rétegen belül is van hierarchia. Mi a legmélyebb probléma?

**3. lépés: Rétegek közötti kapcsolatok ellenőrzése**
Ezt a réteg-problémát egy mélyebb réteg okozza? Vagy valóban itt ered?

**4. lépés: A javítás megtervezése**
Specifikus, végrehajtható, sorba rendezett lépések az akadály feloldására.

### Output Formátum

```
## CONSTRAINT DRILL: [X]. réteg — [Név]

### Jelenlegi Állapot
[Mi történik ezen a rétegen]

### Gyökérok (rétegen belül)
[A legmélyebb probléma ezen a szinten]

### Rétegek Közötti Kapcsolatok
- Okozza: [mélyebb réteg probléma, ha van]
- Okozata: [külső réteg tünetek]

### Javítási Sorrend
1. [Első lépés — a rétegen belüli gyökéokot kezeli]
2. [Második lépés]
3. [Harmadik lépés]

### Siker-Jelek
[Honnan tudod, hogy ez az akadály feloldódott]

### Mi Nyílik Meg
[Melyik külső rétegek javulnak, ha ez megoldódik]
```

---

## Kulcs Alapelvek

### 1. Tünetek ≠ Okok
Egy probléma az egyik rétegen 2-3 réteggel arrébb jelenik meg tünetként. Soha ne a tünet-réteget optimalizáld.

### 2. A Drága Hiba
A rossz réteg optimalizálása = elégett pénz + elvesztegetett idő. A valódi akadály érintetlenül marad.

**Klasszikus példa:**
- Csökkenő ROAS → új hirdetéseket, új közönségeket, új platformokat tesztelnek (L5)
- Semmi nem működik
- Valódi probléma: az ajánlatban nincs sürgősség (L4) vagy a termék nem megkülönböztetett (L3)

### 3. Az Irány Szabály
A problémák kifelé áramlanak. A javítások befelé haladnak. Javítsd a legmélyebb akadályt először. A külső réteg javítások kidobott pénz, ha a belső rétegek töröttek.

### 4. A Brand Overlay, Nem Réteg
A brand az L3-L7 összehangolásából születik. A "gyenge a brand" mindig réteg-eltérés tünete, soha nem önálló probléma.

### 5. A Pozíció Overlay, Nem Réteg
Pozíció = a piac percepciója arról, hol állsz. Az Identitás (L2) × Termék (L3) × Ajánlat (L4) összehangolásából születik. Nem "javítod a pozicionálást" — javítod az alatta lévő rétegeket, és a pozíció követi. A régi kérdés "Miért mi, nem ők?" konkrétan így válaszolódik meg: az identitásunk világos (L2), a termékünk más (L3), az ajánlatunk meggyőző (L4).

### 6. A Rétegek Kapcsolódnak, Nem Lineárisak
A problémák kaszkádolnak, erősítik egymást és kölcsönhatásba lépnek. A Mintázat Térkép megmutatja a kapcsolatokat — nem csak egy réteg-státusz checklista.

### 7. Az L2↔L6 Identitás Híd
A cég Identitása (L2) összhangban kell legyen az ügyfél vágyott Identitásával (L6). Ha ezek ütköznek, semmi köztük nem számít — az ügyfél nem fog vásárolni, függetlenül a termék, az ajánlat vagy a csatornák minőségétől. A nagy márkák ezt a hidat tudatosan építik. A gyenge márkák hagyják véletlenül megtörténni — és meglepődnek, amikor "tökéletes" kampányok kudarcot vallanak.

### 8. A Versenytárs Mátrix
A versenytárs-elemzés NEM része az L7-nek. Az L7 makro piaci erőkről szól. A versenytársak párhuzamos mátrixban kerülnek elemzésre L2–L6 mentén — egy oszlop versenytársanként, egy sor rétegenként. Ez az 1D diagnózist 2D stratégiai térképpé alakítja, ami feltárja a réseket, nyílásokat és strukturális blokádokat.

### 9. Az Árnyék
Minden rétegnek van egy "Árnyékja" — egy rejtett feltételezés, amit az ügyfél tart, ami megakadályozza, hogy lássa a valódi problémát. A diagnózis része, hogy az Árnyékot láthatóvá tedd.

---

## Versenytárs Mátrix (2D Elemzés)

A 7 Rétegű modell alapértelmezetten egydimenziós — egy céget elemez. A Versenytárs Mátrix kétdimenzióssá teszi: az ügyfél az egyik oszlop, a főbb versenytársak párhuzamos oszlopok, L2–L6 mentén elemezve.

### Miért Létezik Ez

A versenytárs-elemzés NEM tartozik az L7-be. Az L7 makro piaci erőkről szól. Ha a versenytárs-adatokat az L7-be zsúfoljuk, az ügyfél nem tudja feldolgozni — minden adathalmazzá válik.

A Versenytárs Mátrix vizuális, áttekinthető képet ad: hol vannak rések? Hol blokkolják az ügyfelet? Hol van nyílás, amit egyetlen versenytárs sem foglalt el?

### Felépítés

```
VERSENYTÁRS MÁTRIX: [Ügyfél] vs. Piac

| Réteg              | [Ügyfél]    | [Versenytárs A] | [Versenytárs B] | [Versenytárs C] | Rés/Lehetőség |
|--------------------|-------------|------------------|------------------|------------------|---------------|
| L6: Ügyfél         | [megállapítások] | [megállapítások] | [megállapítások] | [megállapítások] | [hol a rés?] |
| L5: Csatornák      | [megállapítások] | [megállapítások] | [megállapítások] | [megállapítások] | [hol a rés?] |
| L4: Ajánlat        | [megállapítások] | [megállapítások] | [megállapítások] | [megállapítások] | [hol a rés?] |
| L3: Termék         | [megállapítások] | [megállapítások] | [megállapítások] | [megállapítások] | [hol a rés?] |
| L2: Identitás      | [megállapítások] | [megállapítások] | [megállapítások] | [megállapítások] | [hol a rés?] |

L7 (Piac) mindenkire ugyanaz — a makro erők mindenkit egyformán érintenek.
L1 (Mag) belső — a versenytársak L1-je kikövetkeztethető nyelvi markerekből, de közvetlenül nem megfigyelhető.
```

### Mikor Használd

- **Mód 2 (Mintázat Térkép):** Mindig készíts Versenytárs Mátrixot 3–6 főbb versenytársra. Nagy piacoknál (kiskereskedelem, e-kereskedelem) térképezz fel 5–10+-t, beleértve a kis, feltörekvő szereplőket.
- **Mód 3 (Constraint Drill):** Ha az akadály L3-L5-nél van, a mátrix feltárja, hogy cég-specifikus probléma-e vagy piaci szintű mintázat.
- **Stratégiai megbízásoknál (Wallis, Diego, Euronics méret):** A mátrix MAGA a stratégiai eszköz — megmutatja, hol tud az ügyfél nyerni és hol blokkolják strukturálisan.

### Kulcs Felismerés

Ha a mátrix EGYETLEN rétegen sem mutat rést — nincs nyílás, ahol az ügyfél legyőzi a versenytársakat — akkor a diagnózis átvált: nem "javítsd a marketinget", hanem "változtasd meg a játékot." Vagy találj egy új pozicionálási szöget, amit a versenytársak nem tudnak követni, vagy fogadd el, hogy a piaci pozíció zsugorodik.

> "Ha a versenytársat minden rétegen végignézed, és nincs rés, amit kihasználhatnál, a válasz nem a jobb hirdetés. A válasz: változtass valami alapvetőt, vagy lépj ki."

---

## Gyakori Kaszkád Mintázatok

### "A Hirdetések Nem Működnek" Kaszkád
```
L1: Senki nem birtokolja a marketing stratégiát (Core)
        │
        ▼
L3: A termék nem megkülönböztetett (Product)
        │
        ▼
L5: A hirdetések áron versenyeznek, mert semmi más nem különböztet meg (Channels)
        │
        ▼
TÜNET: "A hirdetések nem működnek, ROAS csökken"
```

### "Nem Tudunk Nőni" Kaszkád
```
L1: Alapító hite: "nem kérhetünk többet" (Core)
        │
        ▼
L2: Identitás nem tiszta, az érték nincs kommunikálva (Identity)
        │
        ▼
L4: Alulárazott ajánlat, nincs sürgősség (Offer)
        │
        ▼
TÜNET: "Nem tudunk túllépni ezen a bevételi plafonon"
```

### "A Brand Nem Kapcsolódik" Kaszkád
```
L1: "Mindenkié vagyunk" hit (Core)
        │
        ▼
L6: Nincs konkrét ügyfél-definíció (Customer)
        │
        ▼
L3: A termék mindent akar megoldani (Product)
        │
        ▼
L5: Szétszóródás minden csatornán (Channels)
        │
        ▼
TÜNET: "A brand nem rezonál"
```

### "A Marketing Ügynökség Kudarcot Vallott" Kaszkád
```
L1: Nincs belső stratégiai tulajdonos (Core)
        │
        ▼
L2: Az identitás és értékajánlat nem egyértelmű — az ügynökség találgat (Identity)
        │
        ▼
L5: Az ügynökség rossz metrikát optimalizál, rossz rétegen (Channels)
        │
        ▼
TÜNET: "Harmadik ügynökség, ugyanaz az eredmény"
```

---

## Valós Példák

### Feldobox
**Ügyfél kérdése:** "Tudunk Karácsony mellett is skálázni a költéssel?"

```
L7: "Karácsony = ajándék szezon" (hiedelem)
        │
        ▼
L6: Csak karácsonyi ügyfél-fókusz ◄── ELSŐDLEGES AKADÁLY
        │
        ▼
L1: Nincs egész éves versenytárs-követés
        │
        ▼
L2: Weboldal túl visszafogott — az identitás és az érték nem látható (Identity)
        │
        ▼
L4: Nincs sürgősség az ajánlatban (Offer)
        │
        ▼
TÜNET: "Nem tudunk Karácsonyon kívül skálázni"
```

### Euronics
**Ügyfél kérdése:** "CPC emelkedik, nem tudunk ROAS-szal skálázni"

```
L1: Túl széles targeting (Core)
        │
        ▼
L3: Nem különbözik a MediaMarkt-tól/Alzá-tól (Product)
        │
        ▼
L5: Áron versenyez = magas CPC-k (Channels)
        │
        ▼
L4: Nincs mérés, mi működik (Offer)
        │
        ▼
TÜNET: "Nem tudunk nyereségesen skálázni"
```

---

## Integráció Más Skillekkel

```
/7layer (Mód 1)  →  Belépési pont. Nexus: Diagnostic (röntgen). 48 óra.
/7layer (Mód 2)  →  Teljes Mintázat Térkép — Nexus: Strategy szint.
/7layer (Mód 3)  →  Mélyfúrás — Nexus: Foundation/Insight/Optimize szint.

DIAGNÓZIS UTÁN:
/7layer → Vevőkutatás        Térképezd fel az ügyfél valódi célját (ha L6 az akadály)
/7layer → /build-brand       Építsd újra az identitást és pozíciót (ha L2 az akadály)
/7layer → Ajánlat-finomítás  Építsd újra az ajánlatot (ha L4 az akadály)
/7layer → /analyze-gtm       Ellenőrizd a GTM összehangolást a Mintázat Térképpel
/7layer → /plan-gtm          Építs végrehajtási tervet a diagnózisból
/7layer → Belief tracing     Találd meg az L1 hitet, ami mindent blokkol (ha L1 az akadály)
/7layer → Copy analízis      Ellenőrizd, hogy az üzenetek tükrözik-e a javítást

KOMBINÁLÁS VEVŐKUTATÁSSAL:
Vevőkutatás (milyen célra alkalmazzák az ügyfelek) + /7layer (hol törött a marketing)
= Teljes diagnózis: mit kellene mondanunk + hol vallunk kudarcot, hogy elmondjuk
```

---

## A The Fixer Alkalmazás

### Térkép (Map) — 1-2. hónap
Futtasd a `/7layer` Mód 1-et először: ez a **Nexus: Diagnostic** — a 48 órás röntgen. Aztán Mód 2-t (Mintázat Térkép) a teljes képért. Ez MAGA a Térkép fázis — láthatóvá tenni a láthatatlant.

### Rendszer (System) — 2-4. hónap
Használd a Mód 3-at (Constraint Drill) minden javítandó rétegre, mélységi sorrendben. Ez a **Nexus: Foundation** (L1+L2), **Nexus: Insight** (L3+L4), vagy **Nexus: Optimize** (L5+L6) szint, attól függően, melyik réteg az akadály. A **Nexus: Strategy** (L1-L6 teljes) az, ha az egész rendszert kell felépíteni. A **Nexus: Core** (L7) a piaci szintű elemzés.

### Változás (Change) — Folyamatos
A Mintázat Térkép lesz az operációs rendszer. Hetente: "Melyik rétegen dolgozunk? Mi változott? Mi a következő akadály?" A marketing kontrollálhatóvá válik, nem kaotikus.

### Nexus Terméklétra *(SUPERSEDED 2026-04-17)*

> **⚠ Az alábbi „Nexus" tier-struktúra 2026-04-17-ével retired.** Aktuális commercial stack: **Pattern Check / First Signal / AOS Setup / The Fixer / Custom** — lásd `internal/strategy/BUSINESS_MODEL.md` v1.1 + `core/methodology/ENGAGEMENT_MAP.md`. A tábla történelmi referenciaként marad (a 7-Layer mapping logika érvényes, csak a termék-nevek cserélődtek).

| Termék *(régi név)* | Rétegek | Ár *(régi)* | Mikor |
|--------|---------|-----|-------|
| **Nexus: Morsel** → Pattern Check | Felszíni scan | Ingyenes | Lead gen — első benyomás |
| **Nexus: Diagnostic** → First Signal | Mind a 7 feltérképezve | €497 | Mintázat Térkép + hol kell indulni |
| **Nexus: Foundation** → *Custom (L1+L2 focus)* | L1 + L2 (Core + Identity) | egyedi | "Nem tudjuk, kik vagyunk és mit érünk" |
| **Nexus: Insight** → *Custom (L3+L4 focus)* | L3 + L4 (Product + Offer) | egyedi | "A termékünk jó, de nem fogy" |
| **Nexus: Optimize** → *Custom (L5+L6 focus)* | L5 + L6 (Channels + Customer) | egyedi | "Minden csatornán ott vagyunk, de nem működik" |
| **Nexus: Strategy** → The Fixer | L1-L6 teljes | €5-6K/hó | "Mindenen dolgozunk egyszerre" |
| **Nexus: Core** → *Custom (L7 focus)* | L7 | egyedi | "Mindent jól csinálunk, mégis akadunk" |

---

## Ha Nincs Üzleti Kontextus

Kérdezd meg:
> "Milyen vállalkozást diagnosztizáljak? Szükségem van:
> - Mit árulnak
> - Kinek (ha ismert)
> - Jelenlegi marketing kihívások vagy tünetek
> - Bármilyen adatpont (bevétel, forgalom, konverzió, költés)
> - Mit próbáltak már
>
> Vagy csak küldd el a weboldalukat — onnan is el tudok indulni."
>
>
