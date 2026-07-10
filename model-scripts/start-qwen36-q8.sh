llama-server \
  -m ~/models/qwen3.6-35b-q8/Qwen3.6-35B-A3B-UD-Q8_K_XL.gguf \
  --host 0.0.0.0 \
  --port 8080 \
  -c 250000 \
  --threads 16 \
  --threads-batch 16 \
  -ngl 999 \
  -fa on \
  --jinja \
  --cache-type-k q8_0 \
  --cache-type-v q8_0 \
  --mlock \
  -t 16 \
  --cache-ram 32768 \
  --cache-reuse 256 \
  --no-context-shift
  -b 8192 --ubatch-size 4096 

# Adjust for this if VRAM crashed:
# -b 4096 --ubatch-size 1024

# Prompt caching:
#--cache-ram 32768 \
#--cache-reuse 256 \
#--no-context-shift
# 
# OR
#  --prompt-cache ~/models/qwen3.6-q8-prompt-cache \
#  --prompt-cache-size 300000 \
