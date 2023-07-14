rustup toolchain install nightly
rustup +nightly component add rust-src
rustup +nightly target add wasm32-unknown-unknown
cargo install wasm-pack

cargo build -r --target=wasm32-unknown-unknown