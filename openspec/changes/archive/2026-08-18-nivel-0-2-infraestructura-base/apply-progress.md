# Apply Progress — Nivel 0.2 Base Infrastructure

**Change**: `nivel-0-2-infraestructura-base`  
**Work unit**: `studio-healthcheck-recovery-and-C4-C6`  
**Attempt**: 1 (max 1 authorized)  
**Status**: passed — Studio healthcheck corrected; full service acceptance green; persistence proven  
**Functional diff**: 1 line changed in `docker-compose.yml`  

---

## Hard precheck

| Check | Result |
|---|---|
| Git root matches `/mnt/c/Users/miste/OneDrive/Documentos/BehaviorOS` | yes (`git rev-parse --show-toplevel`) |
| Change identity | `nivel-0-2-infraestructura-base` |
| Required artifacts read | proposal.md, specs/base-infrastructure/spec.md, design.md, tasks.md, apply-progress.md |
| Previous apply-progress | Engram #374 merged; OpenSpec `apply-progress.md` merged |
| Pending boundaries | Studio healthcheck recovery + C4-C6 authorized; C7-C9 explicitly excluded |
| Forecast vs. budget | 1 changed line, within 20-line max |
| Current blockers | Studio healthcheck target mismatch (Engram #375) — now corrected |

---

## Prior attempt summary (Engram #374 / OpenSpec apply-progress.md)

- B1-B3 completed: Storage healthcheck URL changed from `localhost` to `127.0.0.1`; `docker compose config -q` passed.
- C1-C3 completed: stack started; all services healthy/running except `studio`, which was `unhealthy`.
- Blocker: Studio internal healthcheck targeted `localhost:3000` (→ `127.0.0.1:3000`), but Next.js listened only on the container eth0 IP (`172.18.0.9:3000`). External Studio returned HTTP 200.
- C4-C6 were not started because full service acceptance was not green.

---

## Pre-edit confirmation (recovery)

| Premise | Evidence | Verdict |
|---|---|---|
| A. Studio returns external HTTP 200 | `curl -s -o /dev/null -w '%{http_code}' http://localhost:3000/api/profile` → `200` | confirmed |
| B. Internal healthcheck targets loopback | `docker inspect behavioralos-studio` → `http://localhost:3000/api/profile` | confirmed |
| C. Next.js listens only on container eth0, not loopback | `ss -ltnp` inside container showed `LISTEN 0 511 172.18.0.9:3000 0.0.0.0:*` | confirmed |

All three premises unchanged from Engram #375; recovery authorized.

---

## Recovery edit

**Diagnosis**: The Studio healthcheck reached loopback, but the listener was bound to the container's eth0 IP assigned by Docker. The stable, dynamically resolved target inside the container is the Compose service identity `studio`, which Docker DNS resolves to the container's current eth0 IP.

**Edit** (single line in `docker-compose.yml`, service `studio`, healthcheck `test`):

```diff
-          "require('http').get('http://localhost:3000/api/profile', (r) => {if (r.statusCode !== 200) throw new Error(r.statusCode)})"
+          "require('http').get('http://studio:3000/api/profile', (r) => {if (r.statusCode !== 200) throw new Error(r.statusCode); process.exit(0);}).on('error', (e) => {process.exit(1);})"
```

Rationale for the additional `process.exit(0/1)`:
- `node -e "... http.get(..., cb)"` does not exit on a successful response unless the socket is explicitly drained or the process exits; Docker killed the probe at the 5 s timeout, causing `unhealthy`.
- The original command happened to exit quickly only because the connection to `localhost` was refused immediately. A reachable target requires an explicit exit to keep the probe inside Docker's timeout.
- This keeps the change strictly inside the Studio healthcheck command; no image, command, entrypoint, environment, ports, networks, binds, or other services were modified.

File: `docker-compose.yml`, line 240.  
Changed lines: **1**.

---

## Post-edit validation

### Compose config validation

```bash
docker compose config -q
```

Result: exits 0, no output, no validation errors.

### Studio recreate

```bash
docker compose up -d --no-deps studio
```

Result: `behavioralos-studio` recreated and started.

### Full service acceptance

```bash
docker compose ps
```

Result:

```
SERVICE    STATE     HEALTH
auth       running   healthy
db         running   healthy
imgproxy   running   healthy
kong       running   healthy
meta       running   healthy
rest       running             (no Compose healthcheck defined; running accepted)
storage    running   healthy
studio     running   healthy
```

### Healthcheck evidence

| Service | Check | Result |
|---|---|---|
| Studio external | `curl -s -o /dev/null -w '%{http_code}' http://localhost:3000/api/profile` | `200` |
| Studio internal | `docker compose exec studio node -e "... http://studio:3000/api/profile ... process.exit(0) ..."` | exit 0 |
| Postgres | `docker compose exec db pg_isready -U postgres -h localhost` | `localhost:5432 - accepting connections` |
| Postgres | `docker compose exec db psql -U postgres -d postgres -c 'SELECT 1;'` | `1` |
| Auth | `docker compose exec auth wget --spider http://localhost:9999/health` | `remote file exists` |
| Storage | `docker compose exec storage wget --spider http://127.0.0.1:5000/status` | `remote file exists` |
| imgproxy | `docker compose exec imgproxy imgproxy health` | `imgproxy is running` |
| Kong | `curl -s -o /dev/null -w '%{http_code}' http://localhost:8000/` | `401` (operational) |

---

## C4 — Baseline before restart

```bash
docker compose exec db psql -U postgres -d postgres -tAc "SELECT system_identifier FROM pg_control_system();"
```

Result:

```
7674144466278969383
```

Migration baseline (CLI `supabase migration list --local` cannot connect to this custom Compose-managed database; equivalent SQL evidence captured):

| Schema / table | Query | Result (snapshot) |
|---|---|---|
| `auth.schema_migrations` | `SELECT version FROM auth.schema_migrations ORDER BY version;` | `00`, `20171026211738`, `20171026211808`, ... `20240802193726` (59 rows) |
| `storage.migrations` | `SELECT id FROM storage.migrations ORDER BY id;` | `0`–`23` (24 rows) |
| `supabase_functions.migrations` | `SELECT version FROM supabase_functions.migrations ORDER BY version;` | `20210809183423_update_grants`, `initial` |

---

## C5 — Restart without `-v`

```bash
docker compose down
docker compose up -d
```

Volume preservation verified:

```bash
docker volume ls
```

Result: all four named volumes remain:

- `behavioralos_behavioralos-db-data`
- `behavioralos_behavioralos-db-data-aligned`
- `behavioralos_behavioralos-db-data-clean`
- `behavioralos_db-config`

No `-v` flag was used; no volumes were removed.

---

## C6 — Post-restart persistence comparison

### system_identifier

```bash
docker compose exec db psql -U postgres -d postgres -tAc "SELECT system_identifier FROM pg_control_system();"
```

Post-restart result:

```
7674144466278969383
```

Comparison: **identical** to pre-restart baseline.

### Migration state

Post-restart queries returned identical row counts and values for:

- `auth.schema_migrations` — same 59 versions.
- `storage.migrations` — same IDs `0`–`23`.
- `supabase_functions.migrations` — same two versions.

Comparison: **stable**.

---

## Repeated complete healthchecks after restart

| Service | Check | Result |
|---|---|---|
| Studio external | `curl http://localhost:3000/api/profile` | `200` |
| Studio internal | healthcheck command inside container | exit 0 |
| Studio Compose | `docker inspect --format='{{.State.Health.Status}}' behavioralos-studio` | `healthy` |
| Postgres | `pg_isready` / `SELECT 1;` | healthy / `1` |
| Auth | `wget --spider http://localhost:9999/health` | `remote file exists` |
| Storage | `wget --spider http://127.0.0.1:5000/status` | `remote file exists` |
| imgproxy | `imgproxy health` | `imgproxy is running` |
| Kong | `curl http://localhost:8000/` | `401` operational |
| Full set | `docker compose ps` | all healthy/running |

No new failures after restart.

---

## Functional diff summary

```
docker-compose.yml  | 1 +-
1 file changed, 1 insertion(+), 1 deletion(-)
```

The only functional change is the Studio healthcheck command: target changed from `localhost` to `studio`, with explicit `process.exit` so the probe terminates cleanly on success or error.

---

## Volumes / cleanup

- Stack disposition: **running** after restart.
- No volumes removed.
- Named volumes preserved and reused (verified by identical `system_identifier` and migration state).

---

## Blockers / risks

- `supabase migration list --local` does not connect to this Compose-managed database because the Supabase CLI expects its own local stack on port 54322 and a `supabase_migrations.schema_migrations` table that does not exist here. Equivalent migration evidence was captured directly from the database (`auth.schema_migrations`, `storage.migrations`, `supabase_functions.migrations`). This is noted for the verify phase; it is not a runtime or persistence failure.
- No other blockers.

---

## Next step

C7-C9 remain for the separate phase: run `sdd-verify`, close Nivel 0.2, and stop before Nivel 1.1. Do not advance without explicit authorization.

---

## Remediation attempt — `nivel-0-2-healthcheck-harness-remediation`

**Work unit**: `nivel-0-2-healthcheck-harness-remediation`  
**Bound to failed evidence**: `sha256:afcc5fd274317e27896796f101983208eab7a36e64b9fa8bdffa5d989b82f350`  
**Attempt**: 1 (max 1 authorized)  
**Status**: passed  
**New evidence revision**: `sha256:7d9f26f029b40d7e07a806e5bdab2cf420b8520b5fa258f38957ad7b72e833b3`  
**Changed file**: `scripts/healthcheck.sh`  
**Functional changed lines**: 17 (within 20-line limit)  

---

### Hard precheck

Confirmed `scripts/healthcheck.sh` still contained the three premises required by the remediation authority:

| # | Premise | Verdict |
|---|---|---|
| 1 | Auth check targets `/auth/v1/verify` and expects 200 | confirmed |
| 2 | REST check targets `/rest/v1/` with anon key and expects 401 | confirmed |
| 3 | imgproxy check targets `http://localhost:5001/health` and expects 200 | confirmed |

Precheck result: **passed** — no adaptation or edit beyond the authorized scope was required.

---

### Diagnosis

The failed evidence expected endpoint/status combinations that do not match the running Supabase-aligned stack:

- `/auth/v1/verify` responds 400 against the anon-key helper; `/auth/v1/health` is the correct public health endpoint and returns 200 with the anon key.
- `/rest/v1/` with a valid anon key returns 200 and `Content-Type: application/openapi+json`, not 401.
- imgproxy is not published on `localhost:5001` from the host; it must be probed from inside the existing Compose network.

---

### Functional diff

```diff
--- scripts/healthcheck.sh.orig
+++ scripts/healthcheck.sh
@@ -73,11 +73,19 @@
 fi
 
 # Auth public
-check "Auth public verify" "$API_URL/auth/v1/verify" "200"
+check_anon "Auth public health" "$API_URL/auth/v1/health" "200"
 # Auth secure: anon debe obtener 401 en /auth/v1/user sin JWT
 check_anon "Auth secure (anon key-auth)" "$API_URL/auth/v1/user" "401"
 # REST via Kong requiere apikey
-check_anon "REST via Kong (anon)" "$API_URL/rest/v1/" "401"
+echo -n "[health] REST via Kong (anon) ($API_URL/rest/v1/) ... "
+if [ -n "$ANON_KEY" ]; then
+  rh=$(curl -sS -D - -o /dev/null -m 5 -H "apikey: $ANON_KEY" "$API_URL/rest/v1/" 2>/dev/null)
+  rs=$(echo "$rh" | awk 'NR==1{print $2}')
+  [ "$rs" = "200" ] && echo "$rh" | grep -qi '^content-type: application/openapi+json' && echo "OK (200, application/openapi+json)" || { echo "FAIL (status=$rs)"; EXIT_CODE=1; }
+else
+  echo "SKIPPED (ANON_KEY no definida)"
+  EXIT_CODE=1
+fi
 # Storage vía Kong
 check_anon "Storage status via Kong" "$API_URL/storage/v1/status" "200"
 # Meta vía Kong requiere service_role
@@ -87,6 +95,10 @@
 # Studio
 check "Studio /api/profile" "$STUDIO_URL/api/profile" "200"
 # imgproxy directo
-check "imgproxy health" "http://localhost:5001/health" "200"
+echo -n "[health] imgproxy health (http://imgproxy:5001/health) ... "
+io=$(docker compose exec -T storage wget -S --spider -T 5 "http://imgproxy:5001/health" 2>&1)
+is=$?
+ic=$(echo "$io" | awk '/HTTP\/[0-9.]+/{print $2; exit}')
+[ "$is" -eq 0 ] && [ "$ic" = "200" ] && echo "OK (200)" || { echo "FAIL (status=$ic, wget_exit=$is)"; EXIT_CODE=1; }
```

**Changed lines**: 17 (3 removed, 14 added). All changes are inside `scripts/healthcheck.sh`; no other file was touched.

---

### Post-edit validation

| Step | Command | Result |
|---|---|---|
| 1. Bash syntax | `bash -n scripts/healthcheck.sh` | PASS |
| 2. Compose config | `docker compose config -q` | PASS |
| 3. Directed Auth | `curl -H "apikey: $ANON_KEY" http://localhost:8000/auth/v1/health` | HTTP 200 |
| 4. Directed REST | `curl -sS -D - -H "apikey: $ANON_KEY" http://localhost:8000/rest/v1/` | HTTP 200, `Content-Type: application/openapi+json; charset=utf-8` |
| 5. Directed imgproxy | `docker compose exec -T storage wget -S --spider -T 5 http://imgproxy:5001/health` | HTTP/1.1 200 OK |
| 6. Full harness | `./scripts/healthcheck.sh` | exit 0 |

All six validation steps passed.

---

### Discovery: imgproxy probe tooling

The `storage` service container does not include `curl`; only BusyBox `wget` is present. The remediation used `docker compose exec -T storage wget -S --spider -T 5 http://imgproxy:5001/health` to probe imgproxy from inside the Compose network. This satisfies the requirement to remove the `localhost:5001` assumption without publishing ports, changing the Compose file, or modifying the storage image.

---

### Blockers / risks

- No blockers remain for this remediation.
- No containers were restarted, recreated, or removed.
- No volumes were mutated or deleted.
- No SQL, Kong config, JWT, role, network, port, or Compose change was performed.

---

### Cleanup evidence

- Stack disposition: **running**.
- No infrastructure, volume, or destructive change performed.
- Only `scripts/healthcheck.sh` was modified.

---

### Next step

Run `sdd-verify` as the required post-apply workflow gate (C7). Do not advance to Nivel 1.1 without explicit authorization.
