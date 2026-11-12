# Gimme Golf Shop

Marketplace de equipamento de golfe usado. SPA (Single Page App) em HTML/CSS/JS vanilla — um único arquivo `index.html` de ~4400 linhas.

## Stack
- **Frontend**: HTML + CSS + JS vanilla, sem frameworks
- **Banco de dados**: Supabase (PostgreSQL)
- **Auth**: Supabase Auth (email/senha)
- **Hospedagem**: GitHub Pages
- **Domínio**: gimmegolf.com.br (DNS no GoDaddy)
- **Repositório**: https://github.com/jphoerde/gimme-golf-shop

## Supabase
- **URL**: https://twgwikobhfzgiavxqxnh.supabase.co
- **Dashboard**: https://supabase.com/dashboard/project/twgwikobhfzgiavxqxnh
- **Chave anon**: `sb_publishable_rY554XHQEHcjsEk-LQRxbw_1KIMcEOo`
- Schema criado com `schema.sql` na raiz do projeto

## Tabelas no banco
| Tabela | O que guarda |
|--------|-------------|
| `profiles` | Usuários reais (vinculado ao auth.users) |
| `products` | Anúncios de produtos reais |
| `orders` | Pedidos/compras |
| `offers` | Ofertas e contrapropostas |
| `favorites` | Favoritos por usuário |

## Arquitetura
- Todo o estado vive no objeto `STORE` (em memória + localStorage)
- `initStoreAsync()` inicializa: carrega localStorage → renderiza imediatamente → sincroniza com Supabase → re-renderiza
- `isRealUser(userId)` distingue usuários reais (UUID) de demos (string como 'joao', 'carla')
- Dados de demo (SELLERS, ALL_PRODUCTS) ficam hardcoded para visitantes não logados
- Usuários reais têm dados persistidos no Supabase e visíveis para todos

## Funções-chave do Supabase
- `loadSupabaseUser(user)` — carrega perfil após login
- `loadSupabaseProducts()` — merge produtos reais + demo
- `loadUserOrders/Offers/Favorites()` — carrega dados do usuário logado
- `syncOfferToSupabase(offer, pid)` — sincroniza oferta

## Publicar mudanças
```bash
cd /Users/joaopedrohoerde/Downloads/gimme-golf-shop
git add -A && git commit -m "mensagem" && git push
```
GitHub Pages atualiza automaticamente em ~1 minuto.

## DNS (GoDaddy)
- 3x registros A `@` → IPs do GitHub Pages (185.199.108-110.153)
- CNAME `www` → `jphoerde.github.io`
- HTTPS: ativado automaticamente pelo GitHub quando certificado SSL for emitido (~24h após DNS)

## Próximos passos sugeridos
- Integração de pagamento (Mercado Pago ou Stripe)
- Upload de imagens para Supabase Storage
- Integração real dos Correios (requer contrato SRO/SIGEP)
- Notificações por e-mail (Supabase Edge Functions)
