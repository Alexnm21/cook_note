# Reglas de desarrollo para Cook Note

Este documento define cómo debes trabajar en este proyecto. Léelo siempre antes de responder cualquier prompt.

## Identidad del proyecto

- **Cook Note**: app Flutter móvil de gestión de recetas, perfil nutricional y diario de comidas.
- **Framework**: Flutter (SDK `>=3.4.3`).
- **State management**: `flutter_bloc`.
- **Routing**: `go_router`.
- **Backend**: `supabase_flutter`.
- **Local storage**: `hive_flutter`.
- **AI**: `flutter_gemini` (servicio de macronutrientes).
- **i18n**: `easy_localization` (actualmente solo `es` — no hardcodear texto visible).
- **Formato**: escribe código y respuestas en **español** salvo que se pida otra cosa.
## Flujo de trabajo obligatorio

Antes de escribir código para una feature:
1. **Pregunta si hace falta spec** — Si el pedido es una feature nueva o grande, crea/actualiza un archivo de spec en markdown dentro de `specs/` (o pide confirmación para hacerlo). Incluye: descripción, user stories y acceptance criteria.
2. **Aclara lo ambiguo** — Si hay requisitos poco definidos, pregunta antes de implementar.
3. **Plan breve** — Menciona qué archivos vas a tocar y cómo encaja con la arquitectura existente.
4. **Implementa** siguiendo la arquitectura del proyecto (ver abajo).
5. **Valida** — Ejecuta `flutter analyze` y los tests relevantes antes de dar por terminado.

Para cambios pequeños (bugfix, refactor menor), puedes omitir el spec pero mantén el resto del flujo.

## Sugerir reglas nuevas

- Cuando propongas un cambio o una forma de hacer algo que siga una regla determinada, puedes sugerir agregar esa regla a este archivo `AGENTS.md`.
- Ante una sugerencia de regla nueva, crea la entrada correspondiente en la sección más apropiada (arquitectura, convenciones, i18n, validación, etc.) y espera la confirmación del usuario antes de aplicarla.
- No agregues reglas al archivo sin que el usuario las apruebe explícitamente.

## Arquitectura del proyecto

Estructura bajo `lib/`:

- **config/**: `env` (constantes), `router` (GoRouter), `theme` (colores, temas, estilos).
- **core/**: `blocs` (blocs compartidos), `enums`, `extensions`, `models`, `services` (p.ej. `macros_ai_service.dart`), `utils`.
- **data/**: `abstract` (interfaces de repositorio), `hive` (persistencia local), `supabase` (persistencia remota).
- **features/**: módulos de negocio (`login`, `home`, `my_recipes`, `recent_recipes`, `recipe`, `create_edit_recipe`, `diary`, `profile`, `edit_profile`).
- **pages/**: pantallas principales.
- **widgets/**: widgets UI reutilizables.

### Reglas de arquitectura

- **Separa responsabilidades**: la lógica de negocio va en blocs/features, la persistencia en `data/`, la UI en `pages`/`widgets`.
- **Nuevas features** van en `lib/features/<nombre>/`, con su propio conjunto de blocs, modelos y vistas.
- **Repositorios**: define la interfaz en `lib/data/abstract/` y sus implementaciones concretas en `hive/` o `supabase/`. No acoples la UI directamente a la solución de datos.
- **No mezcles** servicios de IA, redes, o lógica reutilizable dentro de widgets o pages: va en `core/services`.

## Convenciones de código

- Sigue `analysis_options.yaml` (usa `package:flutter_lints/flutter.yaml`).
- Usa **imports relativos** (`prefer_relative_imports` está activo).
- Sigue el estilo de `flutter_lints`; no agregues lints personalizados sin preguntar.
- **No agregues comentarios explicativos** salvo que se pidan o sean estrictamente necesarios.
- Mantén el estilo de los archivos vecinos (nombrado, estructura, organización del bloc en `*_bloc.dart`, `*_event.dart`, `*_state.dart`).

## i18n

- Todo texto visible al usuario debe pasar por easy_localization, salvo excepciones acordadas.
- No hardcodees cadenas de UI directamente en los widgets cuando exista una clave de traducción.

## Validación

- Ejecuta `flutter analyze` y arregla todos los errores/warnings antes de terminar.
- Mantén la suite de tests pasando (`flutter test`). Actualiza/agrega tests cuando toques lógica de negocio.

## Otros

- No añadas dependencias nuevas sin justificar y sin confirmar. Prefiere las que ya están en `pubspec.yaml`.
- No modifiques configuración de builds, CI o cuentas sin pedir permiso.
