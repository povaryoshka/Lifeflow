-- LIFEFLOW v3: выполнить целиком в Supabase → SQL Editor → New query
-- Создаёт таблицу для одного JSON-снимка данных на пользователя.
create table if not exists public.lifeflow_data (
  user_id uuid primary key references auth.users(id) on delete cascade,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.lifeflow_data enable row level security;

-- Пользователь может читать только собственную запись.
drop policy if exists "Users read own LIFEFLOW data" on public.lifeflow_data;
create policy "Users read own LIFEFLOW data"
  on public.lifeflow_data for select
  to authenticated
  using (auth.uid() = user_id);

-- Пользователь может добавлять только собственную запись.
drop policy if exists "Users insert own LIFEFLOW data" on public.lifeflow_data;
create policy "Users insert own LIFEFLOW data"
  on public.lifeflow_data for insert
  to authenticated
  with check (auth.uid() = user_id);

-- Пользователь может обновлять только собственную запись.
drop policy if exists "Users update own LIFEFLOW data" on public.lifeflow_data;
create policy "Users update own LIFEFLOW data"
  on public.lifeflow_data for update
  to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

 grant select, insert, update on public.lifeflow_data to authenticated;
