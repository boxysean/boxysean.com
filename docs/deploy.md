# How boxysean.com is served, and how the DNS got there

Written 2026-10-26 while working issue #12, phase 2. The cutover described below had
**already happened** by the time this was written, so this file records both the
click list (so the same move can be repeated for another domain, or reversed) and the
evidence that it is complete.

**Verdict at time of writing: the site is served by Netlify on the apex `boxysean.com`,
with `www` 301-redirecting to it, over a Netlify-managed Let's Encrypt certificate.
DNS is hosted in Cloudflare and the registrar is Cloudflare too. Nothing here is
outstanding.**

---

## 1. Current DNS inventory

Every value below was read from the public resolver, not the box's local cache:

    dig @1.1.1.1 <name> <type>

| Name | Type | TTL | Value | Notes |
|---|---|---|---|---|
| `boxysean.com` | NS | 86400 | `bonnie.ns.cloudflare.com.` `troy.ns.cloudflare.com.` | Cloudflare-hosted zone |
| `boxysean.com` | A | 300 | `75.2.60.5` | Netlify's load balancer; **one** A record, none others |
| `boxysean.com` | AAAA | — | (none) | No IPv6 record |
| `www.boxysean.com` | CNAME | 300 | `boxysean.com.` | Resolves through to `75.2.60.5` |
| `boxysean.com` | MX | — | (none) | The domain neither receives nor sends mail |
| `boxysean.com` | TXT | 300 | `"v=spf1 -all"` | SPF: nobody may send as this domain |
| `_dmarc.boxysean.com` | TXT | 300 | `"v=DMARC1; p=reject; sp=reject; adkim=s; aspf=s;"` | DMARC: reject, strict alignment |
| `google._domainkey.boxysean.com` | TXT | 300 | `"v=DKIM1; p="` | Google Workspace DKIM, key revoked (empty `p=`) |
| `boxysean.com` | CAA | — | (none) | No CAA pinning; Netlify can issue Let's Encrypt certs |
| `boxysean.com` | SOA | 1800 | `bonnie.ns.cloudflare.com. dns.cloudflare.com. …` | Matches the NS pair |

Checked and **absent**: AAAA anywhere, `mail`, `ftp`, `autodiscover`, `_acme-challenge`,
`_netlify` (verification TXT), any `selector1/selector2._domainkey`, and any wildcard
(`thisdoesnotexist.boxysean.com` does not resolve). `www` is the only subdomain.

Registrar, from RDAP (`https://rdap.verisign.com/com/v1/domain/boxysean.com`):

    registrar:      Cloudflare, Inc. (IANA 1910)
    status:         client transfer prohibited
    registered:     2010-09-18
    expires:        2027-09-18

## 2. What had to be carried over, and what that means for mail

The move to Cloudflare/Netlify had to preserve three things, and by luck they are the
three easiest to keep:

| Record | Current value | Where it lives in Cloudflare | Why it matters |
|---|---|---|---|
| SPF | `v=spf1 -all` | DNS → TXT at `@` | Says no host may send mail as `boxysean.com` |
| DMARC | `v=DMARC1; p=reject; sp=reject; adkim=s; aspf=s;` | DNS → TXT at `_dmarc` | Tells receivers to reject forgeries outright |
| Google DKIM | `v=DKIM1; p=` at `google._domainkey` | DNS → TXT at `google._domainkey` | Revoked-key record; harmless, kept as-is |

**There are no MX records and there never were any in this zone.** So nothing was at
risk of a mail outage: `boxysean.com` neither receives nor sends mail, and the SPF/DMARC
records above actively tell the world so. The only rule that follows from this is the
negative one — *do not add an MX record* unless mail is being set up deliberately, and if
it is, change `v=spf1 -all` and the DMARC policy in the same change or the new mailbox
will be unable to send.

The A/CNAME records for the web site are the part that changed; everything else was
copied across verbatim.

## 3. The click list

This is the whole move, in order. Steps 1–3 need the Cloudflare account; step 4 needs the
Netlify UI. All of them are already done as of 2026-10-26 — kept here so the same thing
can be done for the next domain without re-deriving it.

1. **Cloudflare → Add a site → `boxysean.com`** (Free plan is enough). Cloudflare
   assigns a nameserver pair; here it is `bonnie.ns.cloudflare.com` and
   `troy.ns.cloudflare.com`.
2. **Registrar: point the domain at those nameservers.** The registrar here *is*
   Cloudflare, so this is a single "move to Cloudflare nameservers" toggle in
   *Domain Registration → Manage*. On any other registrar it is the custom-nameservers
   field, replacing whatever the old pair was.
3. **Create the records in the Cloudflare DNS tab**, all with the proxy **off** (grey
   cloud — see below for why):

   | Type | Name | Value | Proxy |
   |---|---|---|---|
   | A | `@` | `75.2.60.5` | **DNS only** (grey) |
   | CNAME | `www` | `boxysean.com` | **DNS only** (grey) |
   | TXT | `@` | `v=spf1 -all` | n/a |
   | TXT | `_dmarc` | `v=DMARC1; p=reject; sp=reject; adkim=s; aspf=s;` | n/a |
   | TXT | `google._domainkey` | `v=DKIM1; p=` | n/a |

   Delete any other A/AAAA on `@`. Netlify's own troubleshooting guide is explicit that
   a second apex A record causes certificate failures.
4. **Netlify → site `boxysean-com` → Domain management → Add custom domain →
   `boxysean.com`.** Netlify adds `www.boxysean.com` automatically; leave the primary
   domain as `boxysean.com` so `www` is the one that redirects. Then press
   *Verify DNS configuration*, and once it is green, *Provision certificate* (Netlify
   normally does this itself within minutes of verification).

### Why the proxy is off (grey cloud) on both records

- Netlify terminates TLS itself and provisions its certificate with a Let's Encrypt
  HTTP-01 challenge, which has to reach **Netlify's** edge. With the orange cloud on,
  Cloudflare answers that challenge, Netlify can't validate, and the site ends up on
  Cloudflare's own certificate with no Netlify-managed renewal. Netlify's support answers
  on "we could not provision a Let's Encrypt certificate for your custom domain"
  consistently resolve to switching the record to DNS-only.
- The record set is *already* a CDN. Netlify serves from its edge; putting Cloudflare's
  proxy in front gives two caches, two sets of purge rules and two places to debug a
  stale page, for no gain on a static site this size.
- Evidence that it is off today: `dig` returns Netlify's own IP `75.2.60.5` rather than
  a Cloudflare anycast address, and the HTTP response carries `server: Netlify` with no
  `cf-ray` header.

If someone later does want Cloudflare in front, the whole configuration changes
(Cloudflare SSL mode *Full (strict)*, a Netlify origin certificate, cache rules for
HTML); do not half-do it by flipping one record orange.

## 4. Verification performed after the cutover

Run on 2026-10-26, from a clean checkout of the default branch.

DNS (see the table in §1) plus:

    $ dig @1.1.1.1 +short boxysean.com NS
    bonnie.ns.cloudflare.com.
    troy.ns.cloudflare.com.
    $ dig @1.1.1.1 +short boxysean.com A
    75.2.60.5

HTTPS on the apex:

    $ curl -sSI https://boxysean.com/
    HTTP/2 200
    server: Netlify
    strict-transport-security: max-age=31536000
    content-type: text/html; charset=UTF-8
    $ curl -s https://boxysean.com/ | grep -o '<title>[^<]*</title>'
    <title>Home - boxysean.com</title>
    $ curl -s -o /dev/null -w '%{http_code}\n' https://boxysean.com/nope-nope/
    404

Certificate — one Netlify-managed Let's Encrypt cert covering both names, so `www` is
*not* on a fallback or an expiring old cert:

    $ openssl s_client -connect boxysean.com:443 -servername boxysean.com | openssl x509 -noout -issuer -dates -ext subjectAltName
    issuer=C = US, O = Let's Encrypt, CN = YE1
    notBefore=Oct 26 06:19:50 2026 GMT
    notAfter=Jan 24 06:19:49 2027 GMT
    X509v3 Subject Alternative Name:
        DNS:boxysean.com, DNS:www.boxysean.com

Redirects, both directions, path preserved:

    $ curl -sSI https://www.boxysean.com/
    HTTP/2 301
    location: https://boxysean.com/
    $ curl -sSI https://www.boxysean.com/blog/
    HTTP/2 301
    location: https://boxysean.com/blog/
    $ curl -sSI http://boxysean.com/
    HTTP/1.1 301 Moved Permanently
    location: https://boxysean.com/
    $ curl -sSIL http://www.boxysean.com/blog/
    HTTP/1.1 301 Moved Permanently      -> https://boxysean.com/blog/
    HTTP/2 200

So `http://www…` reaches the canonical URL in a single redirect hop, and `https://www…`
301s to the apex with the path intact. HSTS is served on every response.

To re-check any of this later, the whole set is:

    dig @1.1.1.1 +noall +answer boxysean.com NS
    dig @1.1.1.1 +noall +answer boxysean.com A
    dig @1.1.1.1 +noall +answer www.boxysean.com CNAME
    dig @1.1.1.1 +noall +answer boxysean.com TXT
    dig @1.1.1.1 +noall +answer _dmarc.boxysean.com TXT
    curl -sSI https://boxysean.com/ ; curl -sSI https://www.boxysean.com/
    echo | openssl s_client -connect boxysean.com:443 2>/dev/null | openssl x509 -noout -dates -ext subjectAltName

## 5. Retired paths

The S3 path is gone. `deploy.sh` (which ran `jekyll build` and then
`aws s3 sync _site/ s3://boxysean.com/`) has been deleted from the repo: with DNS
pointing at Netlify, running it would push a full copy of the site to a bucket nobody
visits, and having two publishing paths is how a site ends up half-updated. `make deploy`
is now the only deploy command and it goes to Netlify.

Production is the site `boxysean-com` (`https://boxysean-com.netlify.app`, id
`94501faa-3611-49ea-b8ec-537ce1326bc1`) behind the custom domain. Rollback is Netlify's
*Deploys → Publish deploy*, not a DNS change.

## 6. Known gap, unrelated to DNS

Netlify receives no GitHub build events for anything except pushes to `master`: pull
request deploy previews do not build even though the site setting and `netlify.toml`
both ask for them (verified on 2026-10-26 across three separate pushes and a widened
`allowed_branches`). That is an account-owner fix in the Netlify/GitHub integration, not
a DNS or repo problem, and it does not affect the custom domain.
