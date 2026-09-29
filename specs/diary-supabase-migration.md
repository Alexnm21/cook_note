# Spec: Migrar el diario de Hive a Supabase

## Descripción

El diario de comidas (`DiaryDay`) actualmente se persiste en local con Hive.
Se migra a Supabase para que los datos del diario queden por usuario y
sincronizados entre dispositivos. Los "recent recipes" se mantienen en Hive
(no se migran).

Como parte del cambio, el modelo `DiaryDay` se renombra a `DiaryEntry` para
ser coherente con la tabla `diary_entries`.

## User stories

- Como usuario, quiero que mis comidas registradas en el diario se guarden en
  la nube para no perderlas al cambiar de dispositivo.
- Como usuario, quiero ver el mismo diario al iniciar sesión en otro dispositivo.

## Acceptance criteria

- [x] El diario se lee/guarda desde la tabla `diary_entries` de Supabase.
- [x] Un día sin comidas no se persiste en la BD: la fila se crea solo al añadir la primera comida y se elimina si quedan 0 comidas.
- [x] Los "recent recipes" siguen guardándose en Hive (sin cambios).
- [x] El modelo `DiaryDay` pasa a llamarse `DiaryEntry` en todo el código.
- [x] `ProfileBloc` usa `SupabaseDiaryRepository` y pasa `userId` a las llamadas del diario.
- [x] Se elimina `hive_diary_repository.dart`.
- [x] Pasan `flutter analyze` y `flutter test`.

## SQL (aplicar manualmente en Supabase)

```sql
create table public.diary_entries (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  date date not null,
  meals jsonb not null default '[]'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (user_id, date)
);

alter table public.diary_entries enable row level security;

create policy "select own diary entries"
  on public.diary_entries for select
  using (auth.uid() = user_id);

create policy "insert own diary entries"
  on public.diary_entries for insert
  with check (auth.uid() = user_id);

create policy "update own diary entries"
  on public.diary_entries for update
  using (auth.uid() = user_id);

create policy "delete own diary entries"
  on public.diary_entries for delete
  using (auth.uid() = user_id);
```

## Archivos tocados

- `lib/core/models/diary_day.dart` → renombrar a `diary_entry.dart` (clase `DiaryEntry`).
- `lib/core/enums/supabase_names.dart`: agregar `diary_entries`.
- `lib/data/abstract/diary_repository.dart`: agregar `userId` a los métodos.
- `lib/data/supabase/supabase_diary_repository.dart`: nuevo repositorio.
- `lib/data/hive/hive_diary_repository.dart`: eliminar.
- `lib/features/profile/bloc/profile_bloc.dart`: usar repo supabase + `userId`.
- `lib/features/profile/bloc/profile_event.dart`: renombrar `SetDiaryDay` (opcional).
- `lib/features/profile/bloc/profile_state.dart`: renombrar campo `diaryDay`.
- `lib/features/diary/parts/objective_part.dart`: ajustar a `DiaryEntry`.
- `test/mocks/mock_repositories.dart`: actualizar.

## Notas

- El SQL debe aplicarse manualmente en Supabase (no hay carpeta `supabase/` en el repo).
- `toMap`/`fromMap` del modelo reutilizan el mismo formato JSON para la columna `meals`.