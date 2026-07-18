mkdir -p ~/models/deepseek-r1-70b-q8

hf download bartowski/DeepSeek-R1-Distill-Llama-70B-GGUF \
  --include "DeepSeek-R1-Distill-Llama-70B-Q8_0/*" \
  --local-dir ~/models/deepseek-r1-70b-q8