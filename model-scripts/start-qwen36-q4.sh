#llama-server -m models/gemma-4-26B-q4/gemma-4-26B-A4B-it-UD-Q4_K_M.gguf   -c 8192 -ngl 999 -fa 1 --no-mmap
#llama-server \
#-m models/gemma-4-26B-q4/gemma-4-26B-A4B-it-UD-Q4_K_M.gguf \
#-md models/gemma-4-26B-q4/gemma-4-26B-A4B-it-assistant.Q4_K_M.gguf \
#-c 32768 \
#-ngl 999 \
#-ngld 999 \
#-fa 1 \
#--no-mmap \
#--jinja \
#-ctk q8_0 -ctv q8_0


llama-server \
  -m ~/models/qwen3.6-q4/Qwen3.6-35B-A3B-UD-Q4_K_XL.gguf \
  --host 0.0.0.0 \
  --port 8080 \
  -c 65536 \
  -b 8192 \
  --ubatch-size 4096 \
  --threads 16 \
  --threads-batch 16 \
  -ngl 999 \
  -fa on \
  -ctk q8_0 \
  -ctv q8_0 \
  --jinja \
  --cache-type-k q8_0 \
  --cache-type-v q8_0
