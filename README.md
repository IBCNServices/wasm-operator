# Kubernetes Operators in WebAssembly

This repository contains the code of a prototype runtime for running Kubernetes operators in WebAssembly. The goal is to improve the memory usage of a Kubernetes cluster by reducing the memory footprint of operators. This prototype reduces the overhead in three ways.

* It runs operators in a shared WebAssembly runtime to reduce the overhead of containerization.
* It swaps operators to disk when there are no changes to process.
* It uses the Rust programming language instead of Go.

For more information, read the paper [Adapting Kubernetes controllers to the edge: on-demand control planes using Wasm and WASI](https://doi.org/10.48550/arXiv.2209.01077) accepted to CloudNet 2022.

This project builds upon [this proof of concept](https://github.com/slinkydeveloper/extending-kubernetes-api-in-process-poc).

```text
+-- 📂controllers                       # All operators used for testing
|   +-- 📂comb-rust-controller          # Rust combined operator (no isolation)
|   +-- 📂ring-go-controller            # Go operator (container-based)
|   +-- 📂ring-rust-controller          # Rust operator (container-based and WASM-based)
|   :
+-- 📂devel                             # Tools for building & deploying
+-- 📂full_test                         # Script for running e2e test & benchmark
+-- 📂pkg
|   +-- 📂controller                    # Parent controller
|   +-- 📂kube-rs                       # Modified kube-rs library
|   +-- 📂kube-runtime-abi              # ABI for making Kubernetes API requests from within child operator
|   :
+-- 📂profile                           # Cgroup v2 memory usage measuring
+-- 📂test                              # Deployment files for tests
:
```

## Run all e2e tests and benchmarks

```console
> ./full_test/run.sh
```

## Copyright

This code is released under the Apache License Version 2.0.

This prototype was initially developed by Tim Ramlot as part of his Master's dissertation.
