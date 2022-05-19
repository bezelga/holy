FROM rust:1.60 as build

# create a new empty shell project
RUN USER=root cargo new --bin holy
WORKDIR /holy

# copy over your manifests
COPY ./Cargo.lock ./Cargo.lock
COPY ./Cargo.toml ./Cargo.toml

RUN cargo build --release
RUN rm src/*.rs

COPY ./src ./src

RUN rm ./target/release/deps/holy*
RUN cargo build --release

FROM debian:buster-slim
COPY --from=build /holy/target/release/holy .
CMD ["./holy"]