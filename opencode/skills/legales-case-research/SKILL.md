---
name: legales-case-research
description: >
  Investiga normativa, jurisprudencia y fuentes legales desde payloads estructurados, separando
  hallazgo documental de lectura analítica. Trigger: cuando Legales necesita buscar authorities,
  fuentes secundarias o líneas de soporte sin que el skill decida framing final ni ownership del caso.
license: Apache-2.0
metadata:
  author: gentle-orchestrator
  version: "1.0"
---

## When to Use

- Buscar estatutos, regulaciones, jurisprudencia o secondary sources relevantes para un caso.
- Comparar líneas de autoridad competidoras sin fijar teoría final como hecho.
- Devolver soporte documental reusable para framing o drafting posteriores.

## Critical Patterns

- Este skill es **OpenCode-global**.
- Consume payloads y referencias estructuradas; **MUST NOT** asumir ownership directo de `Reclamos/` ni refrescar `Contexto-operativo/<case-id>/resumen-operativo.md`.
- Separar siempre estas capas: `fuentes encontradas`, `qué dicen`, `lectura analítica`, `incertidumbres`.
- No resolver verdad factual ni encuadre jurídico definitivo.
- Si el pedido llega mezclado con drafting o framing final, devolver boundary warning y sugerir skill dueño.
- Mantener OpenCode-only; no introducir behavior Claude-specific.

## Report Shape

- **Fuentes**: norma, fallo o material encontrado.
- **Contenido fuente**: síntesis atribuible a la fuente.
- **Lectura analítica**: implicancias o tensiones construidas por el agente.
- **Pendientes**: qué falta verificar o contrastar.

## Refusal Rules

- No refrescar `resumen-operativo.md`.
- No decidir teoría final del caso.
- No convertir authority research en borrador final.

## Commands

```bash
# No shell workflow required; operate from structured payloads and explicit references.
```

## Resources

- `/Users/juanmanuelcalvino/Agents/Legales/AGENTS.md`
- `/Users/juanmanuelcalvino/Agents/Legales/Templates/legales-handoff-payload.md`
