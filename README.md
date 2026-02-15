# 🕸️ Social Network Analysis: Polarization on X (Twitter)

<div align="left">
  <img width="200" height="300" alt="RStudio-Logo-Flat" src="https://github.com/user-attachments/assets/d96d466f-29a3-41d8-97dc-3add906ac8b9" />

</div>
<br/>

**Subject:** Applications of Data Science and Social Networks


**Tools:** R (igraph, tm, e1071), SNA, Support Vector Machine (SVM)


**Keywords:** Sentiment Analysis, Network Topology, Digital Polarization

## 👥 Authors
Project developed by:
* **Pablo Galarón Mateo**

---

This project investigates the phenomenon of **affective polarization** on social media. Using data extracted from X (Twitter) regarding the controversial visits of public figures to Spanish universities, I analyzed how digital communities organize themselves into isolated "echo chambers."

The study combines text mining with social network analysis to determine if digital debate allows for neutrality or if it forces users into two hermetic, opposing blocks.

### 🛠️ Methodology & Technical Pipeline
* **Data Processing:** Cleaned and pre-processed 100+ tweets, handling emojis, special characters, and stop words using R.
* **Text Mining & NLP:** Generated word clouds to contrast the vocabularies of opposing groups, identifying key radicalization terms.
* **Supervised Learning (SVM):** Trained a **Support Vector Machine** model to classify user sentiment. The model achieved an **Accuracy of 73%** in identifying partisan positions based on text patterns.
* **SNA (Social Network Analysis):** Modeled the network using the **Fruchterman-Reingold** layout to visualize the absence of a "neutral bridge" between communities.



### 💡 Key Findings
* **Structural Segmentation:** The network graph confirms a clear split into two hermetic blocks with almost no interaction between them.
* **Digital Amplification:** Social media dynamics accelerate the radicalization of physical events, transforming local protests into national-scale digital conflicts.
* **Vocabulary Divergence:** Opposing groups use mutually exclusive terminologies, reinforcing the "Us vs. Them" narrative.

### 📂 Files in this repo
* `📄 Trabajo_Final_Polarización_...pdf`: The complete academic research paper.
* `📊 Presentación_Polarización_...pdf`: Executive summary presentation.
* `⚙️ Script_Trabajo_Final_...R`: Complete R source code for analysis and SNA visualization.
* `📂 data/`: Dataset containing the analyzed tweets.

---

Este proyecto investiga el fenómeno de la **polarización afectiva** en redes sociales. Utilizando datos de X (Twitter) sobre las visitas de figuras públicas a universidades españolas, analicé cómo las comunidades digitales se organizan en "cámaras de eco" aisladas.

El estudio combina minería de textos con análisis de redes sociales para determinar si el debate digital permite la neutralidad o si fuerza a los usuarios a dividirse en dos bloques herméticos y opuestos.

### 🛠️ Metodología y Flujo Técnico
* **Procesamiento de Datos:** Limpieza de más de 100 tuits, gestionando emojis, caracteres especiales y palabras vacías en R.
* **Minería de Textos (NLP):** Generación de nubes de palabras para contrastar los vocabularios de los grupos enfrentados.
* **Aprendizaje Supervisado (SVM):** Entrenamiento de un modelo **Support Vector Machine** para clasificar el sentimiento. El modelo alcanzó un **Accuracy del 73%**.
* **SNA (Análisis de Redes):** Modelado del grafo de la red usando el layout **Fruchterman-Reingold** para visualizar la fractura social en la red.

### 💡 Conclusiones Principales
* **Segmentación Estructural:** El grafo confirma una división clara en dos bloques sin puentes de entendimiento.
* **Amplificación Digital:** Las redes aceleran la radicalización de eventos físicos, convirtiendo conflictos locales en debates nacionales instantáneos.
* **Divergencia de Vocabulario:** Los grupos enfrentados utilizan términos mutuamente excluyentes, reforzando la narrativa de "Nosotros contra Ellos".

### 📂 Archivos en este repo
* `📄 Trabajo_Final_Polarización_...pdf`: El informe académico completo con todo el rigor estadístico.
* `📊 Presentación_Polarización_...pdf`: Presentación ejecutiva con los gráficos y resultados principales.
* `⚙️ Script_Trabajo_Final_...R`: Código fuente completo en R para el análisis SNA y la visualización de redes.
* `📂 data/`: Carpeta que contiene el dataset de los tuits analizados (`tweets.csv`).
