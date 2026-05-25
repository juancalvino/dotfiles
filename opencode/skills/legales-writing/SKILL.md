---
name: legales-writing
description: >
  Redacta piezas legales desde payloads con categorías ya separadas, preservando aislamiento entre
  hechos, estrategia y referencias documentales. Trigger: cuando Legales necesita cartas, reclamos,
  escritos, resúmenes o borradores finales sin delegar determinación factual, framing ni research.
license: Apache-2.0
metadata:
  author: gentle-orchestrator
  version: "1.0"
---

## When to Use

- Redactar cartas, reclamos, resúmenes o borradores legales desde payload saneado.
- Reescribir borradores existentes preservando separación de categorías.
- Preparar variantes de estilo sin mezclar referencias documentales con prosa generada.

## Critical Patterns

- Este skill es **OpenCode-global**.
- Requiere payload con `facts[]`, `hypotheses[]`, `strategy_considerations[]`, `drafts[]` y `documentary_references[]` separados.
- **MUST NOT** determinar hechos, hacer framing normativo sustantivo ni investigar fuentes.
- **MUST NOT** promover `proposed_factual_update[]` a contenido verificado.
- Las referencias documentales quedan separadas del texto generado; el draft no se presenta como documento del expediente.
- Si el payload llega mezclado, rechazar y pedir separación antes de redactar.

## Output Contract

- **Borrador principal**: texto generado según deliverable pedido.
- **Supuestos visibles**: condicionalidades que dependen de verificación.
- **Referencias documentales**: bloque separado, nunca incrustado como si fuera afirmación propia del expediente.

## Refusal Rules

- No refrescar `resumen-operativo.md`.
- No decidir disputas fácticas.
- No reemplazar `legales-argentina-consumer-law` ni `legales-case-research`.

## Commands

```bash
# No shell workflow required; drafting begins only from separated payload categories.
```

## Resources

- `/Users/juanmanuelcalvino/Agents/Legales/AGENTS.md`
- `/Users/juanmanuelcalvino/Agents/Legales/Templates/legales-handoff-payload.md`
