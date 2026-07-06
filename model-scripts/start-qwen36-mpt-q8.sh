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
-m models/qwen3.6-q8-mpt/Qwen3.6-27B-Q8_0.gguf \
--host 0.0.0.0 --port 8080 \
-c 120000 \
-b 4096 \
--ubatch-size 2048 \
--flash-attn on \
--threads 16 \
--threads-batch 16 \
--spec-type draft-mtp \
--spec-draft-n-max 3 \
--spec-draft-p-min 0.75 \
-ngl 999 \
-fa 1 \
-ctk q8_0 -ctv q8_0 \
--no-mmap \
--jinja
