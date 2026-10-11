-- Futtasd a Supabase SQL Editorban.
-- FONTOS: írd át a SAJAT@EMAIL.HU címet a saját belépő e-mailedre (kétszer szerepel).

create table public.workdays (
  id uuid primary key default gen_random_uuid(),
  work_date date not null default current_date,
  title text not null,
  amount integer not null check (amount >= 0),
  note text,
  created_at timestamptz not null default now()
);

alter table public.workdays enable row level security;

-- Bejelentkezett felhasználó (te és apu) olvashat
create policy "olvasas" on public.workdays
  for select to authenticated using (true);

-- Csak te írhatsz, módosíthatsz, törölhetsz
create policy "iras" on public.workdays
  for all to authenticated
  using ((auth.jwt() ->> 'email') = 'armi.mile@gmail.com')
  with check ((auth.jwt() ->> 'email') = 'armi.mile@gmail.com');

-- Valós idejű szinkron bekapcsolása
alter publication supabase_realtime add table public.workdays;
