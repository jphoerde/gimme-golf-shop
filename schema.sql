-- Gimme Golf Shop — Supabase Schema
-- Cole tudo isso no SQL Editor em:
-- https://supabase.com/dashboard/project/twgwikobhfzgiavxqxnh/sql/new

-- ============================================================
-- PROFILES (vinculado ao auth.users do Supabase)
-- ============================================================
create table if not exists public.profiles (
  id uuid references auth.users on delete cascade primary key,
  name text not null,
  email text,
  city text default '',
  state text default '',
  bio text default '',
  rating numeric default 0,
  rating_count int default 0,
  sales_count int default 0,
  purchases_count int default 0,
  initials text,
  color text default '#1B3B2C',
  verified boolean default false,
  joined date default current_date,
  created_at timestamptz default now()
);

alter table public.profiles enable row level security;

create policy "Perfis são públicos para leitura"
  on public.profiles for select using (true);

create policy "Usuário pode criar seu próprio perfil"
  on public.profiles for insert with check (auth.uid() = id);

create policy "Usuário pode editar seu próprio perfil"
  on public.profiles for update using (auth.uid() = id);

-- ============================================================
-- PRODUCTS
-- seller_id é UUID (somente usuários reais criam produtos reais)
-- ============================================================
create table if not exists public.products (
  id text primary key,
  seller_id uuid references public.profiles(id) on delete cascade not null,
  status text not null default 'ativo',
  price numeric not null default 0,
  data jsonb not null,
  created_at timestamptz default now()
);

alter table public.products enable row level security;

create policy "Produtos ativos são públicos"
  on public.products for select
  using (status <> 'rascunho' or seller_id = auth.uid());

create policy "Usuário pode criar seus produtos"
  on public.products for insert with check (seller_id = auth.uid());

create policy "Usuário pode editar seus produtos"
  on public.products for update using (seller_id = auth.uid());

create policy "Usuário pode excluir seus produtos"
  on public.products for delete using (seller_id = auth.uid());

-- ============================================================
-- ORDERS
-- buyer_id = UUID (comprador é sempre usuário real)
-- seller_id = text (pode ser UUID ou ID de demo como 'joao')
-- ============================================================
create table if not exists public.orders (
  id text primary key,
  product_id text,
  buyer_id uuid references public.profiles(id),
  seller_id text,
  data jsonb not null,
  created_at timestamptz default now()
);

alter table public.orders enable row level security;

create policy "Usuário vê seus próprios pedidos"
  on public.orders for select
  using (auth.uid() = buyer_id or auth.uid()::text = seller_id);

create policy "Comprador pode criar pedido"
  on public.orders for insert with check (auth.uid() = buyer_id);

create policy "Comprador ou vendedor pode atualizar pedido"
  on public.orders for update
  using (auth.uid() = buyer_id or auth.uid()::text = seller_id);

-- ============================================================
-- OFFERS
-- buyer_id = UUID, seller_id = text
-- ============================================================
create table if not exists public.offers (
  id text primary key,
  product_id text,
  buyer_id uuid references public.profiles(id),
  seller_id text,
  data jsonb not null,
  created_at timestamptz default now()
);

alter table public.offers enable row level security;

create policy "Usuário vê suas próprias ofertas"
  on public.offers for select
  using (auth.uid() = buyer_id or auth.uid()::text = seller_id);

create policy "Comprador pode criar oferta"
  on public.offers for insert with check (auth.uid() = buyer_id);

create policy "Comprador ou vendedor pode atualizar oferta"
  on public.offers for update
  using (auth.uid() = buyer_id or auth.uid()::text = seller_id);

-- ============================================================
-- FAVORITES
-- ============================================================
create table if not exists public.favorites (
  user_id uuid references public.profiles(id) on delete cascade,
  product_id text not null,
  created_at timestamptz default now(),
  primary key (user_id, product_id)
);

alter table public.favorites enable row level security;

create policy "Usuário vê seus próprios favoritos"
  on public.favorites for select using (auth.uid() = user_id);

create policy "Usuário pode adicionar favorito"
  on public.favorites for insert with check (auth.uid() = user_id);

create policy "Usuário pode remover favorito"
  on public.favorites for delete using (auth.uid() = user_id);
