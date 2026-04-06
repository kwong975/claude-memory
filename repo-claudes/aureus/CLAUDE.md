# aureus

Personal finance dashboard. Pure UI consumer of data-layer API. No business logic in the frontend.

---

## Key Facts

- Stack: React 19, TypeScript (strict), Vite 7, Tailwind 4, bun
- Data: TanStack React Query, REST via fetch
- Charts: Recharts
- Icons: Lucide React
- API: data-layer at `http://100.77.165.99:8083` (configurable via `VITE_FINANCE_API_URL`)
- Deploy: Mac Mini `:8084` (prod), MacBook `:5173` (dev)

### Source Layout

| Directory | Purpose |
|-----------|---------|
| `src/pages/` | Dashboard, Forecast, NetWorth, Operate |
| `src/components/` | UI components |
| `src/lib/` | API modules — finance, networth, investment, insurance, RE, ESOP, loans |
| `src/hooks/` | Custom React hooks |
| `src/config/` | Polling intervals, HTTP timeouts/retries |
| `src/types/` | TypeScript type definitions |

### Theme

- CSS variables + `data-theme` attribute (dark default, light support)
- Teal accent, semantic status colors
- Fonts: Inter (UI), JetBrains Mono (code)

---

## Modification Guardrails

### Safe Without Confirmation
- Component styling and layout changes
- Adding display-only components or pages
- Updating chart configurations
- Bug fixes in existing components

### Requires Confirmation
- New API integrations or endpoints consumed
- Adding npm dependencies
- Changes to polling intervals or timeout config
- Changes to data transformation logic in lib/

### Breaking Changes
- API contract assumptions (response shapes from data-layer)
- Build configuration changes (Vite, Tailwind, path aliases)
- Environment variable changes (VITE_FINANCE_API_URL)
