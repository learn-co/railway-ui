FROM bitwalker/alpine-elixir-phoenix:1.9.4 as releaser

WORKDIR /app

COPY config/ /app/config/
COPY mix.exs mix.lock /app/

COPY . /app/
ENV MIX_ENV=prod
RUN mix deps.get --only $MIX_ENV
RUN mix deps.compile

WORKDIR /app

RUN MIX_ENV=prod mix compile

RUN npm install --prefix ./assets
RUN npm run deploy --prefix ./assets
RUN mix phx.digest

WORKDIR /app
RUN MIX_ENV=prod mix release

########################################################################
FROM bitwalker/alpine-elixir-phoenix:latest

EXPOSE 4000
ENV PORT=4000 \
    MIX_ENV=prod \
    SHELL=/bin/bash

WORKDIR /app
COPY --from=releaser app/_build/prod/rel/railway_ui .
COPY --from=releaser app/bin/ ./bin


CMD ["./bin/railway_ui", "foreground"]
