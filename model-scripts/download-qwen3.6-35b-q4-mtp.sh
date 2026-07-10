mkdir -rf  ~/models/qwen3.6-q4-mtp
hf download unsloth/Qwen3.6-35B-A3B-MTP-GGUF \
  Qwen3.6-35B-A3B-UD-Q4_K_XL.gguf \
  --local-dir ./models/qwen3.6-q4-mtp
