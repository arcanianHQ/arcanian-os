> v1.0 — 2026-04-06

# Temporal Awareness Rule — MANDATORY for all analysis

> **"Mikor" éppoly fontos, mint "mennyit".**
> Minden elemzésben a dátumok, időszakok, szezonalitás és naptári események figyelembevétele KÖTELEZŐ.
> Egy szám kontextus nélkül nem adat, hanem zaj.

---

## Mikor alkalmazza

MINDEN skill ami adatot elemez. Különösen:
- , /analyze-gtm, /sales-pulse, /health-check, /morning-brief
- /seo-diagnose, /seo-decay, /seo-anomaly
- , /verify-pmf
- /7layer, /council, /client-report
- Bármely freeform adatelemzés

## Step 1: A mai nap azonosítása

**Minden elemzés elején állapítsd meg:**

1. **Mai dátum** — év, hónap, nap, hét napja
2. **Milyen hét van?** — átlagos munkahét, vagy:
   - Ünnep (Húsvét, Karácsony, Újév, nemzeti ünnepek)
   - Iskolai szünet
   - Black Friday / Cyber Monday hét
   - Hónap vége / negyedév vége
   - Nyári szezon (Jun-Aug) / téli szezon (Nov-Jan)
3. **Milyen hét VOLT az elemzett periódusban?** — ugyanez visszamenőleg

## Step 2: Periódus-pontosság

**SOHA ne használj relatív időt pontosítás nélkül:**

| ❌ Rossz | ✅ Helyes |
|---|---|
| "Az elmúlt 90 nap" | "Jan 6 – Ápr 6, 2026 (90 nap)" |
| "Múlt hónap" | "2026 március (31 nap)" |
| "Előző periódus" | "2025 október 7 – 2026 január 5 (91 nap)" |
| "A forgalom esett" | "A forgalom 38%-ot esett Jan (68K) → Feb (40K)" |
| "Szezonális csúcs" | "Szezonális csúcs: Május-Június (3 év igazolja: 2024, 2025, 2026)" |

**Minden "előző periódus" összehasonlításnál:**
- Írd ki pontosan melyik dátumtól melyikig
- Azonos hosszúságú-e a két periódus?
- Van-e ünnep/szezonális eltérés a kettő között?

## Step 3: Naptári kontextus

**Minden elemzett periódusra ellenőrizd:**

### Ünnepek és események (a piacnak megfelelően)

**US piac:**
| Esemény | Dátum | Hatás |
|---|---|---|
| Újév | Jan 1 | -30-50% aktivitás a hét körül |
| MLK Day | Jan 3. hétfő | US munkaszünet |
| Presidents' Day | Feb 3. hétfő | US munkaszünet |
| Easter / Húsvét | Változó (Már-Ápr) | -30-50% EU, kisebb hatás US |
| Memorial Day | Máj utolsó hétfő | Nyári szezon kezdete |
| Independence Day | Jul 4 | -40% |
| Labor Day | Szep 1. hétfő | Nyári szezon vége |
| Halloween | Okt 31 | Kisebb hatás B2B-re |
| Thanksgiving | Nov 4. csütörtök | -50% a héten, Black Friday utána |
| Black Friday/Cyber Monday | Nov utolsó péntek + hétfő | E-commerce csúcs |
| Karácsonyi szezon | Dec 15 – Jan 2 | -30-60% B2B |

**HU piac:**
| Esemény | Dátum | Hatás |
|---|---|---|
| Újév | Jan 1 | -50% |
| 1848-as forradalom | Már 15 | Munkaszünet |
| Húsvét | Változó | -40-50% (Nagypéntek + Húsvéthétfő) |
| Munka ünnepe | Máj 1 | Munkaszünet |
| Pünkösd | Változó (Máj-Jún) | -30% |
| Szt. István | Aug 20 | -40% + nyári csúcs |
| Okt 23 | Okt 23 | Munkaszünet |
| Mindenszentek | Nov 1 | Munkaszünet |
| Karácsony | Dec 24-26 | -60% |

### Szezonalitási minták (iparágtól függő)

**E-commerce (outdoor living — SolarNook):**
- Csúcs: Máj-Jún (nyári felkészülés) + Nov (Black Friday)
- Mélypont: Okt (pre-holiday csend) + Jan post-holiday

**LinkedIn aktivitás:**
- Csúcs: Kedd-Csütörtök, Jan-Már + Szep-Nov
- Mélypont: Hétvége, Jul-Aug (nyár), Karácsonyi hét, Húsvéti hét

**Google Ads / Meta:**
- Q4 CPM emelkedés (Black Friday verseny)
- Jan CPM csökkenés (budget reset)

## Step 4: Anomália vs szezonalitás megkülönböztetés

**Mielőtt anomáliát jelzel:**

1. **Van-e naptári magyarázat?** — Ha a "visszaesés" húsvéti hétre esik, az nem anomália
2. **Volt-e ugyanez tavaly?** — Ha igen, szezonális minta, nem probléma
3. **Mekkora az eltérés a szezonális normától?** — 30% esés húsvétkor = normális. 60% esés húsvétkor = anomália a szezonalitáson FELÜL.

| Helyzet | Verdikt |
|---|---|
| -40% session húsvéti héten | Szezonális — NEM anomália |
| -40% session átlagos héten | Anomália — vizsgáld |
| -70% session húsvéti héten | Szezonális (-40%) + anomália (-30%) — vizsgáld a 30%-ot |
| +50% session Black Friday héten | Szezonális — NEM anomália |

## Step 5: Kimondani amit tudunk a dátumról

**Minden elemzés output-jába:**

```
## TEMPORAL CONTEXT
- Elemzett periódus: {exact dates}
- Mai nap: {date, day of week}
- Naptári események a periódusban: {holidays, seasons}
- Szezonális korrekció alkalmazva: {yes/no, details}
- Összehasonlítási periódus: {exact dates} — azonos hossz: {yes/no}, azonos szezonalitás: {yes/no}
```

---

## Az anti-pattern amit ez megelőz

> Az elemzés kimutat egy 38%-os forgalomcsökkenést, és 7 action item-et generál a kampányok javítására.
> Valójában az egész húsvéti hétre esett, és jövő héten magától visszaáll.
> A 7 action item felesleges volt — a naptár megmondta volna.

---

*"A Nap művelete permanens fénymegnyilatkozás." (Tabula Smaragdina)*
*A Nap tudja, hogy mikor kel és mikor nyugszik. A rendszernek is tudnia kell.*
