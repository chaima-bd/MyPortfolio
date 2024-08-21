# ----------- Les bibliothèques

library(tm)
library(tm.plugin.webmining)
library(SnowballC)
library(XML)
library(RCurl)
library(httr)

# Path

# Linux
setwd ("~/schneide/methodo/R")
# Windows
# setwd("s:/methodo/R")
setwd("c:/dks/methodo/R")
getwd()

# Extraire toutes les pages d'une catégorie, 
# InternalNodes=TRUE est du Vodoo crucial à ajouter.
categ <- "http://edutechwiki.unige.ch/fmediawiki/api.php?action=query&list=categorymembers&cmtitle=Category:Jeux_p%C3%A9dagogiques&cmlimit=500&cmtype=page&format=xml"
liste_XML <- xmlTreeParse(categ,useInternalNodes = TRUE) 
#vérifier
class (liste_XML)
# extraire les éléments qui définissent une page, sans les pages qui ont template
# Xpath qui trouve les mauvais: //cm[contains(@title,'Template')] 
liste_XML2 <- xpathSApply(liste_XML, "//cm[not(contains(@title,'Template'))]")
# on produite deux vecteurs avec titres et ID wiki de la page
liste_titres = sapply(liste_XML2, function(el) xmlGetAttr(el, "title"))
liste_ids = sapply(liste_XML2, function(el) xmlGetAttr(el, "pageid"))
# vérifier
liste_titres
liste_ids

# ----------- Mettre des pages wiki dans un corpus ------------

# début et fin de l'URL. Notez le "pageid" qui va nous sortir un article avec sa "pageid"
url_start <- "http://edutechwiki.unige.ch/fmediawiki/api.php?action=parse&pageid="
url_end <- "&format=xml"

article_id_list <- character(length(liste_ids))

for (i in 1:length(liste_ids)) {
  article_id_list[i] <- (paste (url_start,liste_ids[i],url_end, sep=""))
}
#Vérification
article_id_list

# On construit le corpus en utilisant un reader fait par nous et
# Cette fonction extrait juste l'élément XML "text" (voir l'API des mediawiki)
readMWXML <- 
  readXML (spec = list (content = list ("node", "//text"),
                        heading = list ("attribute", "//parse/@title")
                        ),
                        doc=PlainTextDocument())

# On télécharge, prend qqs. dizaines de secondes
wiki.source <- VCorpus(URISource(article_id_list, encoding="UTF-8"),
                      readerControl=list(reader=readMWXML, language="fr"))
names(wiki.source)
                    
# On change les "id" (titres à la place d'URLs illisibles)
for (j in seq.int (wiki.source)) {
  meta(wiki.source[[j]],"id") <- liste_titres[j]
}

names(wiki.source)

# Ajouter une balise html autour du tout - c'est du bon vodoo
wiki.source <- tm_map (wiki.source, encloseHTML)
# Ecrire les fragments HTML dans des fichiers (inutile, mais permet l'inspection)
writeCorpus(wiki.source, path="./wiki_txt_html")

# ------------------------------- Nettoyage du texte

# Mettre tout en minuscules
# Le code suivant ne semble PAS marcher !!!
# wiki.clean3 <- tm_map (wiki.clean2c, tolower)
# Utiliser cela
wiki.cl1 <- tm_map(wiki.source, content_transformer(tolower))

# Tuer les balises. Attention à l'encodage !! 
# Empêche le stemmer de marcher :(
# wiki.cl2 <- tm_map (wiki.cl1, extractHTMLStrip, encoding="UTF-8")
# Ceci marche mieux
wiki.cl2 <- tm_map(wiki.cl1, content_transformer(extractHTMLStrip))

# kill_chars est une fonction pour nettoyage custom 
# ... ne pas utiliser une boucle "for" pour un Corpus, ou il est naze
# curly quotes = \u2019
(kill_chars <- content_transformer (function(x, pattern) gsub(pattern, " ", x)))

wiki.cl2 <- tm_map (wiki.cl2, kill_chars, "\u2019")
wiki.cl2 <- tm_map (wiki.cl2, kill_chars,"'")
wiki.cl2 <- tm_map (wiki.cl2, kill_chars,"\\[modifier\\]")
wiki.cl2 <- tm_map (wiki.cl2, kill_chars,"[«»”“\"]")

# enlever les ponctuations qui restent
wiki.cl3 <- tm_map (wiki.cl2, removePunctuation, preserve_intra_word_dashes = TRUE)

# Tuer les mots fréquents (stop words)
wiki.essence <- tm_map (wiki.cl3, removeWords, stopwords("french"))

# Extraire les racines. La bibliothèque SnowballC doit être installée.
# Ne semble pas marcher après des transformations fait sans "tm_map" !!
getStemLanguages()
wiki.racines <- tm_map (wiki.essence, stemDocument, language="french")

# Enlever des blancs s'il en reste
wiki.racines <- tm_map (wiki.racines, stripWhitespace)

# test
wiki.racines[[2]]
class(wiki.racines)

# ------------------------------- Enregistrer une version clean

# Du Vodoo pour de nouveau créer un "vrai corpus", qc. semble manquer
wiki.mots <- Corpus(VectorSource(wiki.racines))
# On change les "id" (titres à la place de numéros)
for (j in seq.int (wiki.mots)) {
  file_name <- gsub (" ", "-", liste_titres[j])
  file_name <- gsub ("%27", "-", file_name)
  file_name <- gsub ("%E2%80%99", "-", file_name)
  meta(wiki.mots[[j]],"id") <- file_name
}

summary(wiki.mots)
names(wiki.mots)

writeCorpus(wiki.mots, path="./wiki_txt_clean")

# ------------------------------ Analyses 

# termes en colonne
matrice_docs_termes <- (DocumentTermMatrix(wiki.mots))

# find frequent words, works with either
# findFreqTerms(matrice_docs_termes, 30)
findFreqTerms(matrice_docs_termes, 60)

# find associations with a word (lower the number for many documents)
findAssocs(matrice_termes_docs, "feedback", 0.8)
findAssocs(matrice_termes_docs, "feedback", 0.5)
findAssocs(matrice_termes_docs, "jeu", 0.6)

# Reduce Matrix to terms used in most/all documents
inspect(removeSparseTerms(matrice_termes_docs, 0.4))
inspect(matrice_termes_docs)

#Test Zipf and Heaps laws
Zipf_plot(matrice_termes_docs)
Heaps_plot(matrice_termes_docs)

# Afficher les proximitiés d'une matrice
library(corrplot)

# Créer une DTM avec des poids normalisées
mtd.norm <- as.matrix(removeSparseTerms(
  TermDocumentMatrix(wiki.mots, control=list(weighting=weightTf)),
  0.2))

corrplot (mtd.norm, is.corr=FALSE)

# Créer une DTM avec des poids TFIdf
mtd.TfIdf04 <- as.matrix(removeSparseTerms(
  TermDocumentMatrix(wiki.mots, control=list(weighting=weightTfIdf)),
  0.4))

corrplot (mtd.TfIdf04, is.corr=FALSE)

# Créer une DTM avec des poids TfIdf sans les termes rares et frequents
mtd.norm_sans <- as.matrix(
  removeSparseTerms(
    TermDocumentMatrix(
      tm_map(wiki.mots, removeWords, c("jeu", "jeux", "joueur")),
      control=list(weighting=weightTfIdf)
    ),
    0.2)
)

corrplot (mtd.norm_sans, is.corr=FALSE)

mtd.TfIdf02 <- as.matrix(removeSparseTerms(
  TermDocumentMatrix(wiki.mots, control=list(weighting=weightTfIdf)),
  0.2))

corrplot (mtd.TfIdf02, is.corr=FALSE)

# -------------------- word clouds

# Afficher les palettes des couleurs pour choisir ensuite
display.brewer.all()

# Wordclouds
library(wordcloud)
wordcloud(wiki.racines,
          scale=c(5,0.1), rot.per=0.35, 
          min.freq=3, use.r.layout=FALSE,
          colors= brewer.pal(8,"Spectral")
          )

wordcloud(as.vector(wiki.racines[[8]]),
          scale=c(5,0.1), rot.per=0.35, 
          min.freq=3, use.r.layout=FALSE,
          colors= brewer.pal(8,"Spectral")
)

wordcloud (words (wiki.racines[[2]]),
          scale=c(5,0.1), rot.per=0.35, 
          min.freq=3, use.r.layout=FALSE,
          colors= brewer.pal(8,"Spectral")
)

wordcloud(words (wiki.racines[[3]]),
          scale=c(5,0.1), rot.per=0.35, 
          min.freq=3, use.r.layout=FALSE,
          colors= brewer.pal(8,"Spectral")
)

#Communality clouds

mtd <- as.matrix(matrice_termes_docs)
comparison.cloud(mtd,random.order=FALSE,
                 scale=c(5,0.5), rot.per=0.35, 
                 max.words=50, use.r.layout=FALSE,
                 colors= brewer.pal(8,"Spectral")
)
commonality.cloud(mtd,random.order=FALSE,
                  scale=c(5,0.5), rot.per=0.35, 
                  max.words=50, use.r.layout=FALSE,
                  colors= brewer.pal(8,"Spectral")
)

#Without the "jeu"

wiki.sans_jeu <- tm_map(wiki.mots, removeWords, c("jeu", "jeux"))
mtd2 <- TermDocumentMatrix(wiki.sans_jeu)
mtd2 <- as.matrix(mtd2)
commonality.cloud(mtd2,
                  scale=c(2,0.5), rot.per=0.35, 
                  max.words=40, use.r.layout=FALSE,
                  colors= brewer.pal(11,"Spectral")
)

# --------------------- analyse multi-variées avec les tdm ------

# vérifier un peu les données
# mots qui apparissent plus que 100 fois

findFreqTerms (DocumentTermMatrix(wiki.mots),100)
findAssocs (DocumentTermMatrix(wiki.mots), "jeu", 0.5)

# library(fpc)

# Créer une DTM avec des poids TfIdf 
mtd4.TfIdf <- (DocumentTermMatrix(wiki.mots, control=list(weighting=weightTfIdf)))

# show docs X terms
dim(mtd4.TfIdf)
# Inspecter premiers 5 docs et les termes 8000-8005
inspect (mtd4.TfIdf[1:5, 500:505])

mtd4.TfIdf02 <- as.matrix(removeSparseTerms(
  DocumentTermMatrix(wiki.mots, control=list(weighting=weightTfIdf)),
  0.79))
dim(mtd4.TfIdf02)

mtd4.TfIdf03 <- as.matrix(removeSparseTerms(
  DocumentTermMatrix(wiki.mots, control=list(weighting=weightTfIdf)),
  0.63))
dim(mtd4.TfIdf03)

# --- Hierachical cluster 

# compute a distance matrix and then apply hclust
dist4 <- dist(mtd4.TfIdf, method="euclidean")
dist4
hc4 <- hclust(dist4, method="ward.D2")
plot(hc4)

# same with other params

dist5 <- dist(mtd4.TfIdf02, method="euclidean")
dist5
hc5 <- hclust(dist5, method="ward.D2")
plot(hc5)

dist6 <- dist(mtd4.TfIdf03, method="euclidean")
dist6
hc5 <- hclust(dist6, method="ward.D2")
plot(hc5)

# principal components non-linear (works)

library (kernlab)
pca2 <- kpca (as.matrix(mtd4.TfIdf02), features=2)
plot( rotated(pca2), pty="s",
      xlab="1st Principal Component", ylab="2nd Principal Component" )