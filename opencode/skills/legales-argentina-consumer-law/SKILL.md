---
name: legales-argentina-consumer-law
description: >
  Provee encuadre sustantivo de consumo argentino desde hechos separados y referencias explícitas.
  Trigger: cuando Legales necesita framing normativo, derechos, obligaciones, regímenes aplicables
  o incertidumbres jurídicas de consumo sin asumir ownership del dossier ni del resumen operativo.
license: Apache-2.0
metadata:
  author: gentle-orchestrator
  version: "1.0"
---

## When to Use

- Analizar régimen de defensa del consumidor argentino desde `facts[]` y `documentary_references[]` ya separados.
- Expresar hipótesis, contingencias y condiciones de verificación jurídica.
- Señalar cuándo una pregunta en realidad requiere research adicional o drafting.

## Critical Patterns

- Este skill es **OpenCode-global**.
- Consume payload estructurado; **MUST NOT** leer ni adueñarse directamente de `Reclamos/` o `Contexto-operativo/` como owner operativo.
- Distinguir siempre entre base documental y encuadre jurídico generado.
- No promover inputs no verificados a hechos.
- Si falta separación entre hechos, hipótesis, estrategia o referencias, pedir payload saneado antes de avanzar.
- Si la tarea real es buscar fuentes o jurisprudencia, derivar a `legales-case-research`.
- No definir comportamiento ni artefactos Claude-specific.

## Output Contract

- **Hechos usados**: solo los recibidos como separados y verificables.
- **Hipótesis/condicionalidad**: incertidumbres y dependencias de prueba.
- **Encuadre normativo**: regímenes plausibles, obligaciones, derechos, tensiones.
- **Límites**: qué no puede afirmarse todavía.
- **Referencias documentales**: siempre separadas del razonamiento generado.

## Refusal Rules

- Rechazar ownership de `case_association`, refresh de `resumen-operativo.md`, research exhaustivo de fuentes y drafting final.
- Rechazar cualquier intento de usar `proposed_factual_update[]` como hecho verificado.

## Commands

```bash
# No shell workflow required; operate from structured payloads only.
```

## Resources

- `~/Agents/Legales/AGENTS.md`
- `~/Agents/Legales/Templates/legales-handoff-payload.md`
