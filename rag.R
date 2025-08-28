library(ollamar)

# Set up the connection to Ollama
test_connection()
list_models()
embedding_model <- "hf.co/CompendiumLabs/bge-base-en-v1.5-gguf"
language_model <- "hf.co/bartowski/Llama-3.2-1B-Instruct-GGUF"

pull(embedding_model)
pull(language_model)

# catfacts dataset
df <- read.delim("https://huggingface.co/ngxson/demo_simple_rag_py/raw/main/cat-facts.txt", header = FALSE, sep = "\n")
colnames(df) <- c("chunk")

# Cosine similarity function
cosine_similarity <- function(a, b) {
  dot_product <- sum(a * b)
  norm_a <- sqrt(sum(a^2))
  norm_b <- sqrt(sum(b^2))
  return(dot_product / (norm_a * norm_b))
}

# Create embeddings
emb <- embed(model = embedding_model, input = df$chunk)

# Retrieval function
retrieve <- function(input, k = 3) {
  query_emb <- embed(model = embedding_model, input = input)
  similarities <- apply(emb, 2, \(x) cosine_similarity(x, query_emb))
  top_indices <- order(similarities, decreasing = TRUE)[1:k]
  return(df$chunk[top_indices])
}

# Input
input <- "What are some interesting facts about cats?"
knowledge <- retrieve(input, k = 5)

# Generate response using retrieved context
system <- "You are a helpful chatbot. Use only the following pieces of context to answer the question. Don't make up any new information."
prompt <- paste(knowledge, sep = "\n", collapse = "\n ")

generate(model = language_model, prompt = prompt, system = system, output = "text", stream = TRUE, temperature = 2.0)
