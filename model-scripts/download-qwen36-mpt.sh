# 1. Download the standard 8 but Best balance of zero-loss accuracy and file size. (29GBB)
HF_XET_HIGH_PERFORMANCE=1 hf download unsloth/Qwen3.6-27B-MTP-GGUF Qwen3.6-27B-Q8_0.gguf --local-dir models/qwen3.6-q8-mpt/

# 2. Download the main 8-bit Unsloth's calibrated dynamic quant. (approx 35.8GB)
HF_XET_HIGH_PERFORMANCE=1 hf download unsloth/Qwen3.6-27B-MTP-GGUF Qwen3.6-27B-UD-Q8_K_XL.gguf --local-dir models/qwen3.6-q8-xl-mpt/

# 3. Download the main 5-bit (approx 19.8GB)
HF_XET_HIGH_PERFORMANCE=1 hf download unsloth/Qwen3.6-27B-MTP-GGUF Qwen3.6-27B-Q5_K_M.gguf --local-dir models/qwen3.6-q5b-mpt/

