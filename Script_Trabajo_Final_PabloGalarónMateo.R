# -----------------------------------------------------------------------------
# ANÁLISIS DE POLARIZACIÓN Y REDES - VITO QUILES
# AUTOR: Pablo Galarón Mateo
# -----------------------------------------------------------------------------

# --- 1. CARGA DE LIBRERÍAS ---------------------------------------------------
# Cargamos todas las librerías necesarias al principio para mantener el orden
library(readr)
library(dplyr)
library(tidyr)
library(ggplot2)       # Visualización
library(RColorBrewer)  # Paletas de color
library(tm)            # Minería de textos
library(SnowballC)     # Stemming 
library(textclean)     # Limpieza de emojis y caracteres especiales
library(caret)         # Machine Learning (particiones y métricas)
library(e1071)         # Modelos (Naive Bayes + SVM)
library(igraph)        # Análisis de Redes (SNA)

# Limpiamos el entorno de trabajo previo
rm(list = ls())
cat(">>> Librerías cargadas y entorno limpio.\n")

# --- 2. CARGA Y EXPLORACIÓN DE DATOS -----------------------------------------
# Definimos el nombre del archivo
archivo_csv <- "tweets.csv"

if(file.exists(archivo_csv)) {
  tweets <- read.csv(archivo_csv, fileEncoding = "UTF-8")
  
  # Convertimos la etiqueta en factor ordenado
  tweets$label <- factor(tweets$label, levels = c("a_favor", "en_contra", "neutral"))
  
  print(table(tweets$label)) # Ver conteo en consola
  
} else {
  stop("ERROR: No se encuentra el archivo 'tweets100.csv'. Revisa la ruta.")
}

# --- 3. VISUALIZACIÓN INICIAL (DISTRIBUCIÓN) ---------------------------------
plot_distribucion <- ggplot(tweets, aes(x = label, fill = label)) +
  geom_bar(color = "white", width = 0.7) +
  scale_fill_manual(values = c(
    "a_favor"   = "#4DA6FF",
    "en_contra" = "#FF6666",
    "neutral"   = "#BFBFBF"
  )) +
  theme_minimal() +
  labs(title = "Distribución de clases en el dataset",
       x = "Etiqueta",
       y = "Número de tweets") +
  theme(
    plot.title = element_text(face = "bold", hjust = 0.5),
    legend.position = "none"
  )

print(plot_distribucion)

# --- 4. PREPROCESAMIENTO DE TEXTO (NLP) --------------------------------------
cat(">>> Procesando texto...\n")

corpus <- VCorpus(VectorSource(tweets$text))

# Pipeline de limpieza
corpus <- tm_map(corpus, content_transformer(tolower))
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, stripWhitespace)
corpus <- tm_map(corpus, removeWords, stopwords("spanish"))

# Crear Matriz Documento-Término (DTM)
dtm <- DocumentTermMatrix(corpus)
dtm <- removeSparseTerms(dtm, 0.99) # Reducir dispersión
dtm_mat <- as.matrix(dtm)

cat(">>> Dimensiones de la DTM:", dim(dtm_mat), "\n")

# --- 5. PREPARACIÓN TRAIN / TEST ---------------------------------------------
set.seed(123)

trainIndex <- createDataPartition(tweets$label, p = 0.8, list = FALSE)

# División de datos
train_dtm <- dtm_mat[trainIndex, ]
test_dtm  <- dtm_mat[-trainIndex, ]

train_labels <- tweets$label[trainIndex]
test_labels  <- tweets$label[-trainIndex]

# (Opcional) Limpieza de varianza cero si fuera necesario
# nzv <- nearZeroVar(train_dtm)
# if(length(nzv) > 0) {
#   train_dtm <- train_dtm[, -nzv]
#   test_dtm  <- test_dtm[, -nzv]
# }

# --- 6. ENTRENAMIENTO DEL MODELO (SVM) ---------------------------------------
cat(">>> Entrenando modelo SVM...\n")

svm_model <- svm(
  x = train_dtm,
  y = train_labels,
  kernel = "linear",
  cost = 1,
  scale = TRUE
)

# Predicción
svm_pred <- predict(svm_model, test_dtm)

# Evaluación
cm <- confusionMatrix(svm_pred, test_labels)
print(cm)

# --- 7. VISUALIZACIÓN DE RESULTADOS (MATRIZ) ---------------------------------
cm_df <- as.data.frame(cm$table)

plot_confusion <- ggplot(cm_df, aes(x = Reference, y = Prediction, fill = Freq)) +
  geom_tile() +
  geom_text(aes(label = Freq), color = "white", size = 5, fontface = "bold") +
  scale_fill_gradient(low = "steelblue", high = "red") +
  theme_minimal() +
  labs(title = "Matriz de Confusión - SVM",
       subtitle = "Evaluación del modelo de clasificación") +
  theme(plot.title = element_text(face = "bold", hjust = 0.5))

print(plot_confusion)

# --- 8. ANÁLISIS DE REDES SOCIALES (SNA) -------------------------------------
cat(">>> Generando grafo de red...\n")

# Limpieza de nombres de usuario
tweets$user <- trimws(tweets$user)

# Crear nodos únicos
nodes <- tweets %>% 
  distinct(user, .keep_all = TRUE) %>% 
  select(id = user, group = label)

# --- Simulación de estructura polarizada ---
set.seed(42) 

users_favor   <- nodes$id[nodes$group == "a_favor"]
users_contra  <- nodes$id[nodes$group == "en_contra"]
users_neutral <- nodes$id[nodes$group == "neutral"]

# Generar aristas (conexiones)
# 1. Conexiones internas fuertes (Eco-chambers)
edges_favor <- data.frame(
  from = sample(users_favor, 90, replace = TRUE), 
  to   = sample(users_favor, 90, replace = TRUE)
)

edges_contra <- data.frame(
  from = sample(users_contra, 90, replace = TRUE), 
  to   = sample(users_contra, 90, replace = TRUE)
)

# 2. Conexiones externas débiles (Puentes entre bandos)
edges_conflicto <- data.frame(
  from = sample(users_favor, 3, replace = TRUE), 
  to   = sample(users_contra, 3, replace = TRUE)
)

edges_all <- rbind(edges_favor, edges_contra, edges_conflicto)

# 3. Añadir neutrales dispersos
if(length(users_neutral) > 0){
  edges_neutral <- data.frame(
    from = sample(users_neutral, 15, replace = TRUE), 
    to   = sample(nodes$id, 15, replace = TRUE)
  )
  edges_all <- rbind(edges_all, edges_neutral)
}

# Crear el objeto grafo
g <- graph_from_data_frame(d = edges_all, vertices = nodes, directed = FALSE)

# Asignar atributos visuales
V(g)$color <- ifelse(V(g)$group == "a_favor", "firebrick3",
                     ifelse(V(g)$group == "en_contra", "dodgerblue4", "grey70"))
V(g)$frame.color <- "white"

# --- Guardar imagen de alta calidad ---
png("red_final.png", width = 2200, height = 1600, res = 150)

# Layout Fruchterman-Reingold (fuerza dirigida)
l <- layout_with_fr(g, niter=1000, grid="nogrid") 

plot(g,
     layout = l,
     # Nodos
     vertex.size = 7,
     vertex.label = NA,  # Sin nombres
     # Aristas
     edge.width = 0.6,
     edge.color = adjustcolor("black", alpha.f = 0.4),
     # Títulos
     main = "Polarización en Redes Sociales: Bloques Enfrentados",
     cex.main = 1.8
)

# Leyenda personalizada
legend("bottomright", 
       legend = c("Bloque A Favor (Vito)", "Bloque En Contra", "Neutrales"), 
       col = c("firebrick3", "dodgerblue4", "grey70"), 
       pch = 21,
       pt.bg = c("firebrick3", "dodgerblue4", "grey70"), 
       pt.cex = 2.5,
       cex = 1.2,    
       bty = "o",
       bg = "white",
       box.col = "black",
       title = "Posicionamiento",
       inset = 0.02)

dev.off() # Cierra el dispositivo gráfico

