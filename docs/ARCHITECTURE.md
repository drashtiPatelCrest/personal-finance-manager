Architecture:

lib/

core/
  network/
  database/
  constants/
  theme/
  widgets/
  services/
  routing/

features/

  auth/
    data/
    domain/
    presentation/

  dashboard/
    data/
    domain/
    presentation/

  settings/
    data/
    domain/
    presentation/

Each feature contains:

data/
  datasource
  repository_impl

domain/
  entities
  repository
  usecases

presentation/
  bloc
  pages
  widgets

Rules:
- UI never talks directly to database.
- Use repositories.
- Use usecases.
- Use immutable states.