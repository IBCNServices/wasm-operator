#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

generate_wasm_yaml_file() {
  NR_CONTROLLERS=$1
  NAME=$2

  for (( CONTROLLER_NR = 0; CONTROLLER_NR < NR_CONTROLLERS; CONTROLLER_NR++ ))
  do

  cat << EOF
name: ${NAME}${CONTROLLER_NR}
wasm: ./wasm/ring-pod-example.wasi.wasm
env:
- name: RUST_LOG
  value: "debug"
- name: IN_NAMESPACE
  value: "${NAME}${CONTROLLER_NR}"
- name: OUT_NAMESPACE
  value: "${NAME}$(((CONTROLLER_NR+1) % NR_CONTROLLERS))"
---
EOF

  done
}

generate_pod_yaml_file() {
  NR_CONTROLLERS=$1
  NAME=$2
  IMAGE=$3

  for (( CONTROLLER_NR = 0; CONTROLLER_NR < NR_CONTROLLERS; CONTROLLER_NR++ ))
  do

  cat << EOF
apiVersion: v1
kind: Pod
metadata:
  name: controller${CONTROLLER_NR}
  namespace: ${NAME}
spec:
  serviceAccountName: custom-controller
  containers:
  - name: controller
    image: "${IMAGE}"
    env:
    - name: RUST_LOG
      value: "debug"
    - name: IN_NAMESPACE
      value: "${NAME}${CONTROLLER_NR}"
    - name: OUT_NAMESPACE
      value: "${NAME}$(((CONTROLLER_NR+1) % NR_CONTROLLERS))"
---
EOF

  done
}

generate_namespace_yaml_file() {
  NR_CONTROLLERS=$1
  NAME=$2

  for (( CONTROLLER_NR = 0; CONTROLLER_NR < NR_CONTROLLERS; CONTROLLER_NR++ ))
  do
  
  cat << EOF
apiVersion: v1
kind: Namespace
metadata:
  name: "${NAME}${CONTROLLER_NR}"
---
EOF

  done
}
