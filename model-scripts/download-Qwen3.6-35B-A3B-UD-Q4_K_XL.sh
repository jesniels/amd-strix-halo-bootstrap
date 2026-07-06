mkdir -rf  ~/models/qwen3.6-q4
hf download unsloth/Qwen3.6-35B-A3B-GGUF \
  Qwen3.6-35B-A3B-UD-Q4_K_XL.gguf \
  --local-dir ~/models/qwen3.6-q4 \

