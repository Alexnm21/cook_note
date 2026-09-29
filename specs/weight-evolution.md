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

- [x] El usuario puede añadir un pesaje nuevo (fecha + kg) desde la pantalla.
- [x] La pantalla muestra "PESO ACTUAL": peso actual en grande, cambio reciente
      al lado y línea de progreso hacia el objetivo (azcla la vista de
      macronutrientes del diario).
- [x] La "Curva mensual" muestra el gráfico de evolución y el usuario puede
      elegir el rango (1 mes, 3 meses, 6 meses, 1 año, todos).
- [x] Una fila de tres chips muestra peso mínimo histórico, máximo histórico
      y ritmo de bajada con valoración de saludabilidad.
- [x] La lista "Historial de pesajes" muestra cada registro en un list tile.
- [x] Existe estado vacío cuando el usuario no tiene pesajes.
- [x] Pasan `flutter analyze` y `flutter test`.

## Desviaciones respecto al diseño original

- El acceso para añadir un pesaje se implementó como `FloatingActionButton`
  (`lib/features/weight/view/weight_view.dart`) en lugar de un botón al final
  de la lista. En el estado vacío sí aparece el botón "Añadir pesaje" con
  `CustomButton.text`.
- El chip de peso actual muestra la fecha del **último pesaje registrado**
  (`state.currentRecord.date`), no la fecha de hoy. Se cambió porque con la
  fecha de hoy el peso mostrado podía no corresponder a esa fecha.
- El rango por defecto del gráfico es 1 mes, y el selector incluye "Todos"
  además de 1 mes / 3 meses / 6 meses / 1 año.

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

5. **Botón "Añadir pesaje"**: implementado como `FloatingActionButton`
   (ver "Desviaciones" más abajo).

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

## Archivos tocados

- `lib/core/enums/supabase_names.dart`: agregar `weightRecords('weight_records')`.
- `lib/core/models/weight_record.dart`: nuevo modelo (`id`, `weightKg`, `date`, `toMap`/`fromMap`).
- `lib/data/abstract/weight_repository.dart`: nueva interfaz.
- `lib/data/supabase/supabase_weight_repository.dart`: nuevo repositorio (patrón singleton).
- `lib/features/weight/`: nueva feature con `bloc/` (`weight_bloc.dart`, `weight_event.dart`, `weight_state.dart`) y `view/`.
- `lib/config/router/router.dart`: nueva ruta hacia la pantalla de evolución.
- `lib/features/profile/`: entrada/punto de acceso a la pantalla.
- `assets/translations/es.json`: claves de texto visibles.
- `lib/pages/weight_evolution_page.dart`: page host con `BlocProvider`.
- `lib/features/weight/`: `view/` (`weight_view.dart`, `add_weight_dialog.dart`)
  y `parts/` divididas por secciones de la pantalla.
- `test/features/weight/weight_state_test.dart`: tests de `WeightState` y
  `WeightRecord`.

## Notas

- El "cambio reciente" (delta) se calcula entre el pesaje actual y el
  inmediatamente anterior, considerando solo registros con fecha no futura
  (`WeightState.recentChange`).
- La "valoración de saludabilidad" del ritmo de bajada se calcula sobre el
  peso perdido por semana en el rango seleccionado
  (`WeightState.weeklyLossRate`). Se considera saludable una pérdida de
  hasta 1 kg/semana; por encima se muestra "Muy rápido"
  (`WeightState.isHealthyLoss`).
- El punto de acceso desde el perfil es una fila "Evolución del peso" dentro
  de la tarjeta "Información Física"
  (`lib/features/profile/view/profile_view.dart`).
- El progreso hacia el objetivo se calcula sobre el primer y el último
  pesaje del rango seleccionado (`WeightState.goalProgress`), con el objetivo
  tomado de `profiles.target_weight`.
- Gráfico construido con un `CustomPainter` propio
  (`lib/features/weight/parts/weight_chart_part.dart`), sin dependencias
  externas.
- Tests: `test/features/weight/weight_state_test.dart` cubre la lógica de
  `WeightState` y el modelo `WeightRecord`. No hay tests del `WeightBloc`;
  no se creó mock de `WeightRepository`.