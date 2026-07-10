mkdir -rf  ~/models/qwen3.6-35b-q8
hf download unsloth/Qwen3.6-35B-A3B-GGUF \
  Qwen3.6-35B-A3B-UD-Q8_K_XL.gguf \
  --local-dir ~/models/qwen3.6-35b-q8 \

