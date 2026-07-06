# 1. Download the main 26B-A4B Instruct model
HF_XET_HIGH_PERFORMANCE=1 hf download unsloth/gemma-4-26B-A4B-it-GGUF gemma-4-26B-A4B-it-UD-Q4_K_M.gguf --local-dir models/gemma-4-26B-q4/
# 2. Download the speculative assistant model
HF_XET_HIGH_PERFORMANCE=1 hf download AtomicChat/gemma-4-26B-A4B-it-assistant-GGUF gemma-4-26B-A4B-it-assistant.Q4_K_M.gguf  --local-dir models/gemma-4-26B-q4/

# 1. Download the main 8-bit Instruct model (approx 26.9 GB)
HF_XET_HIGH_PERFORMANCE=1 hf download unsloth/gemma-4-26B-A4B-it-GGUF gemma-4-26B-A4B-it-UD-Q8_K_XL.gguf --local-dir models/gemma-4-26B-q8/
# 2. Download the 8-bit Speculative Assistant model
HF_XET_HIGH_PERFORMANCE=1 hf download AtomicChat/gemma-4-26B-A4B-it-assistant-GGUF gemma-4-26B-A4B-it-assistant.Q8_0.gguf  --local-dir models/gemma-4-26B-q8/
