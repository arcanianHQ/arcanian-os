---
scope: shared
---

# Arcanian Ops — Client Directory

> Central lookup for all clients: names, domains, tracking IDs, key contacts.
> Quick reference — full details in each client's `CLIENT_CONFIG.md`.
> **CONFIDENTIAL** — internal use only.
> Updated: 2026-03-23

---

## All Clients

| # | Client | Hub path | Primary domain | GA4 | Google Ads | Meta Pixel | GTM Web | sGTM |
|---|---|---|---|---|---|---|---|---|
| 1 | AH Tuning | `clients/ah-tuning-qwallz/` | ah-tuning.eu | G-9Y8FEDHPJ | — | — | GTM-TCBKRN76 | GTM-PDFLF94B |
| 2 | Bankmonitor | `clients/bankmonitor/` | bankmonitor.hu | — | — | — | — | — |
| 3 | Damanhur | `clients/damanhur/` | — | — | — | — | — | — |
| 4 | Deluxe / Kocsibeálló | `clients/deluxe/` | kocsibeallo.hu, deluxebuilding.hu | — | — | — | — | — |
| 5 | Diego | `clients/diego/` | diego.hu, diego.ro, diego.sk | Multiple | Multiple | Multiple | GTM-5F544SR3 (HU) | Stape |
| 6 | FelDoBox | `clients/feldobox/` | feldobox.hu | — | — | — | — | — |
| 7 | Flora MiniWash | `clients/flora-miniwash/` | floraminiwash.com | — | — | — | — | — |
| 8 | JAF Holz | `clients/jafholz/` | jafholz.hu | — | — | — | — | — |
| 9 | Mancsbázis | `clients/mancsbazis/` | mancsbazis.hu | G-PNY341BP59 | AW-16723055585 | 1695059188017463 | GTM-5F544SR3 | GTM-5PC29CQH (TAGGRS) |
| 10 | Qwallz | `clients/qwallz/` | qwallz.eu | — | — | — | — | — |
| 11 | VRSoft | `clients/vrsoft/` | vrsoft.hu | — | — | — | — | — |
| 12 | VRSoft SK | `clients/vrsoftsk/` | — | — | — | — | GTM-NBP7VQG | — |
| — | **Wellis** | `_wellis_full/` (not in hub) | buenospa.com, wellis.hu, +6 more | Multiple (8 properties) | 4 accounts (MCC 558-452-5699) | Multiple | 22+ containers | Planned (sst.buenospa.com) |

---

## Key Contacts (quick lookup)

| Client | Decision maker | Developer / Tech | Agency |
|---|---|---|---|
| AH Tuning + Qwallz | Hamed Aryan András | Same (Aryan) | — |
| Bankmonitor | — | — | — |
| Deluxe | Péter (owner) | Devin (Drupal), Zsuzsi (design) | — |
| Diego | Péteri Orsolya + Magdolna | ITG (Halász Jenő) | BP Digital (SEO) |
| FelDoBox | Konrád Péter | — | — |
| Flora MiniWash | — | — | — |
| JAF Holz | — | — | — |
| Mancsbázis | Kohut Richárd (Ricsi) | Ricsi (Unas) | — |
| VRSoft | Kohut Balázs | Darago Sándor (Sanyi) | — |
| Wellis | Gesztesi Gábor (MD) | Teplitzki Péter (Shopify) | GD (PPC), BP Digital (SEO), Intren (terminating) |

---

## Platforms by Client

| Client | CRM | E-commerce | Measurement | Ads |
|---|---|---|---|---|
| AH Tuning | — | WooCommerce | GA4 + sGTM | Google + Meta |
| Deluxe | HubSpot | Drupal (kocsibeallo.hu) | — | Meta |
| Diego | — | Magento (HU/RO/SK) | GA4 + sGTM (Stape) + Channable | Google + Meta |
| Mancsbázis | — | Unas | GA4 + sGTM (TAGGRS) | Google + Meta |
| VRSoft | — | Unas | GA4 + sGTM | Google + Meta |
| Wellis | ActiveCampaign | Shopify (BuenoSpa) | GA4 + Databox + Roivenue + Windsor | Google + Meta (8 markets) |

---

## Engagement Type

| Type | Clients |
|---|---|
| The Fixer | Wellis |
| Measurement audit | Diego, Mancsbázis, AH Tuning, Qwallz, VRSoft, VRSoft SK |
| Strategic consulting | Deluxe, FelDoBox, Bankmonitor |
| Diagnostic only | Flora MiniWash, JAF Holz |
| Placeholder | Damanhur |

---

## Missing CLIENT_CONFIG.md

These clients need a full CLIENT_CONFIG.md created (use template: `core/templates/CLIENT_CONFIG_TEMPLATE.md`):

- [ ] Bankmonitor
- [ ] Damanhur
- [ ] Deluxe
- [ ] FelDoBox
- [ ] Flora MiniWash
- [ ] JAF Holz
- [ ] VRSoft SK

---

> Full details per client: `clients/{slug}/CLIENT_CONFIG.md`
> Contact details per client: `clients/{slug}/EXTERNAL-CONTACTS-TABLE.md` or in CLIENT_CONFIG contacts section
> Template: `core/templates/CLIENT_CONFIG_TEMPLATE.md`
