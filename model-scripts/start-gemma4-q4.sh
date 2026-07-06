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
-m models/gemma-4-26B-q4/gemma-4-26B-A4B-it-UD-Q4_K_M.gguf \
--host 0.0.0.0 --port 8080 \
-c 32768 \
-ngl 999 \
-fa 1 \
-ctk q8_0 -ctv q8_0 \
--no-mmap \
--jinja
