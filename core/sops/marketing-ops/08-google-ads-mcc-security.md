---
scope: shared
---

# 08 — Google Ads MCC Security

> Post-incident SOP based on the April 2026 MCC hijack (INC-2026-001).
> Owner: Fractional CMO | Tier: 1 | Review: Quarterly

## Purpose
Prevent unauthorized access to Google Ads MCC accounts and minimize damage if a compromise occurs. Based on real-world incident where a single compromised Admin account led to 93 unauthorized users, 90 fraudulent campaigns, and 260.9M HUF/day potential exposure across 36 client accounts.

## Lesson Learned
Two separate Google accounts both having Admin on the MCC provides zero additional security. If either is compromised, the attacker has full control. **Separation only works with separation of privilege.**

## Critical Architecture: Three Separate Identities

| Function | Email | Domain | Why separate |
|---|---|---|---|
| **Password manager admin** | `vault-admin@domain-a.com` | Domain A | If compromised, attacker gets all passwords — must be isolated |
| **Google Ads MCC admin** | `ads-admin@domain-b.com` | Domain B | If compromised, attacker gets ad accounts — but not passwords or email |
| **Google Workspace admin** | `admin@domain-c.com` | Domain C | If compromised, attacker gets email/Drive — but not ad accounts or passwords |

**Three different domains, three different email addresses, three different passwords, three different 2FA methods.** Compromising one gives zero access to the other two. This is the only architecture that survives a single-point compromise.

### Mandatory: Password Manager (1Password)

- **Every account must use a unique, generated password** (min 20 characters) stored in 1Password
- **No password in browser autofill** — only 1Password fills credentials
- **1Password admin account on a separate email/domain** from all other systems
- **1Password emergency kit** stored physically offline (printed, safe)
- **Never store Google Workspace or MCC passwords anywhere except 1Password** — no notes, no documents, no shared messages

### Mandatory: Hardware Security Key (FIDO2)

All critical accounts must use a **physical hardware security key** (YubiKey, Google Titan, etc.) as:
- **Passkey** — fizikai kulcs a bejelentkezéshez
- **2FA second factor** — jelszó + fizikai kulcs együtt kell
- **A hardware kulcs maga is PIN-kóddal / jelszóval védett** — ha ellopják a kulcsot, PIN nélkül nem használható

| Account | Hardware key required |
|---|---|
| Google Workspace admin | **Yes** |
| Google Ads MCC admin | **Yes** |
| 1Password admin | **Yes** |
| Primary email (daily work) | **Yes** |
| GitHub, Tailscale, other infra | **Yes** |

- **Minimum 2 hardware keys** — one primary (on keychain), one backup (in safe)
- **Disable authenticator app** as 2FA method on critical accounts — authenticator apps can be added by attackers (as happened in this incident). Hardware keys cannot.
- **Disable SMS as 2FA** — SIM swap attacks can bypass it
- **Disable device prompt as 2FA / login challenge method** — in this incident the attacker knew the password and triggered a device prompt, which was approved (intentionally or accidentally) on one of the owner's devices. Device prompts appear as easy-to-tap popups on phones and Chrome browsers — one accidental tap grants full access. **Only hardware keys should be accepted as second factor.** With Google Advanced Protection Program enabled, device prompt is automatically disabled.
- **Google Advanced Protection Program** on all Google accounts — enforces hardware key only, blocks all other login methods including device prompt, authenticator apps, and SMS

---

## MCC Access Architecture

### Rule 1: Single Admin, Minimum Privilege

| Role | Access Level | Who |
|---|---|---|
| **MCC Owner/Admin** | Admin | ONE dedicated account only (e.g., `ads-admin@domain.com`) |
| **Day-to-day management** | Standard | Working accounts (personal Workspace emails) |
| **Client reporting** | Read only | Client-facing accounts, info@ addresses |
| **Client contacts** | Read only | Client's own people |

**Never give Admin to more than one account.** If you need backup, use Google Workspace super-admin to recover — not a second Admin on the MCC.

### Rule 2: Dedicated MCC Admin Account

The MCC Admin account must be:
- A **separate Google account** used ONLY for Google Ads administration
- **Not used for email, Drive, Calendar, or any other service** — if compromised, the attacker gets nothing else
- Protected with **Google Advanced Protection Program**
- **Not logged into any browser** — only accessed when Admin actions are needed, then logged out
- Password stored in password manager only — never in browser autofill

### Rule 3: Domain Restriction

- Allowed domains on the MCC: **only your business domain(s)**
- **NEVER add gmail.com** to the allowed domains list
- Review allowed domains quarterly

### Rule 4: Client Account Isolation

- Every client must have **their own Admin** on their account (not just MCC access)
- Client payment methods on **client's own account**, not MCC-level billing
- **Account-level budget limits** set on every client account (prevents 260M HUF/day scenarios)
- Clients can unlink from MCC independently if compromise is detected

---

## Google Workspace Hardening (for accounts with MCC access)

### Authentication
- [ ] **Google Advanced Protection Program** enabled
- [ ] **FIDO2 security keys** (hardware) — not just authenticator apps (authenticator apps can be added by attackers)
- [ ] **Session length**: max 8 hours (Admin → Security → Google session control)
- [ ] **Login challenges** enabled for suspicious activity

### OAuth & Third-party Apps
- [x] **OAuth app whitelist** enabled:
  - Admin → Security → API controls → Settings → Unconfigured third-party apps: **"Don't allow users to access any third-party apps"**
  - Internal apps: **Trust internal apps**
  - User requests to access unconfigured apps: **Allow users to request access** (admin reviews)
  - All used apps must be individually configured as Trusted in App access control
- [ ] Quarterly review: revoke unused OAuth connections
- [ ] **No browser extensions** in the Chrome profile used for Google Ads

### Monitoring & Alerts
- [ ] **Alert Center** fully configured (Admin → Security → Alert center)
- [ ] New device login → immediate SMS + push notification to personal phone
- [ ] Authenticator app change → immediate alert
- [ ] User access change on Google Ads → email alert (do NOT block ads-account-noreply@google.com)
- [ ] **Weekly security review**: Monday 5min — check devices, login activity, alerts
- [x] **Chrome Enterprise reporting** enabled (Admin → Devices → Chrome → User and browser settings):
  - Managed browser reporting: **Enable**
  - Event reporting: **Enable**
  - Data controls reporting: **Enable**
  - Metrics reporting: **Always report** (User override not allowed)
  - Without these, Chrome audit logs are empty — as discovered in INC-2026-001

### Gmail Protection (if Workspace email is used)
- [ ] **No forwarding** rules (check quarterly)
- [ ] **No delegated access** (check quarterly)
- [ ] **No filters** that auto-delete or skip inbox for security emails
- [ ] Recovery email set to a **different domain** than the Workspace
- [ ] Recovery phone confirmed and current

---

## Incident Response Checklist

If you suspect MCC compromise:

### First 10 minutes
1. [ ] Change password on compromised account
2. [ ] Check Security → 2-Step Verification → remove unknown authenticator apps
3. [ ] Check Security → Your devices → sign out unknown devices
4. [ ] Suspend the account in Google Workspace Admin (if possible)

### First hour
5. [ ] Check Gmail: forwarding, filters, blocked addresses, delegated access
6. [ ] Check OAuth: third-party app connections
7. [ ] Check recovery phone/email — not changed by attacker?
8. [ ] Report every affected Google Ads account to Google Support
9. [ ] Document: screenshot everything before it changes

### First day
10. [ ] File police report (Btk. 375. §, 423. §, 422. §)
11. [ ] File NAIH data protection incident report (GDPR Art. 33 — 72h deadline)
12. [ ] Notify all affected clients
13. [ ] Export all evidence: access reports, change history, campaign reports, login audit logs

### Recovery
14. [ ] New MCC with new dedicated Admin account
15. [ ] Re-link client accounts from new MCC (verify by phone with each client)
16. [ ] Set domain restrictions on new MCC
17. [ ] Set account-level budget limits on all client accounts
18. [ ] Full browser extension audit on all devices

---

## Quarterly Security Audit

| Check | How |
|---|---|
| MCC allowed domains | Settings → Security → only business domain(s), no gmail.com |
| MCC user list | Remove anyone who no longer needs access |
| Admin count | Must be exactly 1 |
| Client account Admins | Each client has their own Admin |
| OAuth connections | Revoke unused apps |
| Workspace devices | No unknown devices |
| Recovery options | Phone and email current |
| Budget limits | Set on every client account |
| Browser extensions | Minimal, reviewed |

---

## Attack Indicators (what to watch for)

| Indicator | What it means |
|---|---|
| New Windows device in "Your devices" | You only use Mac — immediate investigation |
| Authenticator app added | If you didn't add it — account compromised |
| `ads-account-noreply@google.com` blocked in Gmail | Attacker hiding their activity |
| `gmail.com` added to MCC allowed domains | Attacker preparing to add unauthorized users |
| Notification settings changed to "don't receive" | Attacker going stealth |
| Unknown users on MCC with "PP-", "BLA-", "mã cam" campaigns | Vietnamese carding ring signature |
| Impression spike (5x+ normal) | Fraudulent campaigns running |

---

## Forensic Lessons (INC-2026-001 — what we couldn't investigate)

The following could NOT be verified because the source Mac was factory-reset before the incident was discovered:

| Vector | Status | Why unverifiable |
|---|---|---|
| Keylogger / malware | Unknown | Mac wiped |
| Screen Sharing / Remote Management | Unknown | Mac wiped |
| Real-time phishing proxy (Evilginx) | Unknown | No browser history |

**Best practice for future:** Before wiping/replacing ANY device that was logged into a compromised account, first:
1. Run Malwarebytes full scan and save report
2. Screenshot: System Settings → Sharing (Screen Sharing, Remote Management)
3. Screenshot: chrome://extensions/
4. Export: Chrome browsing history for the last 30 days
5. Screenshot: System Settings → Login Items
6. Check: Activity Monitor for unknown processes

**A device is evidence. Don't destroy it before investigation.**

---

## New Infrastructure Setup Checklist (Day 1 after incident)

### New domain & accounts
- [ ] Register new domain for business operations
- [ ] Set up new Google Workspace on new domain
- [ ] Create dedicated MCC Admin account on separate domain
- [ ] 1Password vault admin remains on its own separate domain
- [ ] Verify: three identities on three domains, zero overlap

### Hardware keys
- [ ] Purchase 2x YubiKey (or Google Titan)
- [ ] Register both keys on all critical accounts
- [ ] Set PIN on both keys
- [ ] Store backup key in physical safe
- [ ] Enable Google Advanced Protection Program on all Google accounts
- [ ] **Disable** authenticator app as 2FA method (hardware key only)
- [ ] **Disable** SMS as 2FA method

### New MCC setup
- [ ] Create new MCC under dedicated Admin account
- [ ] Set allowed domains: only new business domain (NO gmail.com)
- [ ] Send link requests to client accounts — **verify by phone** before client accepts
- [ ] Set account-level budget limits on every client account
- [ ] Each client has their own Admin on their account

### Google Workspace hardening
- [ ] Google Advanced Protection Program: ON
- [ ] Session length: 8 hours max
- [ ] OAuth app whitelist: ON (only pre-approved apps)
- [ ] Chrome Enterprise reporting: ON
- [ ] Alert Center: all alerts ON, notifications to personal phone
- [ ] Login challenge for suspicious activity: ON
- [ ] Recovery email: set (on different domain)
- [ ] Recovery phone: confirmed

### Device hygiene
- [ ] Dedicated Chrome profile for Google Ads — zero extensions
- [ ] 1Password fills credentials — browser autofill OFF
- [ ] Google notifications ON on phone (never disable again)
- [ ] Malwarebytes installed for periodic scans

### Client communication
- [ ] Template: incident notification (version 1 — initial alert)
- [ ] Template: suspension notification (version 2 — account frozen)
- [ ] Template: status update (version 3 — progress)
- [ ] Template: resolution (version 4 — all clear)
- [ ] Pre-agreed verification phrase with each client (for phone confirmation)

### Monitoring (ongoing)
- [ ] Monday 5min security review: devices, alerts, login activity
- [ ] Quarterly: MCC user audit, domain restrictions, OAuth review, budget limits
- [ ] haveibeenpwned.com "Notify Me" enabled for all business emails
- [ ] Databox alert: daily spend anomaly (>200% of baseline)

---

## Google Workspace Security Policies (Admin Console)

### Mandatory policies (Admin → Security → Authentication)

#### Google Workspace Admin Console → Security → Authentication → 2-Step Verification

**Exact settings (mandatory):**

| Setting | Value | Why |
|---|---|---|
| Allow users to turn on 2-Step Verification | **[x] Checked** | Users can enroll |
| Enforcement | **On** | 2SV required for all users |
| New user enrolment period | **1 day** | New users must enroll within 24h |
| **Frequency: "Allow the user to trust the device"** | **[ ] UNCHECKED** | **Prevents trusted device bypass — 2FA required EVERY session. In INC-2026-001, a trusted device could have been used to skip 2FA.** |
| **Methods** | **"Only security key"** | **CRITICAL: This disables device prompt, authenticator app, AND SMS. Only hardware security key (FIDO2/passkey) is accepted. This single setting would have prevented the entire INC-2026-001 attack — the attacker had the password but could not have bypassed hardware key verification.** |
| 2-Step Verification policy suspension grace period | **1 day** | Minimal grace period |
| Security codes | **"Allow security codes without remote access"** | Emergency backup — works only on same device/LAN, cannot be used by remote attacker |

**What "Only security key" disables:**
- ❌ "Yes, it's me" device prompt (the attack vector in INC-2026-001)
- ❌ Google Authenticator / any TOTP authenticator app (attacker added their own in INC-2026-001)
- ❌ SMS verification codes (SIM swap vulnerable)
- ❌ Phone call verification
- ✅ ONLY hardware security key / passkey remains

#### Google Workspace Admin Console → Security → Authentication → Advanced Protection Programme

| Setting | Value | Why |
|---|---|---|
| Allow users to enrol in the Advanced Protection Programme | **Enable user enrolment** | Allows users to opt into the highest security level |
| Security codes | **Allow security codes without remote access** | Emergency backup, local only |

After enabling at org level, each user must **individually enrol**: myaccount.google.com → Security → Advanced Protection Programme → Get Started. This requires 2 registered security keys.

Advanced Protection overrides manual 2SV policies with stricter defaults:
- Only security keys accepted (no device prompt, no authenticator, no SMS)
- Third-party app access heavily restricted
- Enhanced email scanning
- Download restrictions in Chrome

#### Google Workspace Admin Console → Security → Authentication → Password management

| Setting | Value | Why |
|---|---|---|
| Enforce strong password | **[x] Checked** | Mandatory |
| Minimum length | **20** | 1Password generates, no need to memorize — maximize strength |
| Maximum length | **100** | Default, fine |
| Enforce password policy at next sign-in | **[x] Checked** | Apply immediately to all users |
| Allow password reuse | **[ ] UNCHECKED** | Never reuse |
| Expiry | **Never expires** | With hardware key + strong password, forced rotation is counterproductive |

#### Other mandatory policies
- [ ] **Sensitive action restrictions:** require re-authentication with hardware key for: changing 2FA settings, adding recovery options, modifying account access
- [x] **Session controls** (all set to 8 hours):
  - Chrome: Admin → Devices → Chrome → User and browser settings → Maximum user session length: **480 minutes**
  - Google Workspace: Admin → Security → Access and data control → Google session control: **8 hours**
  - **Device-Bound Session Credentials (DBSC): ENABLED** — binds session cryptographically to the device. Stolen session cookies cannot be used from another device. **This single setting would have prevented session cookie theft attack vectors in INC-2026-001.**
  - Google Cloud: Admin → Security → Access and data control → Google Cloud session control: **8 hours**

### Mandatory alert rules (Admin → Security → Rules → Activity rules)
- [ ] New device sign-in → alert to admin + personal phone
- [ ] 2FA method added/changed → alert to admin + personal phone
- [ ] Recovery email/phone changed → alert to admin + personal phone
- [ ] Suspicious login (Google-flagged) → **auto-suspend account** (can be re-enabled after verification)
- [ ] Multiple login failures from same IP → alert + temporary block

---

## Google Ads Notification Rules (NEVER CHANGE)

The following Google Ads notification emails must **NEVER be blocked, filtered, or sent to spam**:

| Sender | Purpose |
|---|---|
| `ads-account-noreply@google.com` | Account access changes, security alerts, campaign status |
| `ads-noreply@google.com` | Billing, payment, policy alerts |
| `no-reply@accounts.google.com` | Account security (2FA, password, login) |

**Gmail filter rule:** Create a filter for these addresses → Never send to Spam, Mark as Important, Categorize as Primary.

---

## Reference

- Incident report: `internal/incidents/2026-04-07_google-ads-mcc-hijack.md`
- Feljelentés: `internal/incidents/2026-04-07_feljelentes_google-ads-hijack.md`
- NAIH bejelentés: `internal/incidents/2026-04-08_naih-bejelentes-kitoltesi-utmutato.md`
- Client notification templates: `internal/incidents/2026-04-08_ugyfel-ertesites-*.md`
- Police report: PORTAL-20260408001743410-1673571212-1
- NAIH report: EPAPIR-20260408-49
- Attacker IP: 74.0.48.244 (Netherlands datacenter, Internet Utilities NA LLC, AS40662)
- Attack vector: Google password known + device prompt approved → Workspace compromise → MCC Admin takeover
- Substack breach (Oct 2025) provided attacker with target email address
- Password source: **unknown** — old Mac factory-reset before forensic analysis possible

### Forensic dead end — what remains unexplained

**Password acquisition:** The attacker knew the Google password (confirmed by "Google password" login type — first attempt successful, no prior failures from attacker IP). The attacker did NOT have the security key (used device prompt instead of security key challenge). All known vectors eliminated: unique password (1Password on separate domain), no credential breach (haveibeenpwned: Substack only, email+phone, no passwords), clean browser extensions on current Mac, 1Password not compromised. The attack occurred on the old Mac (setup March 20, replaced March 25-26, wiped immediately) — keylogger/malware/phishing proxy/remote access unverifiable.

**Device prompt approval:** The Google device prompt was approved 3 times in 3.5 minutes. Verified from forensic data:
- Current Mac (setup March 25, in use since March 26): laszlo.fazakas Chrome profile had **0 visits** on March 30 — profile was not open
- Old Mac: already wiped by March 26 — did not exist on March 30
- iPhone: Google notifications were OFF
- Owner does not recall approving any prompt
- **No known device could have displayed or approved the device prompt.** This suggests either: (a) Chrome can receive device prompts at OS level even when the specific profile is not open, (b) the prompt was delivered and approved through a mechanism not visible in Chrome history, or (c) the "Device prompt" label in Google's log does not mean what we assume — it may include real-time phishing proxy interception that Google logs as "Device prompt approved." Only Google's server-side logs can resolve this.

**These questions can only be resolved by the police investigation** through Google's server-side logs, which contain: the device ID that received and approved each prompt, the IP address of the approving device, and the full session handshake details.

### Evidence: automated attack toolkit

The speed and pattern of the attack indicates a **professional, script-based toolkit**, not manual operation:

| Action | Time | Evidence of automation |
|---|---|---|
| Login → 2FA settings modification | 29 seconds | Too fast for manual navigation to Security → 2SV settings |
| Authenticator app added | 14:47:30 (3.5 min after login) | Immediate backdoor installation — pre-planned |
| 93 users invited to MCC | ~30 minutes | Hierarchical invite chains executed in parallel |
| 90 campaigns created across 6 accounts | ~90 minutes | Template-based: identical naming patterns (PP-JN, PP-BLA, mã cam) |
| Campaign daily budgets | 1M-16.5M HUF each | Pre-configured amounts, not manually entered |
| Domain whitelist + admin demotions | <1 minute between actions | Scripted sequence |

The attacker likely used a toolkit containing:
- **Credential-based login automation** with device prompt polling (waits for approval)
- **2FA backdoor installer** (adds authenticator app immediately after login)
- **Google Ads access escalation script** (invite → accept → demote originals)
- **Campaign generator** (template-based mass campaign creation with pre-set budgets)
- **User invitation bot** (hierarchical: create admin → admin invites standard accounts)

This is consistent with known **Vietnamese Google Ads carding ring** toolkits that are sold/shared in underground markets. The campaign naming patterns (PP-JN, PP-BLA, "mã cam", SAIYAN, Oishi, MURONG) appear across multiple compromised MCCs globally.

### Countermeasures against automated attack toolkits

**Against credential-based login automation:**
- [ ] **Google Advanced Protection Program** — blocks all login methods except hardware key. Script cannot bypass physical key tap.
- [ ] **Disable device prompt** as 2FA challenge — the script polls for prompt approval. No prompt = script hangs forever.
- [ ] **Hardware key (FIDO2) only** — attacker must physically possess the key AND know the PIN. No remote automation possible.
- [ ] **Session length max 8 hours** — stolen session tokens expire quickly, script must re-authenticate (which requires hardware key)

**Against 2FA backdoor installation:**
- [ ] **Restrict 2FA method changes** to require re-authentication with hardware key — even if logged in, adding an authenticator app requires physical key tap
- [ ] **Admin alert on any 2FA change** — immediate SMS + push to personal phone. Auto-suspend account if 2FA changed from unrecognized device.
- [ ] **Disable authenticator app enrollment entirely** on critical accounts (hardware key only policy in Workspace Admin)

**Against access escalation (invite/demote scripts):**
- [ ] **Single Admin on MCC** — no second account to escalate from
- [ ] **Domain restriction** — no gmail.com, script cannot invite external accounts
- [ ] **MCC invite rate limiting** — Google does not offer this natively, but monitoring for >5 invites/hour should trigger alert
- [ ] **Admin alert on any user access change** in Google Ads — immediate notification

**Against campaign generator bots:**
- [ ] **Account-level budget limits** on every client account — even if bot creates 90 campaigns with 16M HUF/day budget, account limit of e.g. 50K HUF/day caps actual spend
- [ ] **Databox / monitoring alert** — if daily spend exceeds 200% of baseline, immediate SMS
- [ ] **Campaign naming convention monitoring** — alert on campaign names containing known attack patterns (PP-, BLA-, "mã cam", Bukarest Local store)
- [ ] **Client's own Admin** on their account — client can independently pause/remove suspicious campaigns without waiting for agency

**Against the full attack chain (defense in depth):**
```
Attacker has password
    → BLOCKED: hardware key required (no device prompt to approve)

Attacker somehow gets past hardware key (physical theft)
    → BLOCKED: hardware key has PIN (attacker doesn't know it)

Attacker knows password + has key + knows PIN
    → DETECTED: alert on new device login → auto-suspend
    → BLOCKED: 2FA change requires second key tap → alert fires
    → CONTAINED: MCC has single Admin on separate domain → no lateral movement
    → LIMITED: account-level budget caps → max damage capped
    → VISIBLE: all Google Ads notifications active → anomaly detected in minutes
```

With all countermeasures in place, an attacker would need to: know the password + physically steal the hardware key + know the PIN + bypass auto-suspend + compromise a second domain for MCC access — all before the monitoring alerts fire. This reduces the attack surface from "one compromised password" to "physically impossible without insider access."

---

### Evidence: attacker knew the Google password

Google Workspace User log events (login audit) — first attacker login:

```
Date:      2026-03-30T14:44:09+02:00
Event:     Login success
Login type: Google password          ← jelszóval történt, nem tokennel
Challenge:  Password, Device prompt   ← két lépés: jelszó megadása + device prompt
IP:         74.0.48.244               ← támadó IP (Holland datacenter)
Suspicious: true
```

A "Login type: Google password" a Google szerver oldali logja — azt jelenti, hogy a bejelentkezési oldalon **valaki beírta a helyes jelszót**. Ha session cookie-val, OAuth tokennel vagy passkey-jel lépett volna be, a login type "Reauth", "Exchange" vagy "SAML" lenne.

A jelszó megszerzésének módja nem derült ki:
- ❌ Credential stuffing — kizárva (egyedi jelszó, 1Password, más domain)
- ❌ Breach — kizárva (haveibeenpwned: csak Substack, jelszó nélkül)
- ❌ Böngésző-bővítmény — kizárva (mind legitim)
- ❌ 1Password kompromittálás — kizárva (más e-mail/domain)
- ❓ Keylogger/malware a régi Mac-en — nem ellenőrizhető (gép visszaállítva)
- ❓ Real-time phishing proxy — nem ellenőrizhető (nincs böngészési előzmény)
- ❓ Screen Sharing/Remote Access a régi Mac-en — nem ellenőrizhető (gép visszaállítva)

### Evidence: device prompt approved without hardware key

```
Date:      2026-03-30T14:44:09+02:00
Event:     Login challenge
Challenge: Device prompt              ← "Was this you?" popup küldve egy eszközre
Result:    Approved                    ← valaki jóváhagyta

Date:      2026-03-30T14:44:38+02:00
Event:     Login success + Sensitive action allowed
Challenge: Device prompt              ← második prompt, szintén jóváhagyva

Date:      2026-03-30T14:47:30+02:00
Event:     Login success + Sensitive action allowed
Challenge: Device prompt              ← harmadik prompt — authenticator app hozzáadása
```

A device prompt háromszor lett jóváhagyva 3.5 perc alatt. Az iPhone-on a Google értesítések ki voltak kapcsolva, tehát a prompt valószínűleg a Mac Chrome böngészőjében jelent meg popup-ként. **Hardware key (FIDO2) használata esetén a device prompt nem lett volna kiküldve** — fizikai kulcs érintése kellett volna, amit a támadó nem tud távoli eszközről jóváhagyni.
