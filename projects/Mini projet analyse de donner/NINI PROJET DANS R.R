#installation du package tm
#install.packages('tm')
library(tm)

donnees <-Corpus(DirSource('data_AD'))#creation du corpus 
inspect(donnees )

#pr??traitement
toSpace <-content_transformer(function(x,pattern){return(gsub(pattern," ",x))})
donnees  <- tm_map(donnees , content_transformer(tolower))#transformer en minuscule
donnees  <- tm_map(donnees , toSpace, " a ")
donnees  <- tm_map(donnees , toSpace, " l'")
donnees  <- tm_map(donnees , toSpace, " j'")
donnees  <- tm_map(donnees , toSpace, " c' ")
donnees  <- tm_map(donnees , toSpace, " l ")
donnees  <- tm_map(donnees , toSpace, "\\W")
donnees  <- tm_map(donnees , toSpace, "-")
donnees  <- tm_map(donnees , toSpace, " \"")

donnees  <- tm_map(donnees , removePunctuation)#supprimer la ponctuation
donnees  <- tm_map(donnees , removeNumbers)# supprimer les numero
donnees  <- tm_map(donnees ,removeWords,stopwords("french"))# supprim??s Les mots fr??quents
donnees  <- tm_map(donnees , stripWhitespace)# supprimer les espaces blancs



#install.packages('SnowballC')
library(SnowballC)
steem<- tm_map(donnees, stemDocument, language="french")

steem <- tm_map(steem,content_transformer(gsub), pattern = "arriv??", replacement = "arriv")
steem <- tm_map(steem,content_transformer(gsub), pattern = "annul??", replacement = "annul")
steem <- tm_map(steem,content_transformer(gsub), pattern = "compter", replacement = "compt")
steem <- tm_map(steem,content_transformer(gsub), pattern = "fermer", replacement = "ferm")
steem <- tm_map(steem,content_transformer(gsub), pattern = "montr??", replacement = "montrer")
steem <- tm_map(steem,content_transformer(gsub), pattern = "perdront", replacement = "perdr")
steem <- tm_map(steem,content_transformer(gsub), pattern = "aider", replacement = "aid")
steem <- tm_map(steem,content_transformer(gsub), pattern = "??tendra", replacement = "??tendr")
steem <- tm_map(steem,content_transformer(gsub), pattern = "africain", replacement = "afriqu")
steem <- tm_map(steem,content_transformer(gsub), pattern = "qualifiera", replacement = "qualifi??")
steem <- tm_map(steem,content_transformer(gsub), pattern = "qualifiait", replacement = "qualifi??")
steem <- tm_map(steem,content_transformer(gsub), pattern = "rappeur", replacement = "rap")
steem <- tm_map(steem,content_transformer(gsub), pattern = "remport??", replacement = "remport")
steem <- tm_map(steem,content_transformer(gsub), pattern = "repr??sent??", replacement = "repr??sent")
steem <- tm_map(steem,content_transformer(gsub), pattern = "am??rique", replacement = "am??ricain")
steem <- tm_map(steem,content_transformer(gsub), pattern = "attendu", replacement = "attend")
steem <- tm_map(steem,content_transformer(gsub), pattern = "br??silien", replacement = "br??sil")
steem <- tm_map(steem,content_transformer(gsub), pattern = "championnat", replacement = "champion")
steem <- tm_map(steem,content_transformer(gsub), pattern = "comptera", replacement = "compt??")
steem <- tm_map(steem,content_transformer(gsub), pattern = "donn??", replacement = "donn")
steem <- tm_map(steem,content_transformer(gsub), pattern = "donnera", replacement = "donn")
steem <- tm_map(steem,content_transformer(gsub), pattern = "d??cid??", replacement = "d??cision")
steem <- tm_map(steem,content_transformer(gsub), pattern = "footballeur", replacement = "football")
steem <- tm_map(steem,content_transformer(gsub), pattern = "gagnera", replacement = "gagnait")
steem <- tm_map(steem,content_transformer(gsub), pattern = "g??n??rera", replacement = "g??n??rer")
steem <- tm_map(steem,content_transformer(gsub), pattern = "huit", replacement = "huiti??m")
steem <- tm_map(steem,content_transformer(gsub), pattern = "joue", replacement = "jeu")
steem <- tm_map(steem,content_transformer(gsub), pattern = "joueur", replacement = "jeu")
steem <- tm_map(steem,content_transformer(gsub), pattern = "jouer", replacement = "jeu")
steem <- tm_map(steem,content_transformer(gsub), pattern = "marocain", replacement = "maroc")
steem <- tm_map(steem,content_transformer(gsub), pattern = "passera", replacement = "passant")
steem <- tm_map(steem,content_transformer(gsub), pattern = "portant", replacement = "porter")
steem <- tm_map(steem,content_transformer(gsub), pattern = "port??", replacement = "porter")
steem <- tm_map(steem,content_transformer(gsub), pattern = "pourrait", replacement = "pourra")
steem <- tm_map(steem,content_transformer(gsub), pattern = "prennent", replacement = "prend")

donnees_matrix <- TermDocumentMatrix(steem)
m<- as.matrix(donnees_matrix)


# Analyse a l'aide de L'AFC 
install.packages("FactoMineR")
library(FactoMineR)
install.packages("factoextra")
library(factoextra)

summary(as.table(m))
#calculer l???AFC
m.ca=CA(m,graph=F)
#Valeurs propres / Variances
eig.val <- get_eigenvalue(m.ca)
eig.val

# repel = TRUE pour ??viter le chevauchement de texte
fviz_ca_biplot (m.ca, repel = TRUE)
fviz_ca_row(m.ca, repel = TRUE)

fviz_ca_row (m.ca, col.row = "steelblue", shape.row = 15)
################Qualit?? de repr??sentation des lignes

# Colorer en fonction du cos2:
fviz_ca_row (m.ca, col.row = "cos2",
             gradient.cols = c ("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE,title="Graphe de qualit?? de repr??sentation des mots")

################Contributions des lignes aux dimensions
# Contributions des lignes ?? la dimension 1
fviz_contrib(m.ca, choice = "row", axes = 1, top = 20)
# Contributions des lignes ?? la dimension 2
fviz_contrib(m.ca, choice = "row", axes = 2, top = 10)

# Contribution des lignes totale aux dimensions 1 et 2
fviz_contrib (m.ca, choice = "row", axes = 1:2, top = 10)

#Les lignes les plus importantes (ou contributives) peuvent ??tre mise en avant sur le graphique comme suit:

fviz_ca_row (m.ca, col.row = "contrib",
             gradient.cols = c ("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE,title="Graphe repr??sente la contribution des mots sur les 2 dim ")

################Qualit?? de repr??sentation des colonnes


# Colorer en fonction du cos2:
fviz_ca_col (m.ca, col.col = "cos2",
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
             repel = TRUE )

#Pour visualiser la contribution des colonnes aux deux dimensions
fviz_contrib (m.ca, choice = "col", axes = 1:2)




#ACP
pca=PCA(steem_matrix,scale.unit=TRUE,graph=T)
summary(pca)
#calculer les valeurs propres et variances
eig.val=get_eigenvalue(pca)
eig.val
fviz_eig(pca, addlabels = TRUE)

#visualisation des individus
fviz_pca_ind(pca, repel = TRUE)
#graphe des var et individus
fviz_pca_biplot(pca, repel=TRUE)






