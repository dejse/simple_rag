# simple_rag
Simplified RAG (Retrieval Augmented Generation) with R

Original Version from here: 
https://huggingface.co/blog/ngxson/make-your-own-rag

I translated the code from `Python` to `R` in order to understand RAG setups and what they are used for. I identified two key steps: 
1. Knowledge chunks are vectorized with embedding models. The search query is also vectorized and with cosine similarity the most similar knowledge chunks are identified.
2. The most similar chunks are "retrieved" and appended to the prompt. The LLM uses the retrieved knowledge for its text generation. 
