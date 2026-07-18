mkdir -p ~/models/qwen3-235b-thinking-q8

hf download unsloth/Qwen3-235B-A22B-Thinking-2507-GGUF \
  --include "UD-Q8_K_XL/*" \
  --local-dir ~/models/qwen3-235b-thinking-q8