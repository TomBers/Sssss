FROM elixir:1.11.3-alpine as build

# install build dependencies
RUN apk add --update git build-base python3

# prepare build dir
RUN mkdir /app
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ENV MIX_ENV=prod

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
RUN mix deps.get
RUN mix deps.compile

# build project
COPY priv priv
COPY lib lib
RUN mix compile

# build release
#COPY prod prod
RUN mix release

# prepare release image
FROM alpine:3.12 AS app
RUN apk add --update bash openssl alsa-lib \
                                          at-spi2-atk \
                                          atk \
                                          cairo \
                                          cups-libs \
                                          dbus-libs \
                                          eudev-libs \
                                          expat \
                                          flac \
                                          gdk-pixbuf \
                                          glib \
                                          libgcc \
                                          libjpeg-turbo \
                                          libpng \
                                          libwebp \
                                          libx11 \
                                          libxcomposite \
                                          libxdamage \
                                          libxext \
                                          libxfixes \
                                          tzdata \
                                          libexif \
                                          udev \
                                          xvfb \
                                          zlib-dev \
                                          chromium \
                                          chromium-chromedriver

# Install the chrome driver to run the screenshotting
#RUN npm i chromedriver
#ENV PATH="/node_modules/chromedriver/lib/chromedriver:${PATH}"

RUN mkdir /app
RUN mkdir /app/screenshots
WORKDIR /app

COPY --from=build /app/_build/prod/rel/sssss ./
RUN chown -R nobody: /app
USER nobody

ENV HOME=/app

COPY entry.sh .

CMD ["./entry.sh"]