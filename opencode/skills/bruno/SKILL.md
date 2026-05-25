---
name: bruno
description: >
  Bruno API client — crea y edita colecciones en formato OpenCollection YAML (.yml).
  Cubre requests (params, body, auth, headers), scripts (req, res, bru API), variables
  (runtime, env, collection, folder, process env/.env), entornos, assertions, tests,
  script flow, dynamic variables, cookies, secrets y estructura de colecciones.
  Trigger: cuando el usuario pide crear/modificar requests de Bruno, agregar params,
  headers, body, auth, scripts, variables, assertions, .env, entornos, o trabajar
  con colecciones OpenCollection YAML.
license: Apache-2.0
metadata:
  author: gentle-orchestrator
  version: "2.0"
---

## When to Use

- Crear o modificar requests `.yml` (OpenCollection YAML)
- Agregar query params, path params, headers, body, auth
- Escribir scripts (`before-request`, `after-response`, `tests`)
- Trabajar con variables (runtime, env, collection, folder, request, process env)
- Configurar `.env` para secrets
- Crear/manejar entornos (environments)
- Definir assertions declarativas
- Usar cookies, dynamic variables, secrets managers
- Armar estructura de colecciones (`opencollection.yml`, carpetas)
- Debuggear variables en scripts con `bru.getVar()`, `bru.getEnvVar()`, etc.

## Critical Patterns — Leer ANTES de escribir YAML

### 1. Query params: `params:` con `type: query` — NO usar `query:` como key

```yaml
# ✅ CORRECTO
http:
  params:
    - name: documentDefinitionId
      value: ""
      type: query

# ❌ INCORRECTO — no renderiza en Bruno
http:
  query:
    - name: documentDefinitionId
```

### 2. Deshabilitar un param/header: `disabled: true` — NO usar `enabled: false`

```yaml
# ✅ CORRECTO
params:
  - name: debug
    value: "true"
    type: query
    disabled: true

# ❌ INCORRECTO
params:
  - name: debug
    enabled: false
```

### 3. URL limpia — Bruno construye el query string desde `params:`

```yaml
# ✅ CORRECTO
url: "{{BASE_URL}}/api/v1/templates"

# ❌ EVITAR — Bruno puede pisarlo
url: "{{BASE_URL}}/api/v1/templates?format=PDF"
```

### 4. Métodos HTTP en UPPERCASE

```yaml
http:
  method: GET    # ✅
  method: get    # ❌
```

### 5. Interpolación de variables: `{{VAR_NAME}}`

Todas las variables se referencian con `{{VAR_NAME}}` en cualquier campo `value`.

### 6. Strings con números en YAML — usar comillas

```yaml
params:
  - name: limit
    value: "10"    # ✅ string
  - name: limit
    value: 10      # ❌ number — Bruno espera string
```

---

## OpenCollection YAML — Request File Structure

### Top-level sections

```yaml
info:        # name, type (http|folder), seq, tags
http:        # method, url, params, headers, body, auth
runtime:     # variables, scripts, assertions
settings:    # encodeUrl, timeout, followRedirects, maxRedirects
docs:        # Markdown (| o |-)
```

### `info`

```yaml
info:
  name: Get Users
  type: http       # http | folder
  seq: 1
  tags:            # opcional — filtrar en collection runs
    - smoke
    - regression
```

### `http.params`

```yaml
params:
  - name: filter
    value: active
    type: query       # query | path
    disabled: true    # opcional
  - name: id
    value: "123"
    type: path
```

| Field      | Type    | Required |
| ---------- | ------- | -------- |
| `name`     | string  | sí       |
| `value`    | string  | sí       |
| `type`     | string  | sí       |
| `disabled` | boolean | no       |

### `http.headers`

```yaml
headers:
  - name: Content-Type
    value: application/json
  - name: Authorization
    value: Bearer {{token}}
    disabled: true    # opcional
```

### `http.body`

| Body Type          | `type` value          |
| ------------------ | --------------------- |
| JSON               | `json`                |
| Text               | `text`                |
| XML                | `xml`                 |
| Form URL-encoded   | `form-urlencoded`     |
| Multipart Form     | `multipart-form`      |
| GraphQL            | `graphql`             |

```yaml
# JSON body
body:
  type: json
  data: |-
    {
      "name": "John Doe"
    }

# Form URL-encoded
body:
  type: form-urlencoded
  data:
    - name: username
      value: johndoe
    - name: password
      value: secret123
```

### `http.auth`

```yaml
# Inherit del padre
auth: inherit

# Bearer token
auth:
  type: bearer
  token: "{{token}}"

# Basic
auth:
  type: basic
  username: admin
  password: secret

# API Key
auth:
  type: apikey
  key: x-api-key
  value: "{{api-key}}"
  placement: header     # header | query
```

Tipos: `none`, `inherit`, `basic`, `bearer`, `apikey`, `digest`, `oauth2`, `awsv4`, `ntlm`.

### `runtime` (variables + scripts + assertions)

```yaml
runtime:
  variables:
    - name: MY_VAR
      value: "hello"
  scripts:
    - type: before-request
      code: |-
        req.setHeader("X-Timestamp", Date.now());
    - type: after-response
      code: |-
        bru.setVar("token", res.body.token);
    - type: tests
      code: |-
        test("should return 200", function() {
          expect(res.status).to.equal(200);
        });
  assertions:
    - expression: res.status
      operator: eq
      value: "200"
    - expression: res.body.name
      operator: isString
```

### `settings`

```yaml
settings:
  encodeUrl: true
  timeout: 0           # 0 = sin timeout
  followRedirects: true
  maxRedirects: 5
```

### `docs` — Markdown

```yaml
docs: |-
  # Endpoint description

  ## Params
  - `filter` — filter by status
```

---

## Scripting — API Reference

Bruno expone tres objetos globales en scripts: `req`, `res`, `bru`.

### `req` — Request object (pre-request + test scripts)

| Método                         | Descripción                                    |
| ------------------------------ | ---------------------------------------------- |
| `req.getUrl()`                 | URL actual                                     |
| `req.setUrl(url)`              | Cambiar URL                                    |
| `req.getMethod()`              | Método HTTP                                    |
| `req.setMethod(method)`        | Cambiar método                                 |
| `req.getHeader(name)`          | Header por nombre                              |
| `req.getHeaders()`             | Todos los headers                              |
| `req.setHeader(name, value)`   | Setear header                                  |
| `req.setHeaders({...})`        | Setear múltiples headers                       |
| `req.deleteHeader(name)`       | Borrar header                                  |
| `req.getBody()`                | Body actual                                    |
| `req.setBody(obj)`             | Setear body                                    |
| `req.setTimeout(ms)`           | Timeout en ms                                  |
| `req.setMaxRedirects(n)`       | Máx redirects                                  |
| `req.getHost()`                | Hostname de la URL                             |
| `req.getName()`                | Nombre del request                             |
| `req.getTags()`                | Tags como array                                |
| `req.getExecutionMode()`       | `"runner"` o `"standalone"`                    |
| `req.getExecutionPlatform()`   | `"app"` o `"cli"`                              |
| `req.onFail(callback)`         | Callback en error (solo Developer Mode)        |

```javascript
// Pre-request: setear header dinámico
req.setHeader("X-Timestamp", Date.now().toString());

// Pre-request: cambiar body dinámicamente
req.setBody({ ...req.getBody(), timestamp: Date.now() });

// Pre-request: cambiar URL
req.setUrl(req.getUrl() + "?debug=true");

// Detectar modo de ejecución
if (req.getExecutionMode() === "runner") {
  console.log("Running in collection runner");
}
```

### `res` — Response object (post-response + test scripts)

| Property / Method         | Descripción                              |
| ------------------------- | ---------------------------------------- |
| `res.status`              | Código HTTP (200, 404, 500)              |
| `res.statusText`          | Texto del status ("OK", "Not Found")     |
| `res.headers`             | Objeto con headers de respuesta          |
| `res.body`                | Body (auto-parsed JSON si es JSON)       |
| `res.responseTime`        | Tiempo en ms                             |
| `res.url`                 | URL final (post-redirects)               |
| `res.getHeader(name)`     | Header por nombre                        |
| `res.getHeaders()`        | Todos los headers                        |
| `res.getBody()`           | Body como objeto/string                  |
| `res.getResponseTime()`   | Tiempo en ms                             |
| `res.getUrl()`            | URL final                                |
| `res.getSize()`           | `{ body, headers, total }` en bytes      |

### `bru` — Bruno API (todos los scripts)

#### Runtime Variables

```javascript
bru.setVar("token", res.body.token);       // crear/actualizar
bru.getVar("token");                       // leer
bru.hasVar("token");                       // existe?
bru.deleteVar("token");                    // borrar uno
bru.deleteAllVars();                       // borrar todos
bru.getAllVars();                          // { key: value, ... }
```

#### Environment Variables

```javascript
bru.getEnvName();                          // nombre del entorno activo
bru.getEnvVar("base_url");                 // leer
bru.setEnvVar("token", "abc");             // en memoria
bru.setEnvVar("token", "abc", { persist: true }); // persistir a disco
bru.hasEnvVar("token");                    // existe?
bru.deleteEnvVar("token");                 // borrar
bru.getAllEnvVars();                       // todos como objeto
bru.deleteAllEnvVars();                    // borrar todos
```

#### Global Environment Variables

```javascript
bru.getGlobalEnvVar("val");                // leer
bru.setGlobalEnvVar("val", "bruno");       // setear
bru.getAllGlobalEnvVars();                 // todos como objeto
```

#### Collection / Folder / Request Variables

```javascript
bru.getCollectionVar("namespace");         // collection var
bru.getCollectionName();                   // nombre de la colección
bru.hasCollectionVar("namespace");         // existe?

bru.getFolderVar("company");               // folder var

bru.getRequestVar("source");               // request var
```

#### Process Environment (`.env` file)

```javascript
bru.getProcessEnv("SECRET_TOKEN");         // leer de .env
```

#### Secrets (Secret Managers)

```javascript
bru.getSecretVar("payment-service.api-key"); // key: <secret-name>.<key-name>
```

#### OAuth2

```javascript
bru.getOauth2CredentialVar("access_token");  // leer credential oauth2
bru.resetOauth2Credential("credential-id");  // resetear para re-auth
```

#### Runner (solo en collection runs)

```javascript
bru.setNextRequest("request-name");        // saltar a otro request
bru.setNextRequest(null);                  // frenar la run
bru.runner.skipRequest();                  // skip request actual (pre-request)
bru.runner.stopExecution();                // frenar la run
```

#### Utilities

```javascript
await bru.sleep(3000);                     // dormir ms
bru.interpolate("{{$randomFirstName}}");   // resolver dynamic variables
bru.disableParsingResponseJson();          // no auto-parsear JSON response
bru.cwd();                                 // working dir de la colección
bru.isSafeMode();                          // true = Safe Mode, false = Developer
await bru.runRequest("auth-api");          // ejecutar otro request
await bru.getTestResults();               // resultados de tests
await bru.getAssertionResults();           // resultados de assertions
await bru.sendRequest({method, url, headers, data}, callback); // request programático
```

#### Cookies (request-scoped — más simple)

```javascript
// Sync reads
bru.cookies.get("session");                // valor
bru.cookies.has("session");                // existe?
bru.cookies.all();                         // todos
bru.cookies.toObject();                    // { name: value }

// Async writes (usar await)
await bru.cookies.add({ key: "session", value: "abc123" });
await bru.cookies.remove("session");
await bru.cookies.clear();
```

---

## Variables — Tipos y Precedencia

Hay 7 tipos. Precedencia (mayor → menor):

| Prioridad | Tipo               | Storage                                   | Sintaxis                    |
| --------- | ------------------ | ----------------------------------------- | --------------------------- |
| 1 (más)   | Runtime            | Memoria (efímera)                         | `bru.setVar/getVar`         |
| 2         | Request            | `<request>.bru` o `runtime.variables`     | `bru.getRequestVar`         |
| 3         | Folder             | `<folder>/folder.bru`                     | `bru.getFolderVar`          |
| 4         | Environment        | `environments/<env>.bru`                  | `bru.getEnvVar/setEnvVar`   |
| 5         | Collection         | `collection.bru`                          | `bru.getCollectionVar`      |
| 6         | Global Environment | Workspace (memoria local)                 | `bru.getGlobalEnvVar`       |
| —         | Process Env        | `.env` file (raíz de colección)           | `bru.getProcessEnv`         |
| —         | Prompt             | Interactivo (nunca se almacena)           | `{{?Enter value}}`          |

### Todas son strings

Bruno no infiere tipos. `10` en YAML es number — usar `"10"` para que sea string.

### Runtime Variables (efímeras)

```javascript
// Post-response: capturar token
bru.setVar("token", res.body.token);

// Usar en otro request
// Authorization: Bearer {{token}}
```

### Environment Variables (por entorno)

```yaml
# environments/local.bru
vars {
  host: http://localhost:8787
  JWT_TOKEN: {{process.env.JWT_TOKEN}}
}
```

```javascript
// Script
bru.setEnvVar("apiToken", res.body.token, { persist: true });
```

### Collection Variables

```yaml
# collection.bru
vars:pre-request {
  namespace: myapp
}
```

### Folder Variables

```yaml
# my-folder/folder.bru
vars:pre-request {
  company: acme
}
```

### Request Variables

```yaml
# request.yml
runtime:
  variables:
    - name: source
      value: api
```

---

## `.env` — Process Environment (Secrets)

### Estructura de archivos

```
my-collection/
├── .env                   # ← secrets (NO commitear)
├── .env.sample            # ← template sin valores reales
├── .gitignore             # ← debe incluir .env
├── bruno.json / opencollection.yml
└── environments/
    └── local.bru
```

### `.env` file

```bash
JWT_TOKEN=your_jwt_token_value
API_KEY=your_api_key_value
```

### Usar en requests

```yaml
# En cualquier campo value
headers:
  - name: Authorization
    value: Bearer {{process.env.JWT_TOKEN}}
```

### En environments

```bash
# environments/local.bru
vars {
  JWT_TOKEN: {{process.env.JWT_TOKEN}}
  API_KEY: {{process.env.API_KEY}}
}
```

### En scripts

```javascript
let token = bru.getProcessEnv("JWT_TOKEN");
req.setHeader("Authorization", `Bearer ${token}`);
```

### Variables con puntos en el nombre

```bash
# .env
example.test=mysecretvalue
```

```javascript
// ❌ No funciona — Bruno interpreta los puntos como path
"{{process.env.example.test}}"

// ✅ Usar bracket notation
"{{process.env['example.test']}}"
```

### Desde v3.1.0: UI para crear/ver/borrar env vars

Workspace → Global Environment → crear/edit/delete sin tocar `.env`.

---

## Entornos (Environments)

### Crear y usar

```bash
# environments/local.bru
vars {
  host: http://localhost:8787
  token: {{process.env.JWT_TOKEN}}
}

# environments/production.bru
vars {
  host: https://api.prod.com
  token: {{process.env.JWT_TOKEN}}
}
```

```yaml
# request.yml — usar la variable de entorno
http:
  url: "{{host}}/api/v1/users"
```

### Seleccionar entorno

Top-right de Bruno → dropdown de entornos.

### Color Coding (v3.1.0+)

Cada entorno puede tener color asignado para evitar errores visuales (local vs prod).

---

## Script Flow — Sandwich vs Sequential

### Sandwich (default)

```
Collection Pre → Folder Pre → Request Pre
  → Request → 
Request Post → Folder Post → Collection Post
```

### Sequential

```
Collection Pre → Folder Pre → Request Pre
  → Request →
Collection Post → Folder Post → Request Post
```

### Configurar en `bruno.json`

```json
{
  "scripts": {
    "flow": "sequential"
  }
}
```

---

## Assertions (declarativas, sin JS)

```yaml
runtime:
  assertions:
    - expression: res.status
      operator: eq
      value: "200"
    - expression: res.body.name
      operator: isString
    - expression: res.body.data
      operator: isArray
    - expression: res.responseTime
      operator: lt
      value: "1000"
```

| Operator    | Descripción            |
| ----------- | ---------------------- |
| `eq`        | igual                  |
| `neq`       | distinto               |
| `gt`, `lt`  | mayor/menor que        |
| `gte`, `lte`| mayor/menor o igual    |
| `isString`  | es string              |
| `isNumber`  | es number              |
| `isArray`   | es array               |
| `isBoolean` | es boolean             |
| `contains`  | contiene substring     |
| `matches`   | match regex            |

---

## Dynamic Variables

Bruno tiene variables dinámicas built-in. Usar con `{{$...}}`:

```yaml
body:
  type: json
  data: |-
    {
      "name": "{{$randomFullName}}",
      "email": "{{$randomEmail}}",
      "phone": "{{$randomPhoneNumber}}"
    }
```

En scripts:

```javascript
const name = bru.interpolate("{{$randomFullName}}");
const email = bru.interpolate("{{$randomEmail}}");
```

---

## Collection Structure (OpenCollection YAML)

```
my-collection/
├── opencollection.yml     # raíz
├── bruno.json             # config (scripts flow, moduleWhitelist, etc.)
├── .env                   # secrets (NO commitear)
├── .gitignore
├── environments/
│   ├── local.bru
│   └── production.bru
├── folder-name/
│   ├── folder.yml         # type: folder
│   ├── request-1.yml
│   └── request-2.yml
```

### `opencollection.yml` (raíz)

```yaml
opencollection: 1.0.0

info:
  name: My API

config:
  proxy:
    inherit: true
    config:
      protocol: http
      hostname: ""
      port: ""
      auth:
        username: ""
        password: ""

requests:
  - folder-name/request-1.yml
  - folder-name/request-2.yml
```

---

## Code Examples

### GET con query params + auth + tests

```yaml
info:
  name: List templates
  type: http
  seq: 1

http:
  method: GET
  url: "{{BASE_URL}}/api/v1/templates"
  params:
    - name: documentDefinitionId
      value: ""
      type: query
    - name: format
      value: "PDF"
      type: query
    - name: status
      value: "READY"
      type: query
  auth: inherit

runtime:
  scripts:
    - type: tests
      code: |-
        test("should return 200", function() {
          expect(res.status).to.equal(200);
        });
        test("should return array", function() {
          expect(res.body).to.be.an('array');
        });

settings:
  encodeUrl: true
  timeout: 0
  followRedirects: true
  maxRedirects: 5
```

### GET con path param

```yaml
info:
  name: Get document
  type: http
  seq: 2

http:
  method: GET
  url: "{{BASE_URL}}/api/v1/documents/:id"
  params:
    - name: id
      value: ""
      type: path
  auth: inherit
```

### POST con JSON + capturar token + encadenar

```yaml
info:
  name: Login
  type: http
  seq: 3

http:
  method: POST
  url: "{{BASE_URL}}/api/v1/auth/login"
  body:
    type: json
    data: |-
      {
        "username": "admin",
        "password": "{{process.env.ADMIN_PASSWORD}}"
      }
  auth: none

runtime:
  scripts:
    - type: after-response
      code: |-
        bru.setVar("token", res.body.token);
    - type: tests
      code: |-
        test("should return 200", function() {
          expect(res.status).to.equal(200);
        });
        test("should have token", function() {
          expect(res.body.token).to.be.a('string');
        });
```

### Request con assertions declarativas

```yaml
runtime:
  assertions:
    - expression: res.status
      operator: eq
      value: "201"
    - expression: res.body.id
      operator: isString
```

### Collection-level pre-request (setear header global)

```javascript
// En collection.bru → script:pre-request
if (bru.getEnvVar("apiKey")) {
  req.setHeader("x-api-key", bru.getEnvVar("apiKey"));
}
```

---

## Resources

- **Docs oficiales**: https://docs.usebruno.com/
- **OpenCollection spec**: https://spec.opencollection.com/
- **YAML Structure Reference**: https://docs.usebruno.com/opencollection-yaml/structure-reference.md
- **YAML Samples**: https://docs.usebruno.com/opencollection-yaml/samples.md
- **Scripting API (req/res/bru)**: https://docs.usebruno.com/testing/script/javascript-reference.md
- **Variables**: https://docs.usebruno.com/variables/overview.md
- **.env / Process Env**: https://docs.usebruno.com/secrets-management/dotenv-file.md
