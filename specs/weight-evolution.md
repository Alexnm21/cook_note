# Spec: Evolución del peso

## Descripción

El usuario registra su peso en el perfil, pero hoy solo se guarda el peso
actual sin historial. Esta feature agrega un log de pesajes (`weight_records`)
en Supabase y una pantalla "Evolución del peso", accesible desde el perfil,
que muestra el progreso hacia el objetivo, la curva de evolución y el
historial de registros.

## User stories

- Como usuario, quiero ver mi peso actual y cuánto he bajado/aumentado
  recientemente.
- Como usuario, quiero ver una curva mensual de mi evolución de peso con
  distintos rangos (1 mes, 3 meses, 1 año...).
- Como usuario, quiero conocer mi peso mínimo y máximo histórico, y el ritmo
  de bajada de peso con su valoración (saludable o no).
- Como usuario, quiero ver el historial de mis pesajes y añadir uno nuevo.
- Como usuario, quiero ver mi progreso hacia el peso objetivo con una línea
  de progreso.

## Acceptance criteria

- [ ] El usuario puede añadir un pesaje nuevo (fecha + kg) desde la pantalla.
- [ ] La pantalla muestra "PESO ACTUAL" con la fecha de hoy: peso actual en
      grande, cambio reciente al lado y línea de progreso hacia el objetivo
      (azcla la vista de macronutrientes del diario).
- [ ] La "Curva mensual" muestra el gráfico de evolución y el usuario puede
      elegir el rango (1 mes, 3 meses, 1 año...).
- [ ] Una fila de tres chips muestra peso mínimo histórico, máximo histórico
      y ritmo de bajada con valoración de saludabilidad.
- [ ] La lista "Historial de pesajes" muestra cada registro en un list tile.
- [ ] El botón "Añadir pesaje" está al final de la pantalla.
- [ ] Existe estado vacío cuando el usuario no tiene pesajes.
- [ ] Pasan `flutter analyze` y `flutter test`.

## UI (desde el diseño, de arriba a abajo)

1. **Chip "PESO ACTUAL"** con la fecha de hoy como título:
   - Peso actual en grande.
   - Al lado, cuánto ha perdido recientemente (delta).
   - Debajo, línea de progreso (como la de proteínas del diario) que indica
     cuánto peso lleva perdido hasta el objetivo.

2. **Chip "Curva mensual"**:
   - Gráfico de evolución del peso.
   - Fuera del chip, selector de rango: 1 mes, 3 meses, 1 año...

3. **Fila de tres chips**:
   - Peso mínimo histórico.
   - Peso máximo histórico.
   - Ritmo de bajada de peso (indica si el ritmo es saludable o no).

4. **Lista "Historial de pesajes"**: lista vertical de tiles con cada registro.

5. **Botón "Añadir pesaje"** al final de la pantalla.

## SQL (aplicar manualmente en Supabase)

```sql
create table public.weight_records (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  weight_kg numeric(5,2) not null,
  date date not null,
  created_at timestamptz not null default now(),
  unique (user_id, date)
);

alter table public.weight_records enable row level security;

create policy "select own weight records"
  on public.weight_records for select
  using (auth.uid() = user_id);

create policy "insert own weight records"
  on public.weight_records for insert
  with check (auth.uid() = user_id);

create policy "update own weight records"
  on public.weight_records for update
  using (auth.uid() = user_id);

create policy "delete own weight records"
  on public.weight_records for delete
  using (auth.uid() = user_id);

-- Campo de peso objetivo en el perfil (para la línea de progreso)
alter table public.profiles
  add column target_weight numeric(5,2);
```

## Archivos tocados (plan)

- `lib/core/enums/supabase_names.dart`: agregar `weightRecords('weight_records')`.
- `lib/core/models/weight_record.dart`: nuevo modelo (`id`, `weightKg`, `date`, `toMap`/`fromMap`).
- `lib/data/abstract/weight_repository.dart`: nueva interfaz.
- `lib/data/supabase/supabase_weight_repository.dart`: nuevo repositorio (patrón singleton).
- `lib/features/weight/`: nueva feature con `bloc/` (`weight_bloc.dart`, `weight_event.dart`, `weight_state.dart`) y `view/`.
- `lib/config/router/router.dart`: nueva ruta hacia la pantalla de evolución.
- `lib/features/profile/`: entrada/punto de acceso a la pantalla.
- `assets/translations/es.json`: claves de texto visibles.
- `test/mocks/mock_repositories.dart`: mock de `WeightRepository`.
- `test/...`: tests del `WeightBloc`.

## Notas

- El "cambio reciente" (delta) se calcula entre el pesaje actual y el anterior
  al mismo (o el del periodo seleccionado, por definir).
- La "valoración de saludabilidad" del ritmo de bajada se calcula comparando
  la pérdida semanal/media (rango saludable habitual: 0,5–1 kg por semana),
  por confirmar el criterio exacto.
- El punto de acceso desde el perfil aún está por decidir en detalle (tarjeta
  vs. list tile) según el diseño disponible.
- Gráfico: no agregar dependencias nuevas sin confirmación; si no se permiten
  (p.ej. `fl_chart`), el gráfico debe construirse con widgets propios.